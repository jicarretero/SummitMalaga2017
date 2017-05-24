FROM ubuntu:16.04
MAINTAINER Jose Ignacio Carretero guarde <joseignacio.carretero@fiware.org>

VOLUME /data


ENV DEBIAN_FRONTEND=noninteractive

COPY remove_cloudinit.sh /

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
          libguestfs-tools \
          qemu-utils \
          linux-image-generic && \
    apt-get -y autoremove && \
    chmod +x /remove_cloudinit.sh

ENV HOME=/root

ENTRYPOINT ["/remove_cloudinit.sh"]

WORKDIR /data
