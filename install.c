#define _XOPEN_SOURCE 700

#include <assert.h>
#include <stdio.h>
#include <string.h>

#define array_size(array) (sizeof(array) / sizeof(array[0]))

typedef enum symlink_result symlink_result;
typedef struct file_path file_path;
typedef unsigned char bool8;

enum {
   B_FALSE = 0,
   B_TRUE = 1
};

enum symlink_result {
   SYMLINK_RESULT_OK,
   SYMLINK_RESULT_INSUFFICIENT_PRIVILEGE,
   SYMLINK_RESULT_ALREADY_EXISTS,
   SYMLINK_RESULT_UNKNOWN
};

struct file_path {
   const char *src;
   struct {
      const char *linux;
      const char *windows;
   } dst;
};

static file_path config_files[] = {
/*
   +--------------------------------------------------------------------------+
   |  Source      |  Linux                 |  Windows                         |
   +--------------+------------------------+----------------------------------+
*/
   { "emacs",     { "$HOME/.emacs.d",        "%APPDATA%\\.emacs.d"          } },
   { "gitconfig", { "$HOME/.gitconfig",      "%USERPROFILE%\\.gitconfig"    } },
   { "hgrc",      { "$HOME/.config/hg/hgrc", "%USERPROFILE%\\mercurial.ini" } },
   { "nvim",      { "$HOME/.config/nvim",    "%LOCALAPPDATA%\\nvim"         } },
   { "openbox",   { "$HOME/.config/openbox", NULL                           } },
   { "vim",       { "$HOME/.vim",            "%USERPROFILE%\\vimfiles"      } },
   { "xinitrc",   { "$HOME/.xinitrc",        NULL                           } }
};

/**************************************************
  Required platform API
 *************************************************/

static void get_absolute_src_path(const char *src, char *buf, unsigned int buf_size);
static void get_absolute_dst_path(const char *dst, char *buf, unsigned int buf_size);
static bool8 is_directory(const char *path);
static symlink_result create_symlink(const char *src, const char *dst, bool8 dir);

/*************************************************/

#ifdef _WIN32

/* @todo: Add support for Unicode characters in file and directory names. */

#define WIN32_LEAN_AND_MEAN
#include <windows.h>

#define MAX_PATH_LEN MAX_PATH

static void get_absolute_src_path(const char *src, char *buf, unsigned int buf_size)
{
   DWORD result;
   result = GetFullPathNameA(src, buf_size, buf, NULL);
   assert(result != 0);
}

static void get_absolute_dst_path(const char *dst, char *buf, unsigned int buf_size)
{
   DWORD result;
   result = ExpandEnvironmentStringsA(dst, buf, buf_size);
   assert(result != 0);
}

static bool8 is_directory(const char *path)
{
   DWORD result;
   result = GetFileAttributesA(path);
   assert(result != INVALID_FILE_ATTRIBUTES);
   return result & FILE_ATTRIBUTE_DIRECTORY ? B_TRUE : B_FALSE;
}

static symlink_result create_symlink(const char *src, const char *dst, bool8 dir)
{
   DWORD symlink_flags, error;
   symlink_flags = SYMBOLIC_LINK_FLAG_ALLOW_UNPRIVILEGED_CREATE;
   if (dir)
      symlink_flags |= SYMBOLIC_LINK_FLAG_DIRECTORY;
   if (CreateSymbolicLinkA(dst, src, symlink_flags) == 0) {
      error = GetLastError();
      if (error == ERROR_PRIVILEGE_NOT_HELD)
         return SYMLINK_RESULT_INSUFFICIENT_PRIVILEGE;
      else if (error == ERROR_ALREADY_EXISTS)
         return SYMLINK_RESULT_ALREADY_EXISTS;
      else
         return SYMLINK_RESULT_UNKNOWN;
   }
   return SYMLINK_RESULT_OK;
}

#elif __linux__

#include <errno.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <wordexp.h>

#define MAX_PATH_LEN PATH_MAX

static void get_absolute_src_path(const char *src, char *buf, unsigned int buf_size)
{
   const char *result;
   (void)buf_size;
   result = realpath(src, buf);
   assert(result);
}

static void get_absolute_dst_path(const char *dst, char *buf, unsigned int buf_size)
{
   wordexp_t p;
   int result;
   (void)buf_size;
   result = wordexp(dst, &p, 0);
   assert(result == 0);
   memcpy(buf, p.we_wordv[0], strlen(p.we_wordv[0]));
   wordfree(&p);
}

static bool8 is_directory(const char *path)
{
   struct stat s;
   int result;
   result = stat(path, &s);
   assert(result == 0);
   return s.st_mode & S_IFDIR ? B_TRUE : B_FALSE;
}

static symlink_result create_symlink(const char *src, const char *dst, bool8 dir)
{
   (void)dir;
   if (symlink(src, dst) == -1) {
      if (errno == EACCES)
         return SYMLINK_RESULT_INSUFFICIENT_PRIVILEGE;
      else if (errno == EEXIST)
         return SYMLINK_RESULT_ALREADY_EXISTS;
      else
         return SYMLINK_RESULT_UNKNOWN;
   }
   return SYMLINK_RESULT_OK;
}

#else

#error Unsupported platform

#endif

int main(void)
{
   size_t i;
   file_path file;
   char absolute_src_path[MAX_PATH_LEN];
   char absolute_dst_path[MAX_PATH_LEN];
   const char *dst;
   bool8 dir;
   symlink_result result;

   for (i = 0; i < array_size(config_files); ++i) {
      file = config_files[i];
      get_absolute_src_path(file.src, absolute_src_path, array_size(absolute_src_path));

#ifdef _WIN32
      dst = file.dst.windows;
#elif __linux__
      dst = file.dst.linux;
#else
      dst = NULL;
#endif
      if (!dst)
         continue;

      get_absolute_dst_path(dst, absolute_dst_path, array_size(absolute_dst_path));
      dir = is_directory(absolute_src_path);
      result = create_symlink(absolute_src_path, absolute_dst_path, dir);

      if (result == SYMLINK_RESULT_INSUFFICIENT_PRIVILEGE) {
         fprintf(stderr, "error: cannot create a symbolic link because of insufficient privileges, either run this program as an administrator or enable Developer Mode in Windows 10\n");
         return 1;
      } else if (result == SYMLINK_RESULT_ALREADY_EXISTS) {
         if (dir)
            fprintf(stderr, "warning: directory already exists at %s\n", absolute_dst_path);
         else
            fprintf(stderr, "warning: file already exists at %s\n", absolute_dst_path);
      } else if (result == SYMLINK_RESULT_UNKNOWN) {
         fprintf(stderr, "error: please debug me\n");
         return 1;
      } else
         printf("%s -> %s\n", absolute_src_path, absolute_dst_path);
   }
   return 0;
}
