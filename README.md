# Package MK and deps for Mingw-w64

This repository contains the scripts to compile and package MK and its
dependencies for Mingw-w64 systems. Previous versions of this repository
(once named script-build-unix) used to support building for all Unix
and mobile systems, but now here we only support Mingw-w64.

Note: if you want to build for Windows using Microsoft tooling, use
[measurement-kit/script-build-windows](
https://github.com/measurement-kit/script-build-windows) instead.

## Build and package

By following this procedure, you will find tarball packages in the root
directory and an updated SHA256SUM file that you should commit.

In addition to Unix essential commands, you'll need:

- GNU autoconf, automake, and libtool
- curl
- make
- patch

Each specific build has additional requirements.

### Mingw-w64

We assume that you have installed a mingw-w64 distribution compiled with
support for POSIX threads and C++11 threads. The one provided by by
[Homebrew](brew.sh) is the one we generally use.

With mingw-w64 installed, just run:

```
./build-mingw `./all-deps.sh`
./build-mingw measurement-kit
./package
```

## Publishing packages

Packages are publishes as part of [script-build-mingw releases](
https://github.com/measurement-kit/script-build-mingw/releases).

## Downloading packages

For the download to succeed, you must have committed and pushed the
changes to `SHA256SUM` created by the build step and published the
related tarballs in the current release of script-build-mingw.

Then run:

```
./install <package-name>
```

Where `<package-name>` is the name of the package (or packages) that
you want to install. For example, a compact way to install MK and all
its dependencies for Android is the following:

```
./install `./all-deps.sh mingw-` mingw-measurement-kit
```

This will download the related tarball, verify its SHA256 sum and unpack
the tarball inside `./MK_DIST`. You can use `find` inside of `MK_DIST` to
understand exactly the structure of the downloaded package.

If you integrate this repository as a subdirectory, and you run install
from the parent directory, `MK_DIST` will be inside the parent directory.

```
./foo/bar/install mingw-libressl-2.6.4-2
# You will find the package in ./MK_DIST rather than ./foo/bar/MK_DIST
```

## Low-level details

For each package, there is a build script named after the package. Packages
may depend on each other. You will clearly see that when reading the package
specific build script. Make sure you build them in order.

For each possible cross-compilation, there is a script named `cross-<os>`
that sets the proper environment variables for cross compiling.

There may be small patches that we apply to packages. (Preferrably none but
some small patches are better than having to do more difficult stuff.)

We always use `make` to orchestrate the build. Set and export the `MAKEFLAGS`
environment variable properly if you wish, e.g., to have a parallel build.

Likewise, you can specify `CPPFLAGS`, `CFLAGS`, `CXXFLAGS` and `LDFLAGS`
flags in environment variables, to override the flags that we pass to
the compiler. The flags you specify will be appended after the flags we
specify, giving you the opportunity to override such flags.
