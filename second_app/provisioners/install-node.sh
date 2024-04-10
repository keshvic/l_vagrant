#!/bin/bash

# installs NVM (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# download and install Node.js
nvm install 20

# verifies the right Node.js version is in the environment
node -v # should print `v20.12.1`

# verifies the right NPM version is in the environment
npm -v # should print `10.5.0`

#install PM2 to support NodeJS application run-as-service
npm install -g pm2
#start TodoList app as a service
cd /vagrant
npm install --no-bin-links        #restore application dependencies
# fix vulnerabilities
npm audit fix --force
pm2 start ecosystem.config.js     #start the application with PM2
pm2 save                          #save the current config for restarts
pm2 startup                       #enable PM2 startup system
#add PM2 configuration to systemd to restart application on reboot
#sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u vagrant --hp /home/vagrant
sudo env PATH=$PATH:/home/vagrant/.nvm/versions/node/v20.12.1/bin /home/vagrant/.nvm/versions/node/v20.12.1/lib/node_modules/pm2/bin/pm2 startup systemd -u vagrant --hp /home/vagrant
#wait for service start
while ! nc -z localhost 3000; do   
  sleep 0.1 # wait for 1/10 of the second before the next check
done
#seed tasks
curl -X POST \
  http://localhost:3000/tasks \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'Postman-Token: 02a2e24a-5e6e-7612-82a1-0e3d3338eb2c' \
  -d name=Finish%20Vagrant%20Videos