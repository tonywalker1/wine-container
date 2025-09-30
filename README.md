# wine-container

OCI Container for Wine (or Codeweaver's Crossover) using Buildah and Podman.

Many old but useful Windows apps are probably poorly maintained or patched.
Others that, while newer, are potentially buggy or have security issues. One
solution is to run those apps in a container. That is the point of this project.

## 🚨 Breaking Changes in v2.0

> **Fedora-based images are no longer supported. If you need that, please use
the [v1 branch](https://github.com/tonywalker1/wine-container/tree/v1).**

This version introduces significant changes to simplify maintenance and reduce complexity:

### Key Changes

- **Debian-only base images** (Fedora support removed)
- **Wine source selection** instead of base OS selection (e.g., Debian vs WineHQ)
- **Smaller container images** (~1.2GB vs ~4.2GB for Fedora)
- **Simplified command-line interface**

### Rationale

- **Image size**: Debian images are ~70% smaller than Fedora equivalents
- **Consistency**: Single base OS reduces complexity and maintenance burden
- **Wine versions**: WineHQ repository provides the latest Wine versions on a stable Debian base
- **Performance**: Smaller images mean faster downloads and less storage usage

## Goals

* Use Podman (rootless) to limit breakout attacks.
* All data is written to a volume and, except the sockets for graphics and
  audio, the containers have no access to the underlying filesystem.
* Allow Windows apps to be orchestrated as a part of a collection of containers.
* Support Codeweaver's Crossover in addition to Wine.

## Wine Source Options

Choose your Wine installation source based on your needs:

| Source      | Description                        | Use Case                                         |
|-------------|------------------------------------|--------------------------------------------------|
| `debian`    | Debian's packaged Wine (default)   | Stable, well-tested, older versions              |
| `winehq`    | Latest Wine from WineHQ repository | Newest features, latest compatibility            |
| `crossover` | CodeWeavers Crossover (commercial) | Professional support, specific app compatibility |

## Documentation and Usage

Building and running are facilitated by two scripts: *build_wine_container*
and *run_wine_container*. Each script offers help in the usual way, for example:

```shell
build_wine_container --help
```

### Basic Usage

```shell
# Default: Debian Wine on latest Debian
build_wine_container -d CrappyHomeVolume -f -n CrappyWindowsApp

# Latest Wine version
build_wine_container --wine-source winehq -d CrappyHomeVolume -f -n CrappyWindowsApp

# Specific Debian version with WineHQ
build_wine_container --wine-source winehq --debian-version bookworm -d CrappyHomeVolume -n CrappyWindowsApp

# Crossover (requires DEB package)
build_wine_container --wine-source crossover --crossover-pkg /path/to/crossover.deb -d CrappyHomeVolume -n CrappyWindowsApp
```

Then run your application:

```shell
run_wine_container -d CrappyHomeVolume -n CrappyWindowsApp -r "/path/to/crappy_app.exe"
```

The first line above will create a volume named *CrappyHomeVolume* and an OCI
container named *CrappyWindowsApp*. The second line will run the app in the new
container.

### Debian Version Selection

You can specify which Debian version to use as the base:

```shell
# Use latest Debian (default)
build_wine_container --debian-version latest

# Use specific stable release
build_wine_container --debian-version bookworm    # Debian 12
build_wine_container --debian-version bullseye    # Debian 11  
build_wine_container --debian-version buster      # Debian 10
```

## Migration Guide

### From v1.x Fedora Usage

```shell
# OLD (v1.x): Fedora with newer Wine
build_wine_container --base fedora

# NEW (v2.x): Debian with WineHQ (equivalent functionality, smaller image)
build_wine_container --wine-source winehq --debian-version latest
```

### From v1.x Debian Usage

```shell
# OLD (v1.x): Debian base
build_wine_container --base debian

# NEW (v2.x): Explicit Debian Wine (same functionality)
build_wine_container --wine-source debian --debian-version latest
```

### From v1.x Crossover Usage

```shell
# OLD (v1.x): Crossover
build_wine_container --crossover /path/to/crossover.deb

# NEW (v2.x): Crossover as wine source
build_wine_container --wine-source crossover --crossover-pkg /path/to/crossover.deb
```

## Deprecated Options

The following options are deprecated and have been removed:

| Deprecated Option     | Replacement                                    | Notes                                      |
|-----------------------|------------------------------------------------|--------------------------------------------|
| `--base fedora`       | `--wine-source winehq`                         | Provides same Wine versions, smaller image |
| `--base debian`       | `--wine-source debian --debian-version latest` | More explicit                              |
| `--crossover`         | `--wine-source crossover --crossover-pkg`      | Unified interface                          |
| `--base <custom-uri>` | Not supported                                  | Use `--debian-version` for version control |

**Note**: Only Crossover DEB packages are supported (RPM support removed with Fedora).

## Volume Storage

The volume is stored on the container host
in ```~/.local/share/containers/storage/volumes/$HOME_VOLUME/_data```. The build
script automatically makes this directory writable from the user that launched
 Podman, so you can copy/rename/delete files from the host.

## Platforms

This project should work correctly on any recent Linux distribution. I currently
use Fedora (Silverblue and Kinoite), so this is well-tested.

## Dependencies

* [Buildah](https://buildah.io/)
* [Podman](https://podman.io/)

## Contributing

I would love suggestions, fixes, documentation, examples, and other
contributions. See [CONTRIBUTING](CONTRIBUTING.md)
and [CODE_OF_CONDUCT](CODE_OF_CONDUCT.md)
for details.

See [CONTRIBUTORS](CONTRIBUTORS.md) for a list of contributors.

## Legacy Version

**Need Fedora support?** Use
the [v1 branch](https://github.com/tonywalker1/wine-container/tree/v1) which maintains the original functionality:

```shell
git clone -b v1 https://github.com/tonywalker1/wine-container.git
```

The v1 branch will receive critical bug fixes but no new features.
