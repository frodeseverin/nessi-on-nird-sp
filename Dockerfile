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
    echo '*		hard	as		36700160' >>/etc/security/limits.conf && \

EXPOSE 22

# s6
RUN curl -L https://github.com/just-containers/s6-overlay/releases/download/v1.11.0.1/s6-overlay-amd64.tar.gz | tar -xzf - -C /

#remove nologin
RUN rm /var/run/nologin

ENTRYPOINT ["/init"]
