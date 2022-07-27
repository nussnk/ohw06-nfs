# ohw06-nfs
Домашнее задание по теме NFS

Создаем Vagrantfile, который поднимает две виртуалки: сервер и клиент. Каждая виртуалка проходит провиженинг через скрипты
скрипт сервера:

nikolay@kim-test:~/otus/ohw06-nfs$ cat nfss.sh
#!/bin/bash
#ставим необходмые утилиты
yum install nfs-utils -y
#ставим файрвол на автозагрузку и запускаем
systemctl enable firewalld --now
#добавляем правила в файрвол
firewall-cmd --add-service="nfs3" --add-service="rpc-bind" --add-service="mountd" --permanent
#перезапускаем файрвол
firewall-cmd --reload
#ставим сервис nfs на автозагрузку и запускаем его
systemctl enable nfs --now
#создаем папку upload
mkdir -p /srv/share/upload
#задаем владельца папки
chown -R nfsnobody:nfsnobody /srv/share/upload
#задаем права на папку
chmod 0777 -R /srv/share/upload
#прописываем запись об экспортируемом каталоге и клиенте в /etc/exports
cat << EOF > /etc/exports
/srv/share/ 192.168.50.11/32(rw,sync,root_squash)
EOF
#делаем переэкспорт
exportfs -r

теперь скрипт клиента:
nikolay@kim-test:~/otus/ohw06-nfs$ cat nfsc.sh
#!/bin/bash
#ставим необходмые утилиты
yum install nfs-utils -y
#ставим файрвол на автозагрузку и запускаем
systemctl enable firewalld --now
#добавляем запись в /etc/fstab для автомонтирования шары с сервера
echo "192.168.50.10:/srv/share/ /mnt nfs vers=3,proto=udp,noauto,x-systemd.automount 0 0" >> /etc/fstab
#перезапускаем systemd демона
systemctl daemon-reload
#подключаем папку
systemctl restart remote-fs.target



