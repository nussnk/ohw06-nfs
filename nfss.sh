#!/bin/bash

#yum update -y
yum install nfs-utils -y
systemctl enable firewalld --now
firewall-cmd --add-service="nfs3" --add-service="rpc-bind" --add-service="mountd" --permanent
firewall-cmd --reload
systemctl enable nfs --now
mkdir -p /srv/share/upload
chown -R nfsnobody:nfsnobody /srv/share/upload
chmod 0777 -R /srv/share/upload
cat << EOF > /etc/exports
/srv/share/ 192.168.50.11/32(rw,sync,root_squash)
EOF
exportfs -r

