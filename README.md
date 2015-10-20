
Overview
--------

This project enables JBoss Developer Studio to run in a browser by
leveraging the guacamole project to translate Xvnc events to HTML5.
This same method can be used to run any XWindows application via a
browser.  My goal is to convert this to an OpenShift 3 instant
application so developers could self-provision their IDE and then
develop their apps, with both the IDE and the apps being hosted on
OpenShift.

Installation
------------

Make sure that the 'resources' directory contains the file:

    jboss-devstudio-8.1.0.GA-installer-standalone.jar

Install a RHEL 7.x minimal server as a virtual guest.  During
installation, add an unprivileged user that has administrator
privileges via sudo.

Copy all the files in this directory to the unprivileged user account
on the guest VM:

    scp -r * jbdsuser@192.168.122.40:

where jbdsuser and 192.168.122.40 should be substituted with the
unprivileged user name and IP address of the virtual guest,
respectively.

Logon as the unprivileged user on the virtual guest.  To install
the required packages, run the command:

    sudo ./root-setup.sh

Reboot the virtual guest after the script completes.

Once the virtual guest is started, logon as the unprivileged user and
run the setup script:

    ./setup.sh

Running
-------

To start all the required components, use the start script:

    ./start.sh

Next, browse to the guacamole web application from the host server
using the URL:

    http://192.168.122.40:8080/guacamole

where 192.168.122.40 should be substituted with the IP address of the
virtual guest.  User name is "openshift" and password is "changeme".
On the next page, click on the window graphic to launch the viewer for the
JBDS application.  At that point, simply use JBDS like any X application
but realize that you're doing it via HTML 5 and a browser window.
It works amazingly well.

To stop everything, use the stop script:

    ./stop.sh

Video
-----

There's a [video](https://vimeo.com/95063680) demonstrating the installation and use of this capability.
An unprivileged user on a guest VM hosts the Xvnc server, JBoss Developer
Studio, and the guacamole server and then a browser is used to access
and build a project with JBDS.

Screenshots
-----------

The screenshots directory shows the normal user progression of logging
in to guacamole and selecting the active desktop from the dashboard.
The desktop will be scaled to fit within the browser window.  Because I
pre-selected the geometry for the desktop, when I maximize the browser
window the desktop scales to fill the browser.

Files in 'resources' Directory
--------------------------------------
* epel-release-latest-7.noarch.rpm	- Extra packages for Enterprise Linux
* InstallConfigRecord.xml		- automates installation of JBDS 8.1.0
* user-mapping.xml			- defines auth for web user and guacd to VNC

