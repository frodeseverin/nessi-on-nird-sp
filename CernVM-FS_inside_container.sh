# Installation commands for RHEL-based distros like CentOS, Rocky Linux, Almalinux, Fedora, ...

# install CernVM-FS
RUN dnf install -y https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm
RUN dnf install -y cvmfs

# install EESSI configuration for CernVM-FS
RUN DNF install -y https://github.com/EESSI/filesystem-layer/releases/download/latest/cvmfs-config-eessi-latest.noarch.rpm

# create client configuration file for CernVM-FS (no squid proxy, 10GB local CernVM-FS client cache)
RUN echo 'CVMFS_CLIENT_PROFILE="single"' > /etc/cvmfs/default.local
RUN echo 'CVMFS_QUOTA_LIMIT=10000' >> /etc/cvmfs/default.local

# make sure that EESSI CernVM-FS repository is accessible
#@TODO: edit script cvmfs_config to use s6 rather than systemctl 
#cvmfs_config setup
