#!/bin/bash

#
# get repository keys
#

# identify who is running
realpath=$(realpath "${BASH_SOURCE[0]}")
echo "Running: $realpath"

# source helper library
. "${DIR_LIBRARY}"

# what are we trying to do
msg "Saving repository keys..."

# step 1 - export trusted.gpg
msg "1/2 - exporting apt-keys (trusted.gpg)"
apt-key export > "${DIR_SAVECONFIG}"/apt-keys.txt
if [ $? -ne 0 ]; then
  msg "Error exporting apt keys (apt-key export)"
  exit 1
fi
