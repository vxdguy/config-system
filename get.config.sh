#!/bin/bash

DEBUG=true

# Default settings
#   script file
#     ./resources/*
#     ./resources/libscripts/*
#     ./getconfig.d/*
#     ./setconfig.d/*
#     ./saved-config-<date>-<time>.d

clear

realpath=$(realpath "${BASH_SOURCE[0]}")
[ -z ${DEBUG} ] && echo "Running $realpath"

DIR_ROOTDIR=$(dirname "${realpath}")
export DIR_RESOURCES=${DIR_ROOTDIR}/resources
export DIR_LIBRARY=${DIR_RESOURCES}/libscripts
export DIR_TEMPDIR=${DIR_RESOURCES}/temp
export DIR_GETSCRIPTS=${DIR_ROOTDIR}/getconfig.d
export DIR_SETSCRIPTS=${DIR_ROOTDIR}/setconfig.d
export DIR_SAVECONFIG=${DIR_ROOTDIR}/saved-config-$(date +%Y%m%d)-$(date +%H%M%S).d

# clean up temp directory. ignore errors
rm -rf "${DIR_TEMPDIR}" &> /dev/null
# temp dir must exist
mkdir "${DIR_TEMPDIR}" &> /dev/null
if [ $? -ne 0 ]; then
  echo "ERROR:  Unable to make temp directory"
  echo '  mkdir '"${DIR_TEMPDIR}"
fi

mkdir "${DIR_SAVECONFIG}"

echo DIR_GETSCRIPTS="${DIR_GETSCRIPTS}"
run-parts --regex="\.bash$" "${DIR_GETSCRIPTS}"
