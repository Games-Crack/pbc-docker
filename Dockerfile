FROM debian:12

RUN apt-get update \
    && apt-get -y install \
      wget \
      vim \
      nano \
    ; \
    wget https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg \
    && echo "deb http://download.proxmox.com/debian/pbs-client bookworm main" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get -y install proxmox-backup-client
