#!/bin/sh

echo "Install Ansible Roles."
ansible-galaxy install --force --ignore-errors -r requirements.yml -p roles

echo "Test Ansible Roles."
ansible-playbook -i inventory test.yml -vvvvv



# userdel iteasy
# rm -rf /home/iteasy/
# rm -rf /etc/httpd/logs/vhosts/iteasy/
# echo > /etc/httpd/conf.d/vhosts.conf
# echo > /etc/httpd/conf/nobots.conf
# echo > /etc/httpd/conf.d/cband.conf
# /usr/sbin/apachectl -t
# userdel iteasy1
# rm -rf /home/iteasy1/
# rm -rf /etc/httpd/logs/vhosts/iteasy1/
# userdel iteasy2
# rm -rf /home/iteasy2/
# rm -rf /etc/httpd/logs/vhosts/iteasy2/