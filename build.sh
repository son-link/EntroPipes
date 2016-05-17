#!/bin/bash

# Script for build the executables for Windows and APK for Android
echo 'Building Winows executables'
for f in $(cat < files2zip); do
	cp ${f} -r releases/files/
done
pushd releases/files/
love-release -W 32 -u 'https://github.com/son-link/EntroPipes' -a "Alfonso Saavedra 'Son Link'" -d 'EntroPipes is a puzzle type game. Simply connect all pipes' -p 'EntroPipes' -e 'sonlink.dourden@gmail.com' -v 'Beta 2'
love-release -W 64 -u 'https://github.com/son-link/EntroPipes' -a "Alfonso Saavedra 'Son Link'" -d 'EntroPipes is a puzzle type game. Simply connect all pipes' -p 'EntroPipes' -e 'sonlink.dourden@gmail.com' -v 'Beta 2'
popd

echo 'Building Android'
zip -r  releases/love-android-0.10.1/assets/game.love -@ < files2zip
pushd releases/love-android-0.10.1/
#ant debug
ant release
popd
echo 'Build done'
