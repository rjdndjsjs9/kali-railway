FROM kalilinux/kali-rolling

# Update dan instal paket yang diperlukan
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get -y install wget sudo systemd docker.io

# Install dependensi untuk systemd
RUN apt-get -y install systemd systemd-sysv

# Install ttyd (web terminal)
RUN wget -qO /bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 && \
    chmod +x /bin/ttyd

# Set environment variables untuk kredensial
ENV USERNAME=666
ENV PASSWORD=666
ENV PORT=7681
EXPOSE $PORT

# Membuat user dengan hak akses sudo
RUN useradd -m -s /bin/bash $USERNAME && \
    echo "$USERNAME:$PASSWORD" | chpasswd && \
    usermod -aG sudo $USERNAME

# Memberikan hak sudo tanpa password
RUN echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USERNAME

# Setup systemd untuk berjalan di dalam container
RUN mkdir -p /etc/systemd/system && \
    systemctl mask dev-mqueue.mount dev-hugepages.mount sys-kernel-config.mount sys-fs-fuse-connections.mount

# Mengatur systemd agar dapat berjalan sebagai PID 1
CMD ["/bin/bash", "-c", "systemd & /bin/ttyd -p $PORT -c $USERNAME:$PASSWORD /bin/bash"]
