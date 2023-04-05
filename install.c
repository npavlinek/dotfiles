#define _XOPEN_SOURCE 700

#include <assert.h>
#include <limits.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define array_size(array) (sizeof(array) / sizeof(array[0]))

typedef enum {
  SYMLINK_RESULT_TYPE_OK,
  SYMLINK_RESULT_TYPE_INSUFFICIENT_PRIVILEGE,
  SYMLINK_RESULT_TYPE_ALREADY_EXISTS,
  SYMLINK_RESULT_TYPE_UNKNOWN
} symlink_result_type;

typedef struct {
  const char *src;
  struct {
    const char *linux;
    const char *windows;
  } dest;
} config_file;

static config_file config_files[] = {
  {.src = "emacs", .dest = {.linux = "$HOME/.emacs.d", .windows = "%APPDATA%\\.emacs.d"}},
  {.src = "gitconfig", .dest = {.linux = "$HOME/.gitconfig", .windows = "%USERPROFILE%\\.gitconfig"}},
  {.src = "nvim", .dest = {.linux = "$HOME/.config/nvim", .windows = "%LOCALAPPDATA%\\nvim"}},
  {.src = "openbox", .dest = {.linux = "$HOME/.config/openbox", .windows = NULL}},
  {.src = "vim", .dest = {.linux = "$HOME/.vim", .windows = "%USERPROFILE%\\vimfiles"}},
  {.src = "xinitrc", .dest = {.linux = "$HOME/.xinitrc", .windows = NULL}}
};

////////////////////////////////////////////////////////////////////////////////
// Required platform API
////////////////////////////////////////////////////////////////////////////////

static void get_absolute_path_to_src(const char *src, char *buf, unsigned int buf_size);
static void get_absolute_path_to_dest(const char *dest, char *buf, unsigned int buf_size);
static bool is_directory(const char *path);
static symlink_result_type create_symlink(const char *src, const char *dest, bool is_directory);

#ifdef _WIN32

// TODO: Add support for Unicode characters in file and directory names.

#define WIN32_LEAN_AND_MEAN
#include <windows.h>

#define MAXIMUM_PATH_LENGTH MAX_PATH

static void get_absolute_path_to_src(const char *src, char *buf, unsigned int buf_size)
{
  const DWORD result = GetFullPathNameA(src, buf_size, buf, NULL);
  assert(result != 0);
}

static void get_absolute_path_to_dest(const char *dest, char *buf, unsigned int buf_size)
{
  const DWORD result = ExpandEnvironmentStringsA(dest, buf, buf_size);
  assert(result != 0);
}

static bool is_directory(const char *path)
{
  const DWORD result = GetFileAttributesA(path);
  assert(result != INVALID_FILE_ATTRIBUTES);
  return result & FILE_ATTRIBUTE_DIRECTORY;
}

static symlink_result_type create_symlink(const char *src, const char *dest, bool is_directory)
{
  DWORD symlink_flags = SYMBOLIC_LINK_FLAG_ALLOW_UNPRIVILEGED_CREATE;
  if (is_directory) {
    symlink_flags |= SYMBOLIC_LINK_FLAG_DIRECTORY;
  }
  if (CreateSymbolicLinkA(dest, src, symlink_flags) == 0) {
    const DWORD error = GetLastError();
    if (error == ERROR_PRIVILEGE_NOT_HELD) {
      return SYMLINK_RESULT_TYPE_INSUFFICIENT_PRIVILEGE;
    } else if (error == ERROR_ALREADY_EXISTS) {
      return SYMLINK_RESULT_TYPE_ALREADY_EXISTS;
    } else {
      return SYMLINK_RESULT_TYPE_UNKNOWN;
    }
  }
  return SYMLINK_RESULT_TYPE_OK;
}

#elif __linux__

#include <errno.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <wordexp.h>

#define MAXIMUM_PATH_LENGTH PATH_MAX

static void get_absolute_path_to_src(const char *src, char *buf, unsigned int buf_size)
{
  (void)buf_size;
  const char *result = realpath(src, buf);
  assert(result != NULL);
}

static void get_absolute_path_to_dest(const char *dest, char *buf, unsigned int buf_size)
{
  (void)buf_size;
  wordexp_t p = {0};
  const int result = wordexp(dest, &p, 0);
  assert(result == 0);
  memcpy(buf, p.we_wordv[0], strlen(p.we_wordv[0]));
  wordfree(&p);
}

static bool is_directory(const char *path)
{
  struct stat s = {0};
  const int result = stat(path, &s);
  assert(result == 0);
  return s.st_mode & S_IFDIR;
}

static symlink_result_type create_symlink(const char *src, const char *dest, bool is_directory)
{
  (void)is_directory;
  if (symlink(src, dest) == -1) {
    if (errno == EACCES) {
      return SYMLINK_RESULT_TYPE_INSUFFICIENT_PRIVILEGE;
    } else if (errno == EEXIST) {
      return SYMLINK_RESULT_TYPE_ALREADY_EXISTS;
    } else {
      return SYMLINK_RESULT_TYPE_UNKNOWN;
    }
  }
  return SYMLINK_RESULT_TYPE_OK;
}

#else
#error Unsupported platform
#endif

int main(void)
{
  for (size_t i = 0; i < array_size(config_files); ++i) {
    const config_file file = config_files[i];

    char src_abs_path[MAXIMUM_PATH_LENGTH] = {0};
    get_absolute_path_to_src(file.src, src_abs_path, array_size(src_abs_path));

#ifdef _WIN32
    const char *dest = file.dest.windows;
#elif __linux__
    const char *dest = file.dest.linux;
#endif
    if (dest == NULL) {
      continue;
    }
    char dest_abs_path[MAXIMUM_PATH_LENGTH] = {0};
    get_absolute_path_to_dest(dest, dest_abs_path, array_size(dest_abs_path));

    const bool directory = is_directory(src_abs_path);
    const symlink_result_type result = create_symlink(src_abs_path, dest_abs_path, directory);
    if (result == SYMLINK_RESULT_TYPE_INSUFFICIENT_PRIVILEGE) {
      fprintf(stderr, "error: cannot create a symbolic link because of insufficient privileges, either run this program as an administrator or enable Developer Mode in Windows 10\n");
      exit(1);
    } else if (result == SYMLINK_RESULT_TYPE_ALREADY_EXISTS) {
      if (directory) {
        fprintf(stderr, "warning: directory already exists at %s\n", dest_abs_path);
      } else {
        fprintf(stderr, "warning: file already exists at %s\n", dest_abs_path);
      }
    } else if (result == SYMLINK_RESULT_TYPE_UNKNOWN) {
      fprintf(stderr, "error: please debug me\n");
      exit(1);
    } else {
      printf("%s -> %s\n", src_abs_path, dest_abs_path);
    }
  }
}
