# /bin/bash

if [ $(sudo service ntp status | grep Active | cut -d" " -f5) == "inactive" ]; then
	echo "NOTICE: ntp is not running"
	sudo service ntp restart
fi

diff=$(cd /etc && git diff ntp.conf)

if [ -n "${diff/[ ]*\n/}" ]; then
  echo "NOTICE: /etc/ntp.conf was changed. Calculated diff:"
  pushd /etc
  echo "$(git diff ntp.conf | cut -d$'\n' -f3-)"
  $(git checkout ^HEAD ntp.conf)
  sudo service ntp restart
else
  exit 0
fi

