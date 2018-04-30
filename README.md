# Package MK and deps for Unix and MSYS2/MINGW

This repository contains the scripts to compile and package MK and its
dependencies on Unix systems (especially iOS and Android) as well as with
MSYS2/MINGW (i.e. Windows using a Unix cross toolchain).

## Build and package

By following this procedure, you will find tarball packages in the root
directory and an updated SHA256SUM file that you should commit.

In addition to Unix essential commands, you'll need:

- GNU autoconf, automake, and libtool
- cmake
- curl
- make
- git

### iOS

From a macOS system with Xcode and command line developer tools installed:

```
./build-ios geoip-api-c
./build-ios libressl
./build-ios libevent
./build-ios measurement-kit
./package
```

### Android

We assume that you have the Native Development Kit (NDK) installed. The simplest
and recommended way to get the NDK is to install it along with Android Studio:

```
export NDK_ROOT=/path/to/ndk/root # ~/Library/Android/sdk/ndk-bundle on iOS
./build-android geoip-api-c
./build-android libressl
./build-android libevent
./build-android measurement-kit
./package
```

### MSYS/MINGW

We assume that you have installed [MSYS2](https://www.msys2.org/) on a
Windows system (we generally use Windows 10).

Inside of MSYS, you should install the following packages:

```
base-devel
mingw-w64-x86_64-toolchain
```

For now, we only support building for Windows `x86_64`.

A possible source of troubles is that MSYS2 provides you with three
shells: normal, 32 bit, and 64 bit development. If you're in the 64 bit
shell, the `gcc` compiler reported by which should be like:

```
$ which gcc
/mingw64/bin/gcc
```

where the important part is `/mingw64/bin` as opposed to `/usr/bin`.

From such shell, run:

```
./build-msys2-x86_64 geoip-api-c
./build-msys2-x86_64 libressl
./build-msys2-x86_64 libevent
./build-msys2-x86_64 measurement-kit
./package
```

## Publishing packages

Packages are published in a [measurement-kit/prebuilt](
https://github.com/measurement-kit/prebuilt) release. There should be
two releases: `stable` and `testing`. Depending on whether you are sure
that this is a stable build or not, use the former or the latter.

## Downloading packages

For the download to succeed, you must have committed and pushed the
changes to `SHA256SUM` created by the build step and published the
related tarballs as explained in the previous step.

Then run:

```
./install <package-name>
```

For example (valid at the moment of writing this file):

```
./install ios-libressl-2.6.4-2
```

This will download the related tarball, verify its SHA256 sum and unpack
the tarball inside `./MK_DIST`. You can use `find` inside of `MK_DIST` to
understand exactly the structure of the downloaded package.

If you integrate this repository as a subdirectory, and you run install
from the parent directory, `MK_DIST` will be inside the parent directory.

```
./foo/bar/install ios-libressl-2.6.4-2
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

For iOS, the toolchain is preinstalled. For Android, we also have a script
that uses the NDK's own script to make the desired toolchain.

CMake is technically not required, but often times is around and we're using
it as a portable way to compute the SHA256 sum of a package. Sorry.

We always use `make` to orchestrate the build. Set and export the `MAKEFLAGS`
environment variable properly if you wish, e.g., to have a parallel build.

Likewise, you can specify `CPPFLAGS`, `CFLAGS`, `CXXFLAGS` and `LDFLAGS`
flags in environment variables, to override the flags that we pass to
the compiler. The flags you specify will be appended after the flags we
specify, giving you the opportunity to override such flags.
