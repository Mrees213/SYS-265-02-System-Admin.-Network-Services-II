#secure-ssh.sh
#author Mrees213
#creates a new ssh user from $1 parameter
#adds a public key from the local repo or culred from the remote repo
#removes roots ability to ssh in
#!/bin/bash

# Check if a username was provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

# Set the username from the first argument
USERNAME=$1

# Create the new user
sudo adduser --gecos "" $USERNAME

# Add user to sudo group
sudo usermod -aG sudo $USERNAME

# Create .ssh directory for the new user
sudo mkdir -p /home/$USERNAME/.ssh

# Add public key from local repo or curl from remote repo
if [ -f "/home/morgan/SYS-265-02-System-Admin.-Network-Services-II/linux/public-keys/id_rsa.pub" ]; then
    sudo cat /home/morgan/SYS-265-02-System-Admin.-Network-Services-II/linux/public-keys/id_rsa.pub | sudo tee -a /home/$USERNAME/.ssh/authorized_keys
else
    sudo curl -s https://github.com/Mrees213/SYS-265-02-System-Admin-Network-Services-II/blob/main/linux/public-keys/id_rsa.pub | sudo tee -a /home/$USERNAME/.ssh/authorized_keys
fi

# Set correct permissions for .ssh directory and authorized_keys file
sudo chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
sudo chmod 700 /home/$USERNAME/.ssh
sudo chmod 600 /home/$USERNAME/.ssh/authorized_keys
# Disable root SSH login
# sudo sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

# Restart SSH service
sudo systemctl restart ssh

echo "User $USERNAME created with SSH access. Root SSH login disabled."




