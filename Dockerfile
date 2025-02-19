FROM debian

ARG OPENVPN_CONFIG=kangwifi.first.ovpn
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y && apt install -y \
    ssh wget unzip vim curl python3 openvpn

# Copy OpenVPN configuration file into the container
COPY ${OPENVPN_CONFIG} /etc/openvpn/client.conf

RUN mkdir /run/sshd \
    && echo '/usr/sbin/sshd -D' >> /openssh.sh \
    && echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config \
    && echo 'root:craxid' | chpasswd \
    && chmod 755 /openssh.sh

# Start OpenVPN and SSH
CMD openvpn --config /etc/openvpn/client.conf & /openssh.sh

EXPOSE 80 443 3306 4040 5432 5700 5701 5010 6800 6900 8080 8888 9000
