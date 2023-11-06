#!/usr/bin/env bash

version=$1
run_bootstrap=$2

echo "Installing Melos $version..."

dart pub global activate melos $version

if [ "$run_bootstrap" != "false" ]; then
  echo 'Running melos bootstrap...'
  dart pub global run melos bootstrap
fi

if ! [ -x "$(command -v melos)" ]; then
  echo "$HOME/.pub-cache/bin" >> $GITHUB_PATH
  echo 'Added Melos to PATH.'
fi
