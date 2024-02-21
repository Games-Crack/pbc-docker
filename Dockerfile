FROM debian:12


# Install Proxmox Backup Client
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

# Install ssh client
RUN apt-get -y install openssh-client

# Cron Dependencies
RUN apt-get -y install python3-croniter 

COPY cron.py /cron.py

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
