FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    bash \
    curl \
    file \
    binutils \
    openssh-server \
    sqlite3 \
    unzip \
    zip \
    dnsutils \
    python3 \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd
RUN useradd -m -s /bin/bash player && \
    useradd -m -s /bin/bash mittens && \
    echo 'player:playercatctf' | chpasswd

COPY init/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /home/player

EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]
