ansible-etcd-cluster-certificates
=========

Ansible role to create and manage SSL certificates on single or multi-node ETCD setup. [CFSSL](https://github.com/cloudflare/cfssl) now is the only supported certificate provider. Read more about ETCD TLS support at [Transport security model](https://etcd.io/docs/v3.5/op-guide/security/) and [Generate self-signed certificates](https://github.com/coreos/docs/blob/master/os/generate-self-signed-certificates.md)

Role generates the following certificates bunch on each host:

```text
# ls -1 /etc/ssl/private
ca-config.json
ca-csr.json
ca-key.pem
ca.pem
client-key.pem
client.csr
client.json
client.pem
peer-key.pem
peer.csr
peer.json
peer.pem
server-key.pem
server.csr
server.json
server.pem
``` 

Requirements
------------

- CFSSL binaries are not supplied with this role and should be installed using other roles or manually (it's not recommended)
- `iproute2` package in Debian-like systems is required to gather network facts but may not be supplied in basic installations (or in containers) by default

Role Variables
--------------

All variables are defined as defaults in [defaults/main.yml](defaults/main.yml) and may be overrided.

| Name                            | Default value                              | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
|---------------------------------|--------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `etcd_cert_user`                | root                                       | Certificate owner user                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| `etcd_cert_group`               | root                                       | Certificate owner group                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| `etcd_cert_dir`                 | /etc/ssl/private/                          | Directory to store certificates                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| `etcd_cert_init_ca_node`        | false                                      | Needs to specify first etcd node where generate CA certificate                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| `etcd_cert_ca_cert_remote_path` | -                                          | A path to the CA certificate on the remote node (not in Ansible play host).<br/><br/>CA certificate should be copied to the remote node in advance                                                                                                                                                                                                                                                                                                                                                                                 |
| `etcd_cert_ca_key_remote_path`  | -                                          | A path to the CA key on the remote node (not in Ansible play host).<br/><br/>CA key should be copied to the remote node in advance                                                                                                                                                                                                                                                                                                                                                                                                 |
| `etcd_cert_expiry`              | 43800h                                     | Certificate expiry in hours                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| `etcd_cert_ca_config`           | See [defaults/main.yml](defaults/main.yml) | CA config with all required certificate profiles.<br><br>Certificates should include appropriate X509v3 certificate extentions depending on usage type (client, server or peer). Read more at [Transport security model](https://etcd.io/docs/v3.5/op-guide/security/) and [Standard X.509 v3 Certificate Extension Reference](https://access.redhat.com/documentation/ru-ru/red_hat_certificate_system/9/html/administration_guide/standard_x.509_v3_certificate_extensions#Standard_X.509_v3_Certificate_Extensions-extKeyUsage) |
| `etcd_cert_ca_csr`              | See [defaults/main.yml](defaults/main.yml) | CA Certificate Signing Request (CSR)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| `etcd_cert_matrix`              | See [defaults/main.yml](defaults/main.yml) | A list with three mandatory fields:<br/>- `profile_name` - name of certificate profile from `etcd_cert_ca_config` variable<br/>- `output_name` - output certificate file names<br/>- `csr` - a SCR in yaml format, will be converted in json<br/><br/>Output file names will be the following:<br>`{{output_name}}-key.pem`<br>`{{output_name}}.csr`<br>`{{output_name}}.pem`                                                                                                                                                      |

Dependencies
------------

You may use any Ansible role to install CFSSL binaries but we recommend you the following:

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

Apache 2.0

Author Information
------------------

Cloud Labs shared roles
