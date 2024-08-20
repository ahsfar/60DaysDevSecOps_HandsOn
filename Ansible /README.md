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

—--

in Playbook {{ansible_variable}}

vi /home/bob/playbooks/playbook.yaml

---
- name: 'Add nameserver in resolv.conf file on localhost'
  hosts: localhost
  become: yes
  tasks:
    - name: 'Add nameserver in resolv.conf file'
      lineinfile:
        path: /tmp/resolv.conf
        line: 'nameserver {{  nameserver_ip  }}'
    - name: 'Disable SNMP Port'
      firewalld:
        port: '{{ snmp_port }}'
        permanent: true
        state: disabled

---
- hosts: localhost
  vars:
    car_model: 'BMW M3'
    country_name: USA
    title: 'Systems Engineer'
  tasks:
    - command: 'echo "My car is {{ car_model }}"'
    - command: 'echo "I live in the {{ country_name }}"'
    - command: 'echo "I work as a {{ title }}"'

---
- hosts: all
  become: yes
  tasks:
    - name: Install applications
      yum:
        name: "{{ item }}"
        state: present
      with_items:
        - "{{ app_list }}"

---
- hosts: all
  become: yes
  tasks:
    - name: Set up user
      user:
        name: "{{ user_details.username }}"
        password: "{{ user_details.password }}"
        comment: "{{ user_details.email }}"
        state: present



# module:


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


# Playbook:

- hosts: all
  tasks:
    - name: Set max connections
      lineinfile:
        path: /etc/postgresql/12/main/postgresql.conf
        line: 'max_connections = 500'

    - name: Set listen addresses
      lineinfile:
        path: /etc/postgresql/12/main/postgresql.conf
        line: 'listen_addresses = "*"'

---
- name: 'Execute two commands on node01'
  hosts: node01
  become: yes
  tasks:
    - name: 'Execute a date command'
      command: date
    - name: 'Task to display hosts file on node01'
      command: 'cat /etc/hosts'
- name: 'Execute a command on node02'
  hosts: node02
  become: yes
  tasks:
    - name: 'Task to display hosts file on node02'
      command: cat /etc/hosts

# Conditionals:

ansible_os_family

---
-  name: 'Execute a script on all web server nodes'
   hosts: all
   become: yes
   tasks:
     -  service: 'name=nginx state=started'
        when: 'ansible_host=="node02"'

---
- name: 'Am I an Adult or a Child?'
  hosts: localhost
  vars:
    age: 25
  tasks:
    - name: I am a Child
      command: 'echo "I am a Child"'
      when: 'age < 18'
    - name: I am an Adult
      command: 'echo "I am an Adult"'
      when: 'age >= 18'

---
- name: 'Add name server entry if not already entered'
  hosts: localhost
  become: yes
  tasks:
    - shell: 'cat /etc/resolv.conf'
      register: command_output
    - shell: 'echo "nameserver 10.0.250.10" >> /etc/resolv.conf'
      when: 'command_output.stdout.find("10.0.250.10") == -1'

# Loops:

---
-  name: 'Print list of fruits'
   hosts: localhost
   vars:
     fruits:
       - Apple
       - Banana
       - Grapes
       - Orange
   tasks:
     - command: 'echo "{{ item }}"'
       with_items: '{{ fruits }}'

---
- name: 'Install required packages'
  hosts: localhost
  become: yes
  vars:
    packages:
      - httpd
      - make
      - vim
  tasks:
    - yum:
        name: '{{ item }}'
        state: present
      with_items: '{{ packages }}'






