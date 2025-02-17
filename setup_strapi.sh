# To Connect to the new server
# ssh -i /path/to/public/key -L 1337:host_name_of_remote_server:1337
#
# Defaults
project_name="testapi"
install_dir=/var/www/
#

#
# Notes about pm2 - the background runner of the app
#                          Runtime Edition
#
#PM2 is a Production Process Manager for Node.js applications
#             with a built-in Load Balancer.
#
#    Start and Daemonize any application:
#    $ pm2 start app.js
#
#    Load Balance 4 instances of api.js:
#    $ pm2 start api.js -i 4
#
#    Monitor in production:
#    $ pm2 monitor
#
#    Make pm2 auto-boot at server restart:
#    $ pm2 startup
#
#    Stop the application
#    $ pm2 delete 0
#
#    To go further checkout:
#    http://pm2.io/
#
#

function develop {
    cd ${install_dir}/${project_name}
    apt update
    apt-get install -y nodejs=14.14.0-1nodesource1
    apt-get install -y mongodb
    apt install -y npm npx
    npm install -y yarn
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt update && sudo apt install yarn
    echo "yarn version-------------------------------------------------"
    yarn --version
    echo "-------------------------------------------------"
    npm cache clean -f
    m install -g n
    npm install -g n
    n stable
    echo "nodejs version-------------------------------------------------"
    nodejs --version
    echo "-------------------------------------------------"
    apt-get install -y gcc g++ make
    apt-get -y install yarni
    curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
    npm install pm2 -g
    
    echo "create stratpi-app-------------------------------------------------"
    yarn create strapi-app ${project_name}
    cd ${project_name}
    touch alexis
    echo "-------------------------------------------------"
}

function production {   
    if [[ `echo ${mode} | grep -i prod -c` -gt 0 ]]; then
        cd /var/www/${project_name}
        pm2 --name ${project_name} start npm -- start
    elif [[ `echo ${mode} | grep -i stop -c` -gt 0 ]]; then
        cd /var/www/${project_name}
        pm2 delete 0
    else
        cd /var/www/${project_name}/ && yarn --watch-admin

        #
        # this will keep the server log open in this window
        #
        yarn develop --watch-admin
        yarn build
        yarn generate:api --plugin content-manager ${project_name}
        yarn generate:controller --api ${project_name}
        yarn generate:model ${project_name} --api ${project_name}
        yarn generate:service ${project_name} --api {$project_name}
        yarn console
        yarn develop
    fi
} 

if [ -z $1 ]; then
    develop
else
    production
fi
