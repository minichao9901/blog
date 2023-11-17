#!/bin/bash

# Define an array of commands
cmds=(
  "sudo su"

  "vncserver -kill :1"
  "sudo rm /tmp/.X11-unix/X1"
  "vncpasswd"
  "vim ~/.vnc/config"

  "sudo systemctl daemon-reload"
  "sudo systemctl status vncserver@:1.service"
  "sudo systemctl start vncserver@:1.service"
  "sudo systemctl stop vncserver@:1.service" 
  "sudo systemctl restart vncserver@:1.service"
  "sudo systemctl enable vncserver@:1.service" 
  "vnc flow: stop->kill->start->status"

  "sudo systemctl status xrdp"
  "sudo systemctl start xrdp"
  "sudo systemctl stop xrdp"
  "sudo systemctl restart xrdp"
  "sudo systemctl enable xrdp"   

  "sudo vi /etc/ssh/sshd_config"
  "sudo systemctl restart sshd" 

  "sudo firewall-cmd --state"
  "sudo firewall-cmd --list-all"
  "sudo systemctl start firewalld"
  "sudo systemctl stop firewalld"
  "sudo systemctl restart firewalld"
  "sudo firewall-cmd --zone=public --add-port=22/tcp --permanent"
  "sudo firewall-cmd --reload"

  "sudo yum install gvim"
  "yum list installed | grep gvim"
  "sudo yum remove gvim"
  "rpm -q tigervnc-server"

  "sudo systemctl list-units --type=service --state=running"
  "nmap -p- 192.168.1.1"
  "nmap localhost"
  "sudo nmap -sU localhost"
  "ss -tuln"
  "lsof -i"
  "netstat -nap"
  "ifcofig"

  "hostname i"
  "lscpu"
  "df -h"
  "free -m"
  "uname -a"
  "/opt/synopsys/lic/lmgrd -c /opt/synopsys/lic/Synopsys.dat"
  "sudo crontab -l -u root"
  "sudo crontab -l -u lighthouse"
  
  "sudo cat /etc/gdm/custom.conf"
  "sudo cat /etc/fstab"
  "sudo cat /etc/passwd"
  "sudo cat /etc/ssh/sshd_config"

  "root: a1a2a3a4@"
  "lighthouse: 577486xl"
  "lighthouse vnc: a1a2a3a4@@"
)

# Function to print available commands with numbers
tips() {
  for i in "${!cmds[@]}"; do
    echo "$((i+1))=> ${cmds[i]}"
  done
}

# Check for the "tips" argument to print help
if [ "$1" == "tips" ]; then
  tips
  exit 0
fi

# Get the user-provided line number
line=$1

# Check if the line number is valid
if [[ "$line" -ge 1 && "$line" -le "${#cmds[@]}" ]]; then
  # Execute the corresponding command
  eval "${cmds[$line-1]}"
  exit 0
else
  # Display an error message and usage information
  echo "Invalid line number. Please provide a number between 1 and ${#cmds[@]}." >&2
  tips
  exit 1
fi
