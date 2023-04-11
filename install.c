#define _XOPEN_SOURCE 700

#include <assert.h>
#include <limits.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ARRAY_SIZE(array) (sizeof(array) / sizeof(array[0]))

enum SymlinkResultType {
  RESULT_OK,
  RESULT_INSUFFICIENT_PRIVILEGE,
  RESULT_ALREADY_EXISTS,
  RESULT_UNKNOWN
};

struct ConfigFile {
  const char *src;
  struct {
    const char *linux;
    const char *windows;
  } dst;
};

static struct ConfigFile config_files[] = {
    { .src = "emacs", .dst = { .linux = "$HOME/.emacs.d", .windows = "%APPDATA%\\.emacs.d" } },
    { .src = "gitconfig", .dst = { .linux = "$HOME/.gitconfig", .windows = "%USERPROFILE%\\.gitconfig" } },
    { .src = "hgrc", .dst = { .linux = "$HOME/.config/hg/hgrc", .windows = "%USERPROFILE%\\.hgrc" } },
    { .src = "nvim", .dst = { .linux = "$HOME/.config/nvim", .windows = "%LOCALAPPDATA%\\nvim" } },
    { .src = "openbox", .dst = { .linux = "$HOME/.config/openbox", .windows = NULL } },
    { .src = "vim", .dst = { .linux = "$HOME/.vim", .windows = "%USERPROFILE%\\vimfiles" } },
    { .src = "xinitrc", .dst = { .linux = "$HOME/.xinitrc", .windows = NULL } }
};

//================================================
// Required platform API
//================================================

static void get_absolute_path_to_src(const char *src, char *buf, unsigned int buf_size);
static void get_absolute_path_to_dst(const char *dst, char *buf, unsigned int buf_size);
static bool is_directory(const char *path);
static enum SymlinkResultType create_symlink(const char *src, const char *dst, bool is_directory);

#ifdef _WIN32

// @todo: Add support for Unicode characters in file and directory names.

#define WIN32_LEAN_AND_MEAN
#include <windows.h>

#define MAXIMUM_PATH_LENGTH MAX_PATH

static void get_absolute_path_to_src(const char *src, char *buf, unsigned int buf_size)
{
  const DWORD result = GetFullPathNameA(src, buf_size, buf, NULL);
  assert(result != 0);
}

static void get_absolute_path_to_dst(const char *dst, char *buf, unsigned int buf_size)
{
  const DWORD result = ExpandEnvironmentStringsA(dst, buf, buf_size);
  assert(result != 0);
}

static bool is_directory(const char *path)
{
  const DWORD result = GetFileAttributesA(path);
  assert(result != INVALID_FILE_ATTRIBUTES);
  return result & FILE_ATTRIBUTE_DIRECTORY;
}

static enum SymlinkResultType create_symlink(const char *src, const char *dst, bool is_directory)
{
  DWORD symlink_flags = SYMBOLIC_LINK_FLAG_ALLOW_UNPRIVILEGED_CREATE;
  if (is_directory) {
    symlink_flags |= SYMBOLIC_LINK_FLAG_DIRECTORY;
  }
  if (CreateSymbolicLinkA(dst, src, symlink_flags) == 0) {
    const DWORD error = GetLastError();
    if (error == ERROR_PRIVILEGE_NOT_HELD) {
      return RESULT_INSUFFICIENT_PRIVILEGE;
    } else if (error == ERROR_ALREADY_EXISTS) {
      return RESULT_ALREADY_EXISTS;
    } else {
      return RESULT_UNKNOWN;
    }
  }
  return RESULT_OK;
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

static void get_absolute_path_to_dst(const char *dst, char *buf, unsigned int buf_size)
{
  (void)buf_size;
  wordexp_t p = {0};
  const int result = wordexp(dst, &p, 0);
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

static enum SymlinkResultType create_symlink(const char *src, const char *dst, bool is_directory)
{
  (void)is_directory;
  if (symlink(src, dst) == -1) {
    if (errno == EACCES) {
      return RESULT_INSUFFICIENT_PRIVILEGE;
    } else if (errno == EEXIST) {
      return RESULT_ALREADY_EXISTS;
    } else {
      return RESULT_UNKNOWN;
    }
  }
  return RESULT_OK;
}

#else
#error Unsupported platform
#endif

int main(void)
{
  for (size_t i = 0; i < ARRAY_SIZE(config_files); ++i) {
    const struct ConfigFile file = config_files[i];

    char src_abs_path[MAXIMUM_PATH_LENGTH] = {0};
    get_absolute_path_to_src(file.src, src_abs_path, ARRAY_SIZE(src_abs_path));

#ifdef _WIN32
    const char *dst = file.dst.windows;
#elif __linux__
    const char *dst = file.dst.linux;
#endif
    if (dst == NULL) {
      continue;
    }
    char dst_abs_path[MAXIMUM_PATH_LENGTH] = {0};
    get_absolute_path_to_dst(dst, dst_abs_path, ARRAY_SIZE(dst_abs_path));

    const bool directory = is_directory(src_abs_path);
    const enum SymlinkResultType result = create_symlink(src_abs_path, dst_abs_path, directory);
    if (result == RESULT_INSUFFICIENT_PRIVILEGE) {
      fprintf(stderr, "error: cannot create a symbolic link because of insufficient privileges, either run this program as an administrator or enable Developer Mode in Windows 10\n");
      exit(1);
    } else if (result == RESULT_ALREADY_EXISTS) {
      if (directory) {
        fprintf(stderr, "warning: directory already exists at %s\n", dst_abs_path);
      } else {
        fprintf(stderr, "warning: file already exists at %s\n", dst_abs_path);
      }
    } else if (result == RESULT_UNKNOWN) {
      fprintf(stderr, "error: please debug me\n");
      exit(1);
    } else {
      printf("%s -> %s\n", src_abs_path, dst_abs_path);
    }
  }
}
