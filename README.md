# Ansible
A repo for Ansible Study

Ansible: A Beginner‑Friendly Overview
Ansible is an automation tool used to configure systems, deploy software, and orchestrate tasks across multiple machines. It’s designed to be simple, predictable, and easy to learn — especially for people who prefer hands‑on, practical workflows.

🌐 What Makes Ansible Different
- Agentless
Uses SSH (Linux/macOS) or WinRM (Windows). No agents to install or maintain.
- Declarative
You describe the desired state; Ansible figures out how to reach it.
- Idempotent
Running the same playbook twice won’t break anything — unchanged tasks are skipped.
- Human‑Readable YAML
Playbooks are written in YAML, making them easy to understand and share.
- Scales Easily
Works for a single laptop or thousands of servers.

🧩 Core Concepts (Expanded)
1. Inventory
The inventory defines the hosts Ansible manages. It can be a simple static file or dynamically generated.
Example: inventory.ini
[web]
192.168.1.10
192.168.1.11

[db]
db01.example.com


Key points
- Groups let you target sets of machines.
- You can assign variables to hosts or groups.
- Inventories can be INI, YAML, or dynamic scripts.

2. Modules
Modules are the building blocks of Ansible. Each task uses a module to perform an action.
Common module categories
- Package management (apt, yum, package)
- File operations (copy, template, file)
- System services (service, systemd)
- Users and groups (user, group)
- Cloud providers (AWS, Azure, GCP)
Example task using a module
- name: Install nginx
  apt:
    name: nginx
    state: present



3. Tasks
A task is a single action executed on the target host.
Characteristics
- Uses one module.
- Has a descriptive name.
- Runs in order, top to bottom.
Example
- name: Ensure SSH is installed
  apt:
    name: openssh-server
    state: present



4. Playbooks
Playbooks are YAML files that define what to configure and where to apply it.
Example: site.yml
- hosts: web
  become: yes
  tasks:
    - name: Install nginx
      apt:
        name: nginx
        state: present

    - name: Ensure nginx is running
      service:
        name: nginx
        state: started
        enabled: yes


Key features
- Can target multiple groups.
- Support variables, handlers, templates, and roles.
- Easy to version‑control and share.

5. Variables
Variables make playbooks flexible and reusable.
Example
vars:
  app_port: 8080


Variables can live in:
- Playbooks
- Inventory files
- Group/host variable files
- Role defaults
- Extra vars (--extra-vars)

6. Templates
Templates use Jinja2 syntax to generate dynamic configuration files.
Example: nginx.conf.j2
server {
    listen {{ app_port }};
    server_name {{ inventory_hostname }};
}



7. Handlers
Handlers run only when notified — perfect for restarting services after changes.
Example
- name: Copy nginx config
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  notify: Restart nginx

handlers:
  - name: Restart nginx
    service:
      name: nginx
      state: restarted



8. Roles
Roles are structured, reusable bundles of tasks, templates, variables, and handlers.
Typical role structure
roles/
  webserver/
    tasks/
    handlers/
    templates/
    vars/
    defaults/
    files/


Roles help keep large projects clean and maintainable.

🚀 What You Can Automate with Ansible
- Provisioning servers
- Installing packages and dependencies
- Managing users and permissions
- Deploying applications
- Configuring services (Nginx, Docker, databases)
- Setting up development environments
- Orchestrating multi‑step workflows
If you enjoy building repeatable, reliable setups — Ansible is a perfect fit.

🛠️ Example: Your First Playbook
- hosts: all
  become: yes
  tasks:
    - name: Update package cache
      apt:
        update_cache: yes

    - name: Install Git
      apt:
        name: git
        state: present


Run it with:
ansible-playbook -i inventory.ini site.yml




