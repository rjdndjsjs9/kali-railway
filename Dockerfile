FROM kalilinux/kali-rolling

# Update and install necessary packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get -y install wget sudo systemd docker.io

# Download and install ttyd
RUN wget -qO /bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 && \
    chmod +x /bin/ttyd

# Set environment variables for credentials
ENV USERNAME=666
ENV PASSWORD=666
ENV PORT=7681
EXPOSE $PORT

# Create user with sudo privileges
RUN useradd -m -s /bin/bash $USERNAME && \
    echo "$USERNAME:$PASSWORD" | chpasswd && \
    usermod -aG sudo $USERNAME

# Allow the user to bypass restrictions
RUN echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USERNAME

# Set up systemd to run inside the container (privileged mode required)
CMD ["/bin/bash", "-c", "systemd & /bin/ttyd -p $PORT -c $USERNAME:$PASSWORD /bin/bash"]
