#!/bin/bash

sudo systemctl stop tomcat
sudo systemctl stop guacd
vncserver -kill :1
