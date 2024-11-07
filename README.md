# Build a container to build CanDIGv2

- CanDIGv2 repository: [https://github.com/CanDIG/CanDIGv2]
- Issue that spurred this repos creation: [https://github.com/CanDIG/CanDIGv2/issues/617]

## Requirements

- A container runtime with a socket connection
  - Tested on podman and docker
  - SELinux based distributions must run the build as root in order to share the
    socket inside the container after the build

## Instructions

*Replace podman with docker if using docker*

1. Build the container: `podman build -t candig-build:latest -f Dockerfile .`
2. Run the built container on the machine you want to deploy candig to: `podman run -it -v /var/run/podman/podman.sock:/var/run/docker.sock:ro,z -v /path/to/environment:/candig/.env:ro -v /candig/tmp:/candig/tmp candig-build:latest`
3. That's it!

## Notes about the Dockerfile

- The dependency for YQ has been turned into an argument for both the binary name `YQBINARY=yq_linux_amd64` and the version `YQVERSION=v4.44.1`. Adjust those as nessecary when running the container build.
  It defaults to the amd64 binary of version 4.44.1 (latest at the time of writing)
- The CanDIGv2 repository can be changed by setting the argument `CANDIG_REPO`. defaults to the official repository
- The branch can be changed by setting the arguement `BRANCH`. defaults to stable
- Due to how Docker handles volumes, you must also create the `/candig/tmp/` folder on your machine
- You will need to fill out the LOCAL_IP_ADDR in your `.env` file, as it cannot be automatically found from within Docker

