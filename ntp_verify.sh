# /bin/bash

if [ ! $(dpkg -s sendmail | grep Status | cut -d" " -f4) == "installed" ]; then
  sudo apt-get -y install sendmail
fi

if [ $(sudo service ntp status | grep Active | cut -d" " -f5) == "inactive" ]; then
  sudo service ntp restart
fi

diff=$(cd /etc && git diff ntp.conf)

if [ -n "${diff/[ ]*\n/}" ]; then
  echo "NOTICE: /etc/ntp.conf was changed. Calculated diff:"
  echo "$(cd /etc && git diff ntp.conf | cut -d$'\n' -f3-)"
  $(cd /etc && git checkout HEAD ntp.conf)
  sudo service ntp restart
else
  exit 0
fi

