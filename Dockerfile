from rockylinux/rockylinux:8

# Install epel
RUN dnf -y install epel-release && dnf -y update

# Enable powertools
RUN dnf -y install dnf-plugins-core && dnf config-manager --set-enabled powertools

# All dnfs packages
RUN dnf -y install openssh-server \
                   sssd \
                   crontabs.noarch \
                   screen \
                   tmux \
                   bzip2 \
                   wget \
                   cmake \
                   python3-pip.noarch \
                   python3-virtualenv.noarch \
                   emacs \
                   nano \
                   vim \
                   git \
                   dstat \
                   elfutils \
                   lsof \
                   redhat-lsb-desktop \
                   rrdtool \
                   sysstat \
                   time \
                   uuid \
                   urw-fonts \
                   rsync \
                   glibc-all-langpacks \
                   langpacks-en \
                   langpacks-nb \
                   mc \
                   pciutils-libs \
                   rdma-core-devel.x86_64

# Fix timezone
RUN echo "Europe/Oslo" > /etc/timezone

# Allow remote display and vscode connection
RUN echo "X11UseLocalhost no" >> /etc/ssh/sshd_config
RUN echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config

# Limit resources for users
RUN echo '*		hard	nproc		1000' >>/etc/security/limits.conf && \
    echo '*		hard	priority	5' >>/etc/security/limits.conf && \
    echo '*		hard	rss		36700160' >>/etc/security/limits.conf && \
    echo '*		hard	as		36700160' >>/etc/security/limits.conf

EXPOSE 22

# s6
RUN curl -L https://github.com/just-containers/s6-overlay/releases/download/v1.11.0.1/s6-overlay-amd64.tar.gz | tar -xzf - -C /

# Install mlocate in order to find files on fielsystem
RUN dnf -y install mlocate

#@TODO: Install nessi
# Installation commands for RHEL-based distros like CentOS, Rocky Linux, Almalinux, Fedora, ...

# install CernVM-FS
RUN dnf install -y https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm
RUN dnf install -y cvmfs

# install EESSI configuration for CernVM-FS
RUN dnf install -y https://github.com/EESSI/filesystem-layer/releases/download/latest/cvmfs-config-eessi-latest.noarch.rpm

# create client configuration file for CernVM-FS (no squid proxy, 10GB local CernVM-FS client cache)
RUN echo 'CVMFS_CLIENT_PROFILE="single"' > /etc/cvmfs/default.local
RUN echo 'CVMFS_QUOTA_LIMIT=10000' >> /etc/cvmfs/default.local

# make sure that EESSI CernVM-FS repository is accessible
#@TODO: edit script cvmfs_config to use s6 rather than systemctl 
#cvmfs_config setup

#@TODO: Modify s6 to start needed services
# sshd ?
# nessi

#remove nologin
RUN rm /var/run/nologin

# Run updatedb to initialize mlocate index
RUN updatedb

ENTRYPOINT ["/init"]
