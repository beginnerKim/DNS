# ref site : https://github.com/isc-projects/bind9-docker/blob/v9.16/Dockerfile
FROM ubuntu:focal

MAINTAINER kimbeginner <kimbeginner@ytstar.co.kr>

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8

ARG DEB_VERSION=1:9.16.28-1+ubuntu20.04.1+isc+3

# overridavle env
ENV USER_CONFIG_DIR /etc/bind/extra.config
ENV USE_BIND_CONFIG_SYMLINK=no

# local env
ENV BIND_DIR /etc/bind
ENV BIND_GROUP bind
ENV BIND_USER bind


# Install add-apt-repository command
RUN apt-get -qqqy update
RUN apt-get -qqqy dist-upgrade
RUN apt-get -qqqy install --no-install-recommends apt-utils software-properties-common dctrl-tools

# Add the BIND 9 APT Repository
RUN add-apt-repository -y ppa:isc/bind-esv

# Install BIND 9
RUN apt-get -qqqy update
RUN apt-get -qqqy dist-upgrade
RUN apt-get -qqqy install bind9=$DEB_VERSION bind9utils=$DEB_VERSION
#RUN apt-get -qqqy install bind9 bind9utils

#install for debug
RUN apt-get -qqqy install dnsutils net-tools iputils-ping vim

# Now remove the pkexec that got pulled as dependency to software-properties-common
RUN apt-get --purge -y autoremove policykit-1

#RUN mkdir -p /etc/bind && chown root:bind /etc/bind/ && chmod 755 /etc/bind
#RUN mkdir -p /var/cache/bind && chown bind:bind /var/cache/bind && chmod 755 /var/cache/bind
#RUN mkdir -p /var/lib/bind && chown bind:bind /var/lib/bind && chmod 755 /var/lib/bind
#RUN mkdir -p /var/log/bind && chown bind:bind /var/log/bind && chmod 755 /var/log/bind
#RUN mkdir -p /run/named && chown bind:bind /run/named && chmod 755 /run/named

#VOLUME ["/etc/bind", "/var/cache/bind", "/var/lib/bind", "/var/log"]


ADD entrypoint.sh /sbin/entrypoint.sh


ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["/usr/sbin/named", "-g", "-c", "/etc/bind/named.conf", "-u", "bind"]

EXPOSE 53/udp 53/tcp
EXPOSE 953/tcp

