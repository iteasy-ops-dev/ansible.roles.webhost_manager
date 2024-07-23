Ansible Role: Manage Webhost on Linux
=========

- webhost를 관리합니다.
- 템플릿을 통한 일반화를 위한 작업을 수행합니다.

생성
---
1. [x] 계정 생성
2. [x] quota 설정 * 제외 예정
3. [x] DB 계정 생성
4. [x] 트래픽 설정(cband)
5. [x] vhost 설정

삭제
---
1. [x] 계정 삭제
2. [x] DB 계정 삭제
3. [ ] vhost 삭제

Requirements
------------
None.

Role Variables
--------------
- `defaults/main.yml` 참조
```yaml
user_id: ""
user_pass: ""
cband_limit: ""
disk_quota: ""
vhost_domain: ""
listen_port: ""

mysql_root_user: ""
mysql_root_password: ""
db_user: ""
db_name: ""
db_password: ""

setup: true
```

Dependencies
------------
Unknown.

Example Playbook
----------------
- `test/` 참조
```yaml
- hosts: vms
  remote_user: root
  roles:
    - ansible.roles.webhost_manager
```

License
------------
BSD

