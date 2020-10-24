#
project_name=testapi
#


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
apt-get install --reinstall nodejs-legacy
echo "nodejs version-------------------------------------------------"
nodejs --version
echo "-------------------------------------------------"
apt-get install -y gcc g++ make
apt-get -y install yarni
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
echo "create stratpi-app-------------------------------------------------"
yarn create strapi-app ${project_name}
cd ${project_name}
echo "-------------------------------------------------"
yarn develop
