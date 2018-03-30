# /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Install ntp server package
if [ ! $(dpkg -s ntp | grep Status | cut -d" " -f4) == "installed" ]; then
  sudo apt-get update
  sudo apt-get -y install ntp
  sudo apt-get -y install git
fi

if [ ! -d /etc/.git/ ]; then
  cd /etc && git init && git add ntp.conf && git commit --untracked-files=no -m "Fixing state of ntp.conf"
fi
# replace the first default server to "ua.pool.ntp.org"
sudo sed -i "s/0.ubuntu.pool.ntp.org/ua.pool.ntp.org/" /etc/ntp.conf

# remove the rest of default servers
sudo sed -i "s/pool 1.ubuntu.pool.ntp.org iburst//" /etc/ntp.conf
sudo sed -i "s/pool 2.ubuntu.pool.ntp.org iburst//" /etc/ntp.conf
sudo sed -i "s/pool 3.ubuntu.pool.ntp.org iburst//" /etc/ntp.conf

# restart ntp service
sudo /etc/init.d/ntp restart

#write out current crontab
cd $DIR && touch mycron && echo "* * * * * bash $DIR/ntp_verify.sh" >> mycron && crontab mycron && rm mycron
#echo new cron into cron file

#install new cron file


