
Installation
------------

Make sure that the 'resources' directory contains the file:

  jbdevstudio-product-universal-7.1.1.GA-v20140314-2145-B688.jar

Install a RHEL 6.x basic server as a virtual guest.  As root on
the virtual guest, create an unprivileged user to run the JBDS web
application:

  useradd -c "JBDS User" jbdsuser
  passwd jbdsuser

On the host server, copy all the files in this directory to the
unprivileged user account:

  scp -r * jbdsuser@192.168.122.40:

where 192.168.122.40 should be substituted with the IP address of the
virtual guest.

Logon as the jbdsuser on the virtual guest.  Install the necessary
packages as root:

  su
  ./root-setup.sh
  exit

As the unprivileged user, run the setup script:

  ./setup.sh

Running
-------

To start all the required components, use the start script:

  ./start.sh

Next, browse to the guacamole app from the host server using the URL:

  http://192.168.122.40:8080/guacamole

where 192.168.122.40 should be substituted with the IP address of the
virtual guest.  User name is "openshift" and password is "changeme".
On the next page, click on the window graphic to launch the viewer for the
JBDS application.  At that point, simply use JBDS like any X application
but realize that you're doing it via HTML 5 and a browser window.
It works amazingly well.

To stop everything, use the stop script:

  ./stop.sh

Files in 'resources' Directory
--------------------------------------
* epel-release-6-8.noarch.rpm	- Extra packages for Enterprise Linux
* guacamole-0.8.3.war		- guacamole web app to translate guacd events to HTML5
* guacamole.properties		- sets guacd host/port and authentication for web user 
* InstallConfigRecord.xml		- automates installation of JBoss Developer Studio 7
* user-mapping.xml		- defines auth for web user and guacd to VNC
* xstartup			- starts fluxbox simple window manager

