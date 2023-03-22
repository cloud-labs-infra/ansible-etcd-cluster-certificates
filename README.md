Role Name
=========

Ansible role to create and manage SSL certificates on single or multi-node ETCD setup. [CFSSL](https://github.com/cloudflare/cfssl) now is the only supported certificate provider. 

Requirements
------------

- CFSSL binaries are not supplied with this role and should be installed using other roles or manually (it's not recommended)
- `iproute2` package in Debian-like systems is required to gather network facts but may not be supplied in basic installations (or in containers) by default

Role Variables
--------------

All variables are defined as defaults in [defaults/main.yml](defaults/main.yml) and may be overrided.

| Name           | Default value | Description                        |
| -------------- | ------------- | -----------------------------------|
|`etcd_cert_user`|root|Certificate owner user|
|`etcd_cert_group`|root|Certificate owner group|
|`etcd_cert_dir`|/etc/ssl/private/|Directory to store certificates|
|`etcd_cert_default_inventory_group_name`|etcd|Inventory group name of ETCD cluster hosts.<br/><br/>Role contains complicated logic how to generate CA certificate pair only on the first node of that group and then distribute key pair to other hosts |
|`etcd_cert_ca_cert_remote_path`|-|A path to the CA certificate on the remote node (not in Ansible play host).<br/><br/>Certificate should be copied to the remote node in advance|
|`etcd_cert_ca_key_remote_path`|-|A path to the CA key on the remote node (not in Ansible play host).<br/><br/>Key should be copied to the remote node in advance|
|`etcd_cert_expiry`|43800h|Certificate expiry in hours|
|`etcd_cert_ca_config`|See [defaults/main.yml](defaults/main.yml)|CA config with all required certificate profiles|
|`etcd_cert_ca_csr`|See [defaults/main.yml](defaults/main.yml)|CA Certificate Signing Request (CSR)|
|`etcd_cert_server_profile_name`|server|Server profile name that should be included in CA config.<br><br>There is a preflight check of that condition|
|`etcd_cert_server_output_name`|{{etcd_cert_server_profile_name}}|Output server certificate files prefix|
|`etcd_cert_server_hosts`|- "{{inventory_hostname}}"<br>- "{{ansible_default_ipv4.address}}"|Ip addresses or DNS names included into SAN field of server certificate|
|`etcd_cert_server_csr`|See [defaults/main.yml](defaults/main.yml)|Server Certificate Signing Request (CSR)|
|`etcd_cert_peer_profile_name`|peer|Server profile name that should be included in CA config.<br><br>There is a preflight check of that condition|
|`etcd_cert_peer_output_name`|{{etcd_cert_peer_profile_name}}|Output peer certificate files prefix|
|`etcd_cert_peer_hosts`|- "{{inventory_hostname}}"<br>- "{{ansible_default_ipv4.address}}"|Ip addresses or DNS names included into SAN field of peer certificate|
|`etcd_cert_peer_csr`|See [defaults/main.yml](defaults/main.yml)|Peer Certificate Signing Request (CSR)|
|`etcd_cert_client_profile_name`|client|Client profile name that should be included in CA config.<br><br>There is a preflight check of that condition|
|`etcd_cert_client_output_name`|{{etcd_cert_client_profile_name}}|Output client certificate files prefix|
|`etcd_cert_client_csr`|See [defaults/main.yml](defaults/main.yml)|Client Certificate Signing Request (CSR)|

Dependencies
------------

You may use any Ansible role to install CFSSL binaries but I recommend you the following:

- [andrewrothstein.cfssl](https://galaxy.ansible.com/andrewrothstein/cfssl)

Example Playbook
----------------

You can also find role usage examples in converge playbooks from `molecule/` direcotry. Here is another example:

```yaml
- hosts: all
  become: true
  roles:
    - { role: andrewrothstein.cfssl }
    - { role: ansible-etcd-cluster-certificates }
```

And also `requirements.yml`:

```yaml
- name: andrewrothstein.cfssl

- name: ansible-etcd-cluster-certificates
  scm: git
  src: https://github.com/cloud-labs-infra/ansible-etcd-cluster-certificates.git
```

License
-------

BSD

Author Information
------------------

Cloud Labs shared roles
