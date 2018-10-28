#!/bin/sh
set -ex
./install `./all-deps.sh ios-` ios-measurement-kit
./framework-ios `./all-deps.sh` measurement-kit
(
  set -ex
  cd ./MK_DIST/ios-frameworks
  tar -cf ../../ios-all-0.9.0-alpha.11-9.tar *.framework
)
gzip -9 ios-all-0.9.0-alpha.11-9.tar
