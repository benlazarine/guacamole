FROM ubuntu:18.04

ENV    GUACAMOLE_HOME="/etc/guacamole"
EXPOSE 8080

WORKDIR /etc/guacamole

# install locale and set
RUN apt-get update &&          \
    apt-get install -y         \
    locales &&                 \
    apt-get clean &&           \
    rm -rf /var/lib/apt/lists/*
# set the locale to UTF-8
# see https://stackoverflow.com/questions/28405902/how-to-set-the-locale-inside-a-ubuntu-docker-container
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# install libraries/dependencies
RUN apt-get update &&          \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    software-properties-common \
    libjpeg-turbo8             \
    libjpeg-turbo8-dev         \
    libcairo2-dev              \
    libossp-uuid-dev           \
    libpng-dev                 \
    libpango1.0-dev            \
    libssh2-1-dev              \
    libssl-dev                 \
    libtasn1-bin               \
    libvorbis-dev              \
    libwebp-dev                \
    libpulse-dev               \
    gcc                        \
    gcc-6                      \
    make                       \
    sudo                       \
    tomcat8                    \
    wget                       \
    libfreerdp-dev             \
    xauth &&                   \ 

    apt-get clean && rm -rf /var/lib/apt/lists/*

# download necessary Guacamole files
RUN rm -rf /var/lib/tomcat8/webapps/ROOT && \
    wget "http://apache.org/dyn/closer.cgi?action=download&filename=guacamole/1.0.0/binary/guacamole-1.0.0.war" -O /var/lib/tomcat8/webapps/ROOT.war && \
    wget "http://apache.org/dyn/closer.cgi?action=download&filename=guacamole/1.0.0/source/guacamole-server-1.0.0.tar.gz" -O /etc/guacamole/guacamole-server-1.0.0.tar.gz && \
    tar xvf /etc/guacamole/guacamole-server-1.0.0.tar.gz && \
    cd /etc/guacamole/guacamole-server-1.0.0 && \
    ./configure --with-init-dir=/etc/init.d &&  \
    make CC=gcc-6 &&                            \
    make install &&                             \
    ldconfig &&                                 \
    rm -r /etc/guacamole/guacamole-server-1.0.0*

# create Guacamole configurations
RUN echo "user-mapping: /etc/guacamole/user-mapping.xml" > /etc/guacamole/guacamole.properties && \
    touch /etc/guacamole/user-mapping.xml

# create user account with password-less sudo abilities
RUN useradd -s /bin/bash -g 100 -G sudo -m user && \
    /usr/bin/printf '%s\n%s\n' 'password' 'password'| passwd user && \
    echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# enable pulse audio
RUN echo "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" >> /etc/pulse/default.pa

# Add help message
RUN touch /etc/help-msg

WORKDIR /home/user

COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

USER 1000:100

ENTRYPOINT sudo -E /startup.sh
