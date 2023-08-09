#!/bin/bash

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -fv|--flutter-version) flutter_version="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

if ! hash brew 2>/dev/null; then
  echo "Brew is not installed. Installing"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if ! hash pod 2>/dev/null; then
  echo "Cocoapods is not installed. Installing"
  sudo gem install cocoapods
  pod setup
fi

if ! hash mason 2>/dev/null; then
  echo "Mason is not installed. Installing"
  brew tap felangel/mason
  brew install mason
fi

if ! hash dart 2>/dev/null; then
  echo "Dart is not installed. Installing"

  export PATH="$PATH":"$HOME/.pub-cache/bin"
  echo "export PATH=\"\$PATH\":\"\$HOME/.pub-cache/bin\"" >> ~/.zshrc

  brew tap dart-lang/dart
  brew install dart
  pub global activate fvm
  fvm use $flutter_version --force
  fvm install
  fvm flutter doctor --android-licenses
  sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
  sudo xcodebuild -runFirstLaunch
else 
  pub global activate fvm
  fvm use $flutter_version --force
  fvm install
fi

fvm flutter precache

fvm flutter pub upgrade
cd ios && pod repo update && pod install && cd ..