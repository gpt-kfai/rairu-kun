FROM debian

ARG ZEROTIER_NETWORK_ID
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y && apt install -y \
    ssh wget unzip vim curl python3

# Install ZeroTier
RUN curl -s https://install.zerotier.com | bash

# Setup SSH
RUN mkdir /run/sshd \
    && echo "zerotier-cli join ${ZEROTIER_NETWORK_ID}" >> /openssh.sh \
    && echo "sleep 5" >> /openssh.sh \
    && echo "/usr/sbin/sshd -D" >> /openssh.sh \
    && echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config \
    && echo root:craxid | chpasswd \
    && chmod 755 /openssh.sh

EXPOSE 80 443 3306 4040 5432 5700 5701 5010 6800 6900 8080 8888 9000

CMD /openssh.sh
