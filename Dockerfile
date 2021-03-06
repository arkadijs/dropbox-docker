# Dropbox daemon
FROM ubuntu:trusty
MAINTAINER Carlos Hernandez <carlos@techbyte.ca>

# Let the container know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# Set user nobody to uid and gid of unRAID
RUN groupadd -g 1000 arkadi
RUN usermod -u 1000 nobody
RUN usermod -g 1000 nobody
RUN usermod -d /home nobody

# Set locale
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
RUN locale-gen en_US en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8
RUN dpkg-reconfigure locales

# Update Ubuntu
RUN apt-get -q update
RUN apt-get -qy install libglib2.0
RUN apt-mark hold initscripts udev plymouth mountall
RUN apt-get -qy --force-yes dist-upgrade && apt-get autoremove && apt-get autoclean

#ADD https://www.dropbox.com/download?plat=lnx.x86_64 /dropbox.tgz
ADD https://clientupdates.dropboxstatic.com/dbx-releng/client/dropbox-lnx.x86_64-30.4.22.tar.gz /dropbox.tgz
RUN tar xfvz /dropbox.tgz && rm /dropbox.tgz && chown -R nobody:users /.dropbox-dist/ && chown nobody:users /home

ADD start.sh /start.sh

VOLUME /config
VOLUME /home/Dropbox

USER nobody
CMD ["/start.sh"]
