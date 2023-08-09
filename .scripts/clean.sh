#!/bin/bash

#clean the XCode DeriveData
rm -Rf ~/Library/Developer/Xcode/DerivedData

#
rm -r pubspec.lock

#
fvm flutter pub cache clean

#
fvm flutter clean

#
rm -r ios/Podfile.lock

flutter precache --ios

#
rm -rf ios/Pods