#!/bin/bash

# set up local tomcat instance
mkdir -p tomcat6
pushd tomcat6
  mkdir -p webapps conf logs run temp work
  ln -s /usr/share/tomcat6/bin .
  ln -s /usr/share/tomcat6/lib .
  cp -r /usr/share/tomcat6/conf/* conf

  pushd conf
    sed -i 's/^\(CATALINA_BASE=\)..*/\1\"\$HOME\/tomcat6\"/g' tomcat6.conf
    sed -i 's/^\(CATALINA_HOME=\)..*/\1\"\$HOME\/tomcat6\"/g' tomcat6.conf
    sed -i 's/^\(JASPER_HOME=\)..*/\1\"\$HOME\/tomcat6\"/g' tomcat6.conf
    sed -i 's/^\(CATALINA_TMPDIR=\)..*/\1\"\$HOME\/tomcat6\"/g' tomcat6.conf
    sed -i 's/^\(TOMCAT_USER=\)..*/\1\"\$USER\"/g' tomcat6.conf
    sed -i 's/^\(CATALINA_PID=\)..*/\1\"\$HOME\/tomcat6\/run\/tomcat6.pid\"/g' tomcat6.conf
  popd

  cp $HOME/resources/guacamole-0.8.3.war webapps/guacamole.war
  chmod 644 webapps/guacamole.war
popd

# set up guacamole config
mkdir -p .guacamole
cp resources/guacamole.properties resources/user-mapping.xml .guacamole

# set up JBDS workspace
mkdir -p workspace

# set vnc password and fluxbox startup
mkdir -p .vnc
cp resources/xstartup .vnc
echo "VNCPASS" | vncpasswd -f > .vnc/passwd
chmod 600 .vnc/passwd
chmod 740 .vnc

