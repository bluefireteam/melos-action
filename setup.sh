#!/usr/bin/env bash
version=$1
run_bootstrap=$2

if [ -x "$(command -v flutter)" ]; then
  exec=flutter
elif [ -x "$(command -v dart)" ]; then
  exec=dart
else
  echo 'Error: Either dart or flutter needs to be on the PATH.' >&2
  exit 1
fi

echo Installing Melos $version via $exec

$exec pub global activate melos $version

if [ "$run_bootstrap" != "false" ]; then
  echo 'Running melos bootstrap...'
  $exec pub global run melos bootstrap
fi
