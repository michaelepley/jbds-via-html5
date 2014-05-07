#!/bin/bash

# set env variables for this tomcat instance
. $HOME/tomcat6/conf/tomcat6.conf
export CATALINA_BASE CATALINA_HOME JASPER_HOME CATALINA_TMPDIR TOMCAT_USER
export SECURITY_MANAGER SHUTDOWN_WAIT SHUTDOWN_VERBOSE CATALINA_PID

GUACD_PID=$HOME/.guacamole/guacd.pid

# TODO: figure out how to resize VNC display to match user's browser pane

vncserver :1 -name "JBDS via HTML5" -geometry 1280x1024 -depth 24
echo "Xvnc and fluxbox launched."

# start guacd and tomcat6
/usr/sbin/guacd -b localhost -l 4822 -p $GUACD_PID
/usr/sbin/tomcat6 start

DISPLAY=:1 /usr/share/jbdevstudio/jbdevstudio -nosplash -data $HOME/workspace &
echo "JBDS (Java) launched."
echo

# wait for JBDS to fully start up and get past splash screen
sleep 30

DISPLAY=:1 wmctrl -r "JBoss Developer Studio" -b add,fullscreen
echo "JBDS now in fullscreen"

