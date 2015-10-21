#!/bin/bash -x

# waits until desired window, with name in $1, is active
function wait_for_window {
    while [ "x`DISPLAY=:1 wmctrl -l | grep "$1"`" = "x" ]
    do
       sleep 2
    done
}

# launch the Xvnc server which will launch openbox and your app
vncserver :1 -name 'Desktop Name' -geometry 1440x726 -depth 24

# expose the Xvnc server via guacamole
sudo systemctl start guacd
sudo systemctl start tomcat

# close the VNC config window
wait_for_window 'VNC config'
vncwin=`DISPLAY=:1 wmctrl -l | grep 'VNC config' | cut -d' ' -f1`
DISPLAY=:1 wmctrl -i -c $vncwin

# fullscreen JBDS
wait_for_window 'JBoss - JBoss Central - JBoss Developer Studio'
jbdswin=`DISPLAY=:1 wmctrl -l | \
    grep 'JBoss - JBoss Central - JBoss Developer Studio' | \
    cut -d' ' -f1`
DISPLAY=:1 wmctrl -i -r $jbdswin -b add,fullscreen
