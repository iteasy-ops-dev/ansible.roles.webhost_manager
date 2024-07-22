Ansible Role: Manage Webhost on Linux
=========

- webhost를 관리합니다.
- 템플릿을 통한 일반화를 위한 작업을 수행합니다.

생성
---
1. 계정 생성
2. quota 설정
3. DB 계정 생성
4. 트래픽 설정(cband)
5. vhost 설정

삭제
---
1. 계정 삭제
2. DB 계정 삭제
3. vhost 삭제

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
```

Dependencies
------------
None.

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

