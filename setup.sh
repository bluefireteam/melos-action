#!/usr/bin/env bash -e

version=$1
run_bootstrap=$2

echo "Installing Melos $version..."

dart pub global activate melos $version

if [ "$run_bootstrap" != "false" ]; then
  echo 'Running melos bootstrap...'
  dart pub global run melos bootstrap
fi
