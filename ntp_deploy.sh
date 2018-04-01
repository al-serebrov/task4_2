# /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Install ntp server package
if [ -z "$(apt -qq --installed list ntp)" ]; then
  sudo apt-get update
  sudo apt-get -y install ntp
  sudo apt-get -y install git
fi

# check if sendmail installed, if not - install it
if [ -z "$(apt -qq --installed list sendmail)" ]; then
  sudo apt-get -y install sendmail
fi

# replace the first default server to "ua.pool.ntp.org"
sudo sed -i "s/0.ubuntu.pool.ntp.org/ua.pool.ntp.org/" /etc/ntp.conf

# remove the rest of default servers
sudo sed -i "s/pool 1.ubuntu.pool.ntp.org iburst//" /etc/ntp.conf
sudo sed -i "s/pool 2.ubuntu.pool.ntp.org iburst//" /etc/ntp.conf
sudo sed -i "s/pool 3.ubuntu.pool.ntp.org iburst//" /etc/ntp.conf

# Commit changed state
if [ ! -d /etc/.git/ ]; then
	pushd /etc
	git init
	git config user.email "serebrov.alexandr@gmail.com"
	git config user.name "Alexander Serebrov"
	git add ntp.conf
	git commit --untracked-files=no -m "Fixing state of ntp.conf"
	popd
fi

# restart ntp service
sudo /etc/init.d/ntp restart

#write out current crontab
cd $DIR && touch mycron && echo "* * * * * bash $DIR/ntp_verify.sh" >> mycron && crontab mycron && rm mycron
