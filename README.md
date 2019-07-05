# Distroless

This repository contains docker images based on [distroless](https://github.com/GoogleContainerTools/distroless/).
You will need [bazel](https://bazel.build/) to build the images or find them at [Docker Hub](https://hub.docker.com/).

See [LICENSE](https://github.com/linuxuser586/apis/blob/master/LICENSE)

## Run

```sh
docker run -it --rm linuxuser586/base
```

Output: OpenSSL version

```sh
docker run -it --rm linuxuser586/java
```

Output: Java version

## Build

```sh
bazel run //base:linuxuser586-base
docker tag bazel/base:linuxuser586-base linuxuser586/base
```

```sh
bazel run //java:base
docker tag bazel/java:base linuxuser586/java
```

```sh
bazel run //cassandra:base
docker tag bazel/cassandra:base linuxuser586/cassandra:3.11.4-base
```
