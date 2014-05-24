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
LIB_BASE_DIR=/usr/share/jbdevstudio/studio/plugins LD_LIBRARY_PATH=${LIB_BASE_DIR}/org.eclipse.equinox.launcher.gtk.linux.x86_64_1.1.200.v20140116-2212:${LIB_BASE_DIR}/org.mozilla.xulrunner.gtk.linux.x86_64_1.9.2.19pre/xulrunner:${LIB_BASE_DIR}/org.mozilla.xulrunner.gtk.linux.x86_64_1.9.2.19pre/xulrunner/components:${LD_LIBRARY_PATH} DISPLAY=:1 /usr/share/jbdevstudio/jbdevstudio -nosplash -data $HOME/workspace &
echo "JBDS (Java) launched."
echo

# wait for JBDS to fully start up and get past splash screen
sleep 30

DISPLAY=:1 wmctrl -r "JBoss Developer Studio" -b add,fullscreen
echo "JBDS now in fullscreen"

