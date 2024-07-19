#!/bin/bash

# 변수 선언
export hostip_address="58.229.176.26"

# 임시파일 삭제
rm -f /tmp/vhosts.conf_tempfile
rm -f /tmp/cband.conf_tempfile

# 임시파일 생성
touch /tmp/vhosts.conf_tempfile
touch /tmp/cband.conf_tempfile

# 사용자 생성 및 패스워드 설정
/usr/sbin/useradd -m -s /bin/bash -d /home/$1 -g www $1
passwd $1

# 용량 설정 (test7 사용자의 쿼터를 복사)
edquota -p test7 -u $1

# 홈페이지 디렉토리 생성 및 설정
chmod 701 /home/$1
mkdir -p /home/$1/www
chmod 755 /home/$1/www
chown $1:www /home/$1/www
mkdir /etc/httpd/logs/vhosts/$1
chmod 755 /etc/httpd/logs/vhosts/$1

# 가상 호스트 설정을 임시 파일에 작성
echo "" >> /tmp/vhosts.conf_tempfile
echo "<VirtualHost *:80>" >> /tmp/vhosts.conf_tempfile
echo "    ServerAdmin webmaster@" >> /tmp/vhosts.conf_tempfile
echo "    DocumentRoot /home/$1/www" >> /tmp/vhosts.conf_tempfile
echo "    ServerName $1.web2002.kr" >> /tmp/vhosts.conf_tempfile
echo "    ServerAlias $1.web2002.kr" >> /tmp/vhosts.conf_tempfile
echo "<Directory /home/$1/www>" >> /tmp/vhosts.conf_tempfile
echo "    Options -ExecCGI" >> /tmp/vhosts.conf_tempfile
echo "    AllowOverride All" >> /tmp/vhosts.conf_tempfile
echo "    Order Deny,Allow" >> /tmp/vhosts.conf_tempfile
echo "    Allow from all" >> /tmp/vhosts.conf_tempfile
echo "    Require all granted" >> /tmp/vhosts.conf_tempfile
echo "    RMode config" >> /tmp/vhosts.conf_tempfile
echo "    RUidGid $1 www" >> /tmp/vhosts.conf_tempfile
echo "</Directory>" >> /tmp/vhosts.conf_tempfile
echo "    ErrorLog logs/vhosts/$1/$1-error_log" >> /tmp/vhosts.conf_tempfile
echo "    CustomLog logs/vhosts/$1/$1-access_log combined" >> /tmp/vhosts.conf_tempfile
echo "    php_admin_flag display_errors Off" >> /tmp/vhosts.conf_tempfile
echo "    php_admin_flag allow_url_fopen Off" >> /tmp/vhosts.conf_tempfile
echo "    php_admin_flag register_globals Off" >> /tmp/vhosts.conf_tempfile
echo "    php_admin_flag magic_quotes_gpc Off" >> /tmp/vhosts.conf_tempfile
echo "    RewriteCond %{REQUEST_METHOD} ^(TRACE|TRACK)" >> /tmp/vhosts.conf_tempfile
echo "    RewriteRule .* - [F]" >> /tmp/vhosts.conf_tempfile
echo "    RewriteCond %{REQUEST_URI} ^/error/509.html$" >> /tmp/vhosts.conf_tempfile
echo "    RewriteRule ^ http://web2002.co.kr/traffic/index.htm [R=302,L,E=nocache:1]" >> /tmp/vhosts.conf_tempfile
echo "    Include conf/nobots.conf" >> /tmp/vhosts.conf_tempfile
echo "    <IfModule security2_module>" >> /tmp/vhosts.conf_tempfile
echo "    Include conf/modsec_rules/modsecurity-middle.conf" >> /tmp/vhosts.conf_tempfile
echo "    SecRuleEngine On" >> /tmp/vhosts.conf_tempfile
echo "    </IfModule>" >> /tmp/vhosts.conf_tempfile
echo "</VirtualHost>" >> /tmp/vhosts.conf_tempfile

# 기존 vhosts.conf 파일 백업 및 임시 파일 내용을 병합
cp -arp /etc/httpd/conf.d/vhosts.conf /etc/httpd/conf.d/vhosts.conf.old
cat /tmp/vhosts.conf_tempfile >> /etc/httpd/conf.d/vhosts.conf

# cband 설정을 임시 파일에 작성
echo "" >> /tmp/cband.conf_tempfile
echo "<IfModule cband_module>" >> /tmp/cband.conf_tempfile
echo "<CBandUser cband$1>" >> /tmp/cband.conf_tempfile
echo "     CBandUserLimit 3Gi" >> /tmp/cband.conf_tempfile
echo "     CBandUserPeriod 1D" >> /tmp/cband.conf_tempfile
echo "     <Location /throttle-me>" >> /tmp/cband.conf_tempfile
echo "       SetHandler cband-status-me" >> /tmp/cband.conf_tempfile
echo "       AuthName \"cband-status-me\"" >> /tmp/cband.conf_tempfile
echo "       AuthType Basic" >> /tmp/cband.conf_tempfile
echo "       AuthUserFile /usr/local/apache/conf/.$1" >> /tmp/cband.conf_tempfile
echo "       require user $1" >> /tmp/cband.conf_tempfile
echo "     </Location>" >> /tmp/cband.conf_tempfile
echo "   </CBandUser>" >> /tmp/cband.conf_tempfile
echo "</IfModule>" >> /tmp/cband.conf_tempfile

# 기존 cband.conf 파일 백업 및 임시 파일 내용을 병합
cp -arp /etc/httpd/conf.d/cband.conf /etc/httpd/conf.d/cband.conf.old
cat /tmp/cband.conf_tempfile >> /etc/httpd/conf.d/cband.conf

# 변수 선언 해제 (메모리에서 해제)
unset hostip_address

# Apache 설정 파일 문법 검사
/usr/sbin/apachectl -t
