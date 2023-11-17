#!/bin/bash

# Define an array of commands
cmds=(
  "sudo su"
  "root: a1a2a3a4@"
  "lighthouse: 577486xl"
  "lighthouse vnc: a1a2a3a4@@"

  "sudo yum install gvim"
  "yum list installed | grep gvim"
  "sudo yum remove gvim"
  "rpm -q tigervnc-server"

  "ifconfig"
  "hostname i"
  "lscpu"
  "df -h"
  "free -m"
  "uname -a"
  "/opt/synopsys/lic/lmgrd -c /opt/synopsys/lic/Synopsys.dat"
  "sudo crontab -l -u root"
  "sudo crontab -l -u lighthouse"
  
  "*********************************************************"
  "vncserver -kill :1"
  "sudo rm /tmp/.X11-unix/X1"
  "vncpasswd"

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

  "sudo systemctl restart sshd" 

  "sudo systemctl status lightdm"
  "sudo systemctl start lightdm"
  "sudo systemctl stop lightdm"
  "sudo systemctl restart lightdm"
  "sudo systemctl enable lightdm"   

  "sudo systemctl start firewalld"
  "sudo systemctl stop firewalld"
  "sudo systemctl restart firewalld"
  "sudo firewall-cmd --zone=public --add-port=22/tcp --permanent"
  "sudo firewall-cmd --zone=public --add-port=3389/tcp --permanent"
  "sudo firewall-cmd --zone=public --add-port=5901-5910/tcp --permanent"
  "sudo firewall-cmd --zone=public --add-port=6000-6010/tcp --permanent"
  "sudo firewall-cmd --zone=public --add-port=177/udp --permanent"
  "sudo firewall-cmd --zone=public --remove-port=6000/tcp --permanent"
  "sudo firewall-cmd --zone=public --remove-port=6001/tcp --permanent"
  "sudo firewall-cmd --reload"
  "sudo firewall-cmd --state"
  "sudo firewall-cmd --list-all"

  "*********************************************************"
  "sudo vim /etc/systemd/system/vncserver@:1.service"
  "sudo vim ~/.vnc/config"
  "sudo vim /etc/gdm/custom.conf"
  "sudo vim /etc/lightdm/lightdm.conf"
  "sudo vim /etc/fstab"
  "sudo vim /etc/passwd"
  "sudo vim /etc/ssh/sshd_config"
  "sudo tree /etc/rc.d/rc.local"
  "sudo tree /etc/systemd/system"

  "*********************************************************"
  "sudo systemctl list-units --type=service --state=running"
  "sudo systemctl daemon-reload"
  "sudo firewall-cmd --state"
  "sudo firewall-cmd --list-all"
  "nmap -p- 192.168.1.1"
  "nmap localhost"
  "sudo nmap -sU localhost"
  "ss -tuln"
  "lsof -i"
  "netstat -nap"
)

# Function to print available commands with numbers
tips() {
  for i in "${!cmds[@]}"; do
    echo "$((i+1)) => ${cmds[i]}"
  done
}

# Main interactive loop
while true; do
  # Print available commands
  tips

  # Prompt for user input
  read -p "Enter the command number to execute (or 'q' to quit): " choice

  # Check if user wants to quit
  if [[ "$choice" == "q" ]]; then
    echo "Exiting."
    exit 0
  fi

  # Check if the choice is a valid number
  if [[ "$choice" =~ ^[0-9]+$ ]] && ((choice >= 1 && choice <= ${#cmds[@]})); then
    # Execute the chosen command
    eval "${cmds[choice-1]}"
  else
    echo "Invalid choice. Please enter a valid command number or 'q' to quit."
  fi

  # Prompt to continue
  read -p "Press Enter to continue..."
  clear  # Clear the screen for the next iteration
done

