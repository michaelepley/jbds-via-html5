#!/bin/sh

# supply a valid subscription manager pool id to access the following channels:
#
# rhel-6-server-rpms
# rhel-6-server-optional-rpms
# rhel-6-server-supplementary-rpms
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

for repoid in rhel-6-server-supplementary-rpms rhel-6-server-rpms rhel-6-server-optional-rpms
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
java -jar resources/jbdevstudio-product-universal-7.1.1.GA-v20140314-2145-B688.jar resources/InstallConfigRecord.xml
chcon -R system_u:object_r:usr_t:s0 /usr/share/jbdevstudio

# remove JBDS native libraries and checksum files  that are already
# installed in system lib directories to avoid conflicts

for ext in so chk
do
  for jbdslib in `find /usr/share/jbdevstudio -name "*.$ext"`
  do
    jbdslib_basename=`basename $jbdslib`
    for syslibdir in /lib64 /usr/lib64
    do
      for dummy in `find $syslibdir -name $jbdslib_basename`
      do
        [ -f $jbdslib ] && rm -f $jbdslib
      done
    done
  done
done

# enable access through firewall
lokkit -p 8080:tcp

