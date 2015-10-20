#!/bin/bash

# launch the Xvnc server which will launch openbox and your app
vncserver :1 -name 'Desktop Name' -geometry 800x600 -depth 24

# expose the Xvnc server via guacamole
sudo systemctl start guacd
sudo systemctl start tomcat

