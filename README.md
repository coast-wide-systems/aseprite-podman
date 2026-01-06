# Containerized podman builder for Aseprite on Linux

A helper image to simplify compiling Aseprite for Linux. Note that, while the version can be passed as
a runtime env var, this builder has been updated to rely on the newer Aseprite `build.sh` script and
consequently won't work to compile legacy Aseprite releases.

Designed to be used with podman's rootless environment.

## Usage

### Default release version

The Makefile contains a default VERSION target, set to the most recent successfully built Aseprite
release. To build this version, simply call the `make` command from the top level of this repository.

### Specific Aseprite release

Note that due to constant changes in the Aseprite project this image may not work to compile any/all
Aseprite releases. To force the image to target a specific version, override the VERSION env var when
calling `make`, eg:

`make VERSION=v1.3.15.3`

### Image only

To only build the container image, using the `build-image` target for the Makefile, eg:

`make build-image`

Since the image will accept the Aseprite version as a CMD argument it's not necessary to build the
image against a specific Aseprite release, however if Aseprite introduces dependencies or changes to
the build steps then the image & build helper script will need to be updated accordingly.

### Installation

The default target will leave the compiled application in the local `./output` directory. If your system uses typical XDG style directory structures for your USER you may use the following to install the application for your user only and create a .desktop shortcut:

> [!WARNING]
> Do not use `sudo`, the application will be installed for the current user only using this Makefile target; if the application needs to be installed globally it should be done using the appropriate packager or other methodology for your particular distribution and is (currently) out of the scope of this Makefile.

`make install`

### Uninstallation

The `Makefile` inclues two options for uninstalling the application: `uninstall` and `purge`. The `uninstall` target will remove the application and its shortcut and can be invoked using:

`make uninstall`

If you want to remove both the application **and** its configurations then the purge target will do so:

`make purge`
