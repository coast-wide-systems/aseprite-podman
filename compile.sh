#!/usr/bin/env bash

# Fail on errors
set -e

if [[ "$1" =~ ^[0-9]+\.[0-9]+\.[0-9]+(\.[0-9]+)?$ ]]; then
	VERSION="$1"
else
	echo "Invalid version argument: '$1'" >&2
	exit 1
fi

echo "Downloading Aseprite $VERSION and compiling"

git clone --recursive https://github.com/aseprite/aseprite.git
cd aseprite
git checkout tags/v$VERSION || { echo "Failed to checkout 'tags/v$VERSION'" >&2; exit 1; }
./build.sh --auto --norun || { echo "Aseprite build script failed" >&2; exit 1; }
echo "Build complete, copying to /output"
cp -R ./build/bin /output/aseprite-${VERSION} || { echo "Failed to copy built binaries:" >&2; ls -l ./build; exit 1; }
echo "Done."
