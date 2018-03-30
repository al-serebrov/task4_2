# /bin/bash

DIR=$(dirname $0)
# Not sure this is needed
# sudo apt-get update

# Install ntp server package
sudo apt-get -y install ntp
sudo apt-get -y install git

cd eval /etc/ntp.conf
git init && git status && git add . && git commit -m "Fixing state"
# replace the first default server to "ua.pool.ntp.org"
sudo sed -i "s/0.ubuntu.pool.ntp.org/ua.pool.ntp.org/" /etc/ntp.conf

# remove the rest of default servers
sudo sed -i "s/pool 1.ubuntu.pool.ntp.org iburst//" /etc/ntp.conf
sudo sed -i "s/pool 2.ubuntu.pool.ntp.org iburst//" /etc/ntp.conf
sudo sed -i "s/pool 3.ubuntu.pool.ntp.org iburst//" /etc/ntp.conf

# restart ntp service
sudo /etc/init.d/ntp restart

#write out current crontab
touch mycron
#echo new cron into cron file
echo "* * * * * $DIR/ntp_verify.sh" >> mycron
#install new cron file
sudo crontab mycron
rm mycron
