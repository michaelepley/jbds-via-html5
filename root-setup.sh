#!/bin/sh

# supply a valid subscription manager pool id to access the following channels:
#
# rhel-6-server-rpms
# rhel-6-server-optional-rpms
# rhel-6-server-supplementary-rpms
# jb-ews-1-for-rhel-6-server-rpms (provides tomcat6 package)
#
SM_POOL_ID="INSERT VALID POOL ID HERE"

function usage {
  echo
  echo "usage:  sudo $0"
  echo
  exit 1
}

# must be root to run this script
if [ "`whoami`" != "root" ]
then
  usage
fi

# register with Red Hat subscription manager
echo "Please provide your RHN credentials"
subscription-manager register
subscription-manager attach --pool="$SM_POOL_ID"

# enable the required repos
subscription-manager repos --disable="*"

for repoid in rhel-6-server-supplementary-rpms rhel-6-server-rpms rhel-6-server-optional-rpms jb-ews-1-for-rhel-6-server-rpms
do
  subscription-manager repos --enable=$repoid
done

yum clean all

# apply all updates
yum -y update

# install EPEL to get the extra packages for guacamole, fluxbox,
# and wmctrl

yum -y localinstall resources/epel-release-6-8.noarch.rpm

yum -y install \
  java-1.7.0-openjdk-devel \
  java-1.6.0-openjdk-devel \
  java-1.6.0-openjdk \
  tomcat6 \
  tigervnc-server \
  libguac \
  libguac-client-vnc \
  guacd \
  fluxbox \
  wmctrl

# make sure that tomcat6 and guacd do not auto-start at boot
chkconfig tomcat6 off
chkconfig guacd off

# set up JBDS
rm -fr /usr/share/jbdevstudio
java -jar resources/jbdevstudio-product-universal-7.1.0.Beta1-v20131102-1529-B493.jar resources/InstallConfigRecord.xml
chcon -R system_u:object_r:usr_t:s0 /usr/share/jbdevstudio

# enable access through firewall
lokkit -p 8080:tcp

