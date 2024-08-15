# This is the README for Ansible


# ansible: inventory

## Web Servers
web1 ansible_host=server1.company.com ansible_connection=ssh ansible_user=root ansible_ssh_pass=123
web2 ansible_host=server2.company.com ansible_connection=ssh ansible_user=root ansible_ssh_pass=123
web3 ansible_host=server3.company.com ansible_connection=ssh ansible_user=root ansible_ssh_pass=123


## DB Server
db1 ansible_host=server4.company.com ansible_connection=winrm ansible_user=administrator ansible_winrm_pass=123

[web_servers]
web1
web2
web3

[db_servers]
db1

[all_servers:children]
web_servers
db_servers


## Sample Inventory File

## Web Servers
web_node1 ansible_host=web01.xyz.com ansible_connection=winrm ansible_user=administrator ansible>
web_node2 ansible_host=web02.xyz.com ansible_connection=winrm ansible_user=administrator ansible>
web_node3 ansible_host=web03.xyz.com ansible_connection=winrm ansible_user=administrator ansible>

## DB Servers
sql_db1 ansible_host=sql01.xyz.com ansible_connection=ssh ansible_user=root ansible_ssh_pass=Lin>
sql_db2 ansible_host=sql02.xyz.com ansible_connection=ssh ansible_user=root ansible_ssh_pass=Lin>


[db_nodes]
sql_db1  
sql_db2

[web_nodes]
web_node1
web_node2
web_node3

[boston_nodes]
sql_db1
web_node1

[dallas_nodes]
sql_db2
web_node2
web_node3 

[us_nodes:children]
boston_nodes
dallas_nodes 


—


# ansible: module:


---
- name: 'hosts'
  hosts: all
  become: yes
  tasks:
    - name: 'Execute a script'
      script: '/tmp/install_script.sh'
    - name: 'Start httpd service'
      service:
        name: 'httpd'
        state: 'started'
    - name: "Update /var/www/html/index.html"
      lineinfile:
        path: /var/www/html/index.html
        line: "Welcome to ansible-beginning course"
        create: true
    - name: 'Create a new user'
      user:
        name: 'web_user'
        uid: 1040
        group: 'developers'


# ansible: roles:

---
collections:
  - name: community.general
    version: '1.0.0'
  - name: amazon.aws
    version: '1.2.1'


ansible-galaxy collection install -r requirements.yml



---
- hosts: localhost
  tasks:
    - name: Install the networking_tools collection
      ansible.builtin.ansible_galaxy_collection:
        name: company_xyz.networking_tools
        source: https://galaxy.ansible.com

- hosts: switches
  collections:
    - company_xyz.networking_tools
  tasks:
    - name: Configure VLAN 10
      configure_vlan:
        vlan_id: 10
        vlan_name: Admin_VLAN


---
- name: Test Handler Execution
  hosts: localhost
  tasks:
    - name: Copy file1.conf
      copy:
        src: files/file1.conf
        dest: /tmp/file1.conf
      notify: Sample Handler

    - name: Copy file2.conf
      copy:
        src: files/file2.conf
        dest: /tmp/file2.conf
      notify: Sample Handler

  handlers:
    - name: Sample Handler
      debug:
        msg: "Handler has been triggered!"

