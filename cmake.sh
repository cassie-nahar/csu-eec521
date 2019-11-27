#!/bin/bash
if [ $OS == "Ubuntu" ]; then sudo apt-get --assume-yes purge cmake; fi
if [ $OS == "Red Hat" ]; then sudo yum --assumeyes remove cmake; fi

mkdir --parents $HOME/temp
pushd $HOME/temp
wget https://github.com/Kitware/CMake/releases/download/v3.15.3/cmake-3.15.3.tar.gz
tar -xzvf cmake-3.15.3.tar.gz
cd cmake-3.15.3/
./bootstrap
make -j$(getconf _NPROCESSORS_ONLN)
sudo make install
popd

