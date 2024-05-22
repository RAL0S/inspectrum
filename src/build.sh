#!/bin/sh

set -e
apt-get update -y
wget https://github.com/QuasarApp/CQtDeployer/releases/download/v1.5.4.17/CQtDeployer_1.5.4.17_Linux_x86_64.deb
apt-get install ./CQtDeployer_1.5.4.17_Linux_x86_64.deb
rm CQtDeployer_1.5.4.17_Linux_x86_64.deb
apt-get install qt5-default libfftw3-dev cmake pkg-config libliquid-dev build-essential git --yes
git clone https://github.com/miek/inspectrum.git
cd inspectrum/
commit_hash=$(git rev-parse HEAD | cut -c 1-8)
mkdir build
cd build/
cmake ..
make

cd src
cqtdeployer deploySystem -bin inspectrum
cd DistributionKit
sed -i '/export LD_LIBRARY_PATH=/c export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:"$BASE_DIR"/lib/:"$BASE_DIR"/lib/systemLibs:"$BASE_DIR"' inspectrum.sh
rm lib/systemLibs/libstdc++.so.6
rm lib/systemLibs/libpthread.so.0
rm lib/systemLibs/libfontconfig.so.1
chmod +x inspectrum.sh
chmod +x bin/inspectrum
tar czf ../../../../inspectrum-$commit_hash.tar.gz *
cd ../../../../