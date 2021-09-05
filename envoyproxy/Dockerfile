# v1.19.1
FROM envoyproxy/envoy@sha256:ac6a29af5bee160a1b4425d7c7a41a4d8a08a7f9dd7f225f21b5375f6439457a AS build

# debian:buster-20210905
FROM debian@sha256:cdb5ae50fedfda0bc2f9e4d303683ab6096c84db9e97b0bbfea0653549aeb3f8 AS debian

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update; \
    apt-get install -y \
    build-essential \
    cmake \
    wget \
    dumb-init

WORKDIR /build

ENV version="0.7.0"
ENV vhash="3a3a03060bf5e3fef52c9a2de02e6035cb557f389453d8f3b0c1d3d570636994"
ENV url="https://github.com/jaegertracing/jaeger-client-cpp/archive/v${version}.tar.gz"
ENV app_name=jaeger-client-cpp-${version}
ENV file=${app_name}.tar.gz

RUN wget -q -O $file $url; \
    export SHA_SUM=$(sha256sum  $file | awk '{print $1}'); \
    if [ $SHA_SUM != $vhash ]; then \
    echo "incorrect hash: $sha" \
    echo "expected: $vhash" \
    exit 1; \
    fi; \
    tar xf $file; \
    echo "ready to compile ${app_name}";

WORKDIR /build/${app_name}/build

RUN cmake -DCMAKE_BUILD_TYPE=Release ../

RUN make -j $(nproc)

RUN strip libjaegertracing.so.${version} -o /libjaegertracing.so



# gcr.io/distroless/base-debian10 2021-09-02
FROM gcr.io/distroless/base-debian10@sha256:d8244d4756b5dc43f2c198bf4e37e6f8a017f13fdd7f6f64ec7ac7228d3b191e

COPY --from=build /usr/local/bin/envoy /

COPY --from=debian /libjaegertracing.so /usr/local/lib/
COPY --from=debian /usr/bin/dumb-init /usr/bin/dumb-init

COPY envoy.yaml /etc/envoy/

EXPOSE 9000

USER 9000:9000

ENTRYPOINT ["dumb-init", "--", "/envoy", "-c", "/etc/envoy/envoy.yaml"]