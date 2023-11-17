sudo systemctl stop vncserver@:1.service
sudo rm /tmp/.X11-unix/X1
sudo systemctl start vncserver@:1.service
sudo systemctl status vncserver@:1.service

