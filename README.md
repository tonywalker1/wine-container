# wine-container

OCI Container for Wine (or Codeweaver's Crossover) using Buildah and Podman.

Many old but useful Windows apps are probably poorly maintained or patched.
Others that, while newer, are potentially buggy or have security issues. One
solution is to run those apps in a container. That is the point of this project.

# Goals

* Use Podman (rootless) to limit breakout attacks.
* All data is written to a volume and, except the sockets for X11 and
  PulseAudio, the containers has no access to the underlying filesystem.
* Allow Windows apps to be orchestrated as a part of a collection of containers.
* Support Codeweaver's Crossover in addition to Wine.

# Documentation and Usage

Building and running are facilitated by two scripts: *build_wine_container*
and *run_wine_container*. Each script offers help in the usual way, for example:

```shell
build_wine_container --help
```

Assuming you want to use this project to run CrappyWindowsApp, you could do the
following:

```shell
build_wine_container -d CrappyHomeVolume -f -n CrappyWindowsApp
run_wine_container -d CrappyHomeVolume -n CrappyWindowsApp -r <path_to_crappy_app>/crappyapp.exe
```

The first line above will create a volume named *CrappyHomeVolume* and an OCI
container named *CrappyWindowsApp*. The second line will run the app in the new
container.

The volume is stored on the container host
in ```~/.local/share/containers/storage/volumes/$HOME_VOLUME/_data```. The build
script automatically makes this directory writable from the user that launched
Podman so you can copy/rename/delete files from the host.

# Platforms

This project should work correctly on any recent Linux distribution. I currently
use Fedora (F35 Silverblue and Kinoite)
, so this platform is well tested by me.

# Dependencies

* [Buildah](https://buildah.io/)
* [Podman](https://podman.io/)

# Contributing

I would love suggestions, fixes, documentation, examples, and other
contributions. See [CONTRIBUTING](CONTRIBUTING.md)
and [CODE_OF_CONDUCT](CODE_OF_CONDUCT.md)
for details.

See [CONTRIBUTORS](CONTRIBUTORS.md) for a list of contributors.
