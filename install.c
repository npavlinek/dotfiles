#define _XOPEN_SOURCE 700

#include <assert.h>
#include <limits.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ArraySize(array) (sizeof(array) / sizeof(array[0]))

typedef enum {
   SYM_LINK_RESULT_OK,
   SYM_LINK_RESULT_INSUFFICIENT_PRIVILEGE,
   SYM_LINK_RESULT_ALREADY_EXISTS,
   SYM_LINK_RESULT_UNKNOWN
} SymLinkResult;

typedef struct {
   const char * source;
   struct {
      const char * linux;
      const char * windows;
   } destination;
} ConfigFile;

static ConfigFile config_files[] = {
   {.source = "emacs", .destination = {.linux = "$HOME/.emacs.d", .windows = "%APPDATA%\\.emacs.d"}},
   {.source = "gitconfig", .destination = {.linux = "$HOME/.gitconfig", .windows = "%USERPROFILE%\\.gitconfig"}},
   {.source = "openbox", .destination = {.linux = "$HOME/.config/openbox", .windows = NULL}},
   {.source = "vim", .destination = {.linux = "$HOME/.vim", .windows = "%USERPROFILE%\\vimfiles"}},
   {.source = "xinitrc", .destination = {.linux = "$HOME/.xinitrc", .windows = NULL}}
};

////////////////////////////////////////////////////////////////////////////////
// Required platform API
////////////////////////////////////////////////////////////////////////////////

static void GetAbsolutePathToSource(const char * source, char * buffer, unsigned int buffer_size);
static void GetAbsolutePathToDestination(const char * destination, char * buffer, unsigned int buffer_size);
static bool IsDirectory(const char * path);
static SymLinkResult CreateSymLink(const char * source, const char * destination, bool is_directory);

#ifdef _WIN32

// TODO: Add support for Unicode characters in file and directory names.

#define WIN32_LEAN_AND_MEAN
#include <windows.h>

#define MAXIMUM_PATH_LENGTH MAX_PATH

static void GetAbsolutePathToSource(const char * source, char * buffer, unsigned int buffer_size)
{
   const DWORD result = GetFullPathNameA(source, buffer_size, buffer, NULL);
   assert(result != 0);
}

static void GetAbsolutePathToDestination(const char * destination, char * buffer, unsigned int buffer_size)
{
   const DWORD result = ExpandEnvironmentStringsA(destination, buffer, buffer_size);
   assert(result != 0);
}

static bool IsDirectory(const char * path)
{
   const DWORD result = GetFileAttributesA(path);
   assert(result != INVALID_FILE_ATTRIBUTES);
   return result & FILE_ATTRIBUTE_DIRECTORY;
}

static SymLinkResult CreateSymLink(const char * source, const char * destination, bool is_directory)
{
   DWORD symlink_flags = SYMBOLIC_LINK_FLAG_ALLOW_UNPRIVILEGED_CREATE;
   if (is_directory)
      symlink_flags |= SYMBOLIC_LINK_FLAG_DIRECTORY;
   if (CreateSymbolicLinkA(destination, source, symlink_flags) == 0) {
      const DWORD error = GetLastError();
      if (error == ERROR_PRIVILEGE_NOT_HELD)
         return SYM_LINK_RESULT_INSUFFICIENT_PRIVILEGE;
      else if (error == ERROR_ALREADY_EXISTS)
         return SYM_LINK_RESULT_ALREADY_EXISTS;
      else
         return SYM_LINK_RESULT_UNKNOWN;
   }
   return SYM_LINK_RESULT_OK;
}

#elif __linux__

#include <errno.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <wordexp.h>

#define MAXIMUM_PATH_LENGTH PATH_MAX

static void GetAbsolutePathToSource(const char * source, char * buffer, unsigned int buffer_size)
{
   (void)buffer_size;
   const char * result = realpath(source, buffer);
   assert(result != NULL);
}

static void GetAbsolutePathToDestination(const char * destination, char * buffer, unsigned int buffer_size)
{
   (void)buffer_size;
   wordexp_t p = {0};
   const int result = wordexp(destination, &p, 0);
   assert(result == 0);
   memcpy(buffer, p.we_wordv[0], strlen(p.we_wordv[0]));
   wordfree(&p);
}

static bool IsDirectory(const char * path)
{
   struct stat s = {0};
   const int result = stat(path, &s);
   assert(result == 0);
   return s.st_mode & S_IFDIR;
}

static SymLinkResult CreateSymLink(const char * source, const char * destination, bool is_directory)
{
   (void)is_directory;
   if (symlink(source, destination) == -1) {
      if (errno == EACCES)
         return SYM_LINK_RESULT_INSUFFICIENT_PRIVILEGE;
      else if (errno == EEXIST)
         return SYM_LINK_RESULT_ALREADY_EXISTS;
      else
         return SYM_LINK_RESULT_UNKNOWN;
   }
   return SYM_LINK_RESULT_OK;
}

#else
#error Unsupported platform
#endif

int main(void)
{
   for (size_t i = 0; i < ArraySize(config_files); ++i) {
      const ConfigFile file = config_files[i];

      char source_abs_path[MAXIMUM_PATH_LENGTH] = {0};
      GetAbsolutePathToSource(file.source, source_abs_path, ArraySize(source_abs_path));

#ifdef _WIN32
      const char * destination = file.destination.windows;
#elif __linux__
      const char * destination = file.destination.linux;
#endif
      if (destination == NULL)
         continue;
      char destination_abs_path[MAXIMUM_PATH_LENGTH] = {0};
      GetAbsolutePathToDestination(destination, destination_abs_path, ArraySize(destination_abs_path));

      const bool is_directory = IsDirectory(source_abs_path);
      const SymLinkResult result = CreateSymLink(source_abs_path, destination_abs_path, is_directory);
      if (result == SYM_LINK_RESULT_INSUFFICIENT_PRIVILEGE) {
         fprintf(stderr, "error: cannot create a symbolic link because of insufficient privileges, either run this program as an administrator or enable Developer Mode in Windows 10\n");
         exit(1);
      } else if (result == SYM_LINK_RESULT_ALREADY_EXISTS) {
         if (is_directory)
            fprintf(stderr, "warning: directory already exists at %s\n", destination_abs_path);
         else
            fprintf(stderr, "warning: file already exists at %s\n", destination_abs_path);
      } else if (result == SYM_LINK_RESULT_UNKNOWN) {
         fprintf(stderr, "error: please debug me\n");
         exit(1);
      } else
         printf("%s -> %s\n", source_abs_path, destination_abs_path);
   }
}
