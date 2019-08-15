# 1.11.1
FROM envoyproxy/envoy@sha256:9ef9c4fd6189fdb903929dc5aa0492a51d6783777de65e567382ac7d9a28106b AS build

# debian stretch 2019-07-08
FROM debian@sha256:397b2157a9ea8d7f16c613aded70284292106e8b813fb1ed5de8a8785310a26a AS debian

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update; \
    apt-get install -y \
    build-essential \
    cmake \
    wget

WORKDIR /build

ENV version="0.4.2"
ENV vhash="21257af93a64fee42c04ca6262d292b2e4e0b7b0660c511db357b32fd42ef5d3"
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

# 2019-07-05
FROM linuxuser586/base@sha256:d0a7ebd7d97b29d34311aa0c3f4f1d7367ee7c6fc55f128208d77bce8d1376f7

COPY --from=build /usr/local/bin/envoy /

COPY --from=debian /libjaegertracing.so /usr/local/lib/

COPY envoy.yaml /etc/envoy/

EXPOSE 9000

USER 9000:9000

ENTRYPOINT ["dumb-init", "--", "/envoy", "-c", "/etc/envoy/envoy.yaml"]