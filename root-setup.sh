#!/bin/sh

# supply a valid subscription manager pool id to access the following channels:
#
# rhel-7-server-rpms
# rhel-7-server-optional-rpms
# rhel-7-server-supplementary-rpms
# rhel-7-server-extras-rpms

# Insert your subscription manager pool id here, if known.  Otherwise,
# this script will try to dynamically determine the pool id.
SM_POOL_ID=

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

# if no SM_POOL_ID defined, attempt to find the Red Hat employee
# "kitchen sink" SKU (of course, this only works for RH employees)
if [ "x${SM_POOL_ID}" = "x" ]
then
  SM_POOL_ID=`subscription-manager list --available | \
      grep 'Subscription Name:\|Pool ID:\|System Type' | \
      grep -B2 'Virtual' | \
      grep -A1 'Employee SKU' | \
      grep 'Pool ID:' | awk '{print $3}'`

  # exit if none found
  if [ "x${SM_POOL_ID}" = "x" ]
  then
    echo "No subcription manager pool id found.  Exiting"
    exit 1
  fi
fi

# attach the desired pool id
subscription-manager attach --pool="$SM_POOL_ID"

# enable the required repos
subscription-manager repos --disable="*"
subscription-manager repos --enable=rhel-7-server-rpms \
                           --enable=rhel-7-server-optional-rpms \
                           --enable=rhel-7-server-supplementary-rpms \
                           --enable=rhel-7-server-extras-rpms

rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

# install EPEL to get the extra packages for guacamole, guacd,
# libguac-client-vnc, and openbox

yum -y localinstall resources/epel-release-latest-7.noarch.rpm

# speed up updates
yum -y install deltarpm

# update the install
yum -y update
yum clean all

# install the packages
yum -y install tigervnc-server gtk2 java-1.8.0-openjdk-devel \
    liberation-fonts-common liberation-sans-fonts
yum -y install libguac-client-vnc guacd openbox guacamole

# install wmctrl since not in EPEL or standard channels
WMCTRL_RPM=wmctrl-1.07-15.el7.nux.x86_64.rpm
curl ftp://ftp.pbone.net/mirror/li.nux.ro/download/nux/dextop/el7/x86_64/$WMCTRL_RPM \
    -o resources/$WMCTRL_RPM
yum -y localinstall resources/$WMCTRL_RPM

# make sure that tomcat and guacd do not auto-start at boot
systemctl disable tomcat
systemctl disable guacd

# update the user-mapping.xml file for guacamole
cp resources/user-mapping.xml /etc/guacamole

# set up JBDS
rm -fr /usr/share/jbdevstudio
java -jar resources/jboss-devstudio-8.1.0.GA-installer-standalone.jar \
    resources/InstallConfigRecord.xml
chcon -R system_u:object_r:usr_t:s0 /usr/share/jbdevstudio

# enable access through firewall
firewall-cmd --permanent --zone=public --add-port=8080/tcp
firewall-cmd --reload

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

