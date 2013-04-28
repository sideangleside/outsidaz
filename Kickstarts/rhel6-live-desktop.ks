# rhel6-live-desktop.ks
#

lang en_US.UTF-8
keyboard us
timezone US/Eastern
auth --useshadow --enablemd5
selinux --enforcing
firewall --enabled --service=mdns
xconfig --startxonboot
part / --size 4096 --fstype ext4
services --enabled=NetworkManager --disabled=network,sshd
firstboot --disable

# Pro Tip: RHN Satellite kickstart trees are yum repos 
repo --name=released --baseurl=http://satellite1.auroracloud.com/ks/dist/ks-rhel-x86_64-server-6-6.4/

%packages
@base
@core
@basic-desktop
@fonts
@internet-browser
@java-platform
@print-client
@x11
kernel
memtest86+
anaconda
isomd5sum
-system-config*
spice-xpi

%end

%post

# Disable firstbooot so it doesn't run
/sbin/chkconfig firstboot off


# Create a 'kiosk' user and set his password to 'kiosk'
/usr/sbin/useradd kiosk
/usr/sbin/usermod -p '$6$opOZ/W/.$i.i/LNRqfrVc7VzlK0RhmzTtN2ZXt5NAfg6aViaN6x77c.HT9wmHd2s1ewBp06XVvv.1pvDB0D17Xy2FOxTt/0' kiosk

# Configure GNOME for auto-login
cat > /etc/gdm/custom.conf <<EOF
# GDM configuration storage

[xdmcp]

[chooser]

[security]

[debug]

[daemon]
AutomaticLoginEnable=true
AutomaticLogin=kiosk
TimedLoginEnable=true
TimedLogin=kiosk
TimedLoginDelay=0
EOF




%end
	
