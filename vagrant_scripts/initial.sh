#!/usr/bin/env bash

# resolve "stdin: is not a tty warning", related issue and proposed fix: https://github.com/mitchellh/vagrant/issues/1673
sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile


function install_node {
  echo "-----> Install nodejs"
  command -v nodejs > /dev/null
  if [[ $? -eq 0 ]]; then
    echo "nodejs already installed"
    return
  fi

  sudo apt-get update
  if [[ $? -ne 0 ]]; then
    echo "failed to update apt"
    exit 1
  fi

  sudo apt-get install -qqy python-software-properties
  if [[ $? -ne 0 ]]; then
    echo "failed to install package python-software-properties"
    exit 1
  fi
  sudo add-apt-repository ppa:chris-lea/node.js
  sudo apt-get update
  sudo apt-get install -qqy nodejs
  sudo npm install -g --silent npm
}

function npm_install {
  echo "-----> installing npm modules"
  cd /vagrant/vagrant_scripts && npm install
}

install_node
npm_install
