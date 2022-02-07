#!/usr/bin/env bash
version=$1
run_bootstrap=$2

echo Installing Melos $version

if [ -x "$(command -v flutter)" ]
then
  flutter pub global activate melos $version
elif [ -x "$(command -v dart)" ]
then
  dart pub global activate melos $version
else
  echo 'Error: Either dart or flutter needs to be on the PATH.' >&2
  exit 1
fi

if [ "$run_bootstrap" != "false" ]
then
  echo Running melos bootstrap
  melos bootstrap
fi
