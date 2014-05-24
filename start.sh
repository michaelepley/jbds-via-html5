#!/bin/bash

# set env variables for this tomcat instance
. $HOME/tomcat6/conf/tomcat6.conf
export CATALINA_BASE CATALINA_HOME JASPER_HOME CATALINA_TMPDIR TOMCAT_USER
export SECURITY_MANAGER SHUTDOWN_WAIT SHUTDOWN_VERBOSE CATALINA_PID

GUACD_PID=$HOME/.guacamole/guacd.pid

# TODO: figure out how to resize VNC display to match user's browser pane

vncserver :1 -name "JBDS via HTML5" -geometry 1920x908 -depth 24
echo "Xvnc and fluxbox launched."

# start guacd and tomcat6
/usr/sbin/guacd -b localhost -l 4822 -p $GUACD_PID
/usr/sbin/tomcat6 start

# start JBDS with an overridden LD_LIBRARY_PATH to avoid SIGSEGV issues
# with native library mismatches
JBDS_INSTALL_DIR=/usr/share/jbdevstudio

for libdir in `find ${JBDS_INSTALL_DIR} -type f -name '*.so' -exec dirname {} \; | sort -u`
do
  LD_LIBRARY_PATH=${libdir}:${LD_LIBRARY_PATH}
done

LD_LIBRARY_PATH=${LD_LIBRARY_PATH} DISPLAY=:1 /usr/share/jbdevstudio/jbdevstudio -nosplash -data $HOME/workspace &
echo "JBDS (Java) launched."
echo

# wait for JBDS to fully start up and get past splash screen
echo -n "Wait up to 30 seconds for JBDS to fully start "
for j in {1..6}
do
  if [ ! "`DISPLAY=:1 wmctrl -l | grep 'JBoss Developer Studio'`" ]
  then
    echo -n "."
    sleep 5
  fi
done
echo

DISPLAY=:1 wmctrl -r "JBoss Developer Studio" -b add,fullscreen
echo "JBDS now in fullscreen"

