#!/bin/bash

# set env variables for this tomcat instance
. $HOME/tomcat6/conf/tomcat6.conf

export CATALINA_BASE CATALINA_HOME JASPER_HOME CATALINA_TMPDIR TOMCAT_USER
export SECURITY_MANAGER SHUTDOWN_WAIT SHUTDOWN_VERBOSE CATALINA_PID

GUACD_PID=$HOME/.guacamole/guacd.pid

# try three times to shut everything down
for i in {1..3}
do
  # if CATALINA_PID is defined, stop tomcat
  /usr/sbin/tomcat6 stop

  # close the studio window
  if [ ! -z "`pgrep fluxbox`" ]
  then
    if [ ! -z "`DISPLAY=:1 wmctrl -l | grep 'JBoss Developer Studio'`" ]
    then
      echo "Closing jbdevstudio ..."

      DISPLAY=:1 wmctrl -c "JBoss Developer Studio"
 
      echo -n "Wait up to 30 seconds for JBDS to close " 
      for j in {1..15}
      do
        if [ ! -z "`DISPLAY=:1 wmctrl -l | grep 'JBoss Developer Studio'`" ]
        then
          echo -n "."
          sleep 2
        fi
      done
      echo
 
      # if java process still running then kill it 
      pkill java
    fi
  fi
 
  # kill guacd
  if [ -f $GUACD_PID ]
  then
    kill `cat $GUACD_PID`
    rm -f $GUACD_PID
  fi
  
  # if fluxbox running, kill it
  if [ ! -z "`pgrep fluxbox`" ]
  then
    pkill fluxbox
  fi
  
  # if Xvnc running, kill it
  if [ ! -z "`pgrep vnc`" ]
  then
    vncserver -kill :1
  fi
done  
