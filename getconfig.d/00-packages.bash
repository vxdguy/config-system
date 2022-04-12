#!/bin/bash

#
# get a list of installed packages
#

# identify who is running
realpath=$(realpath "${BASH_SOURCE[0]}")
echo "Running: $realpath"

# source helper library
. "${DIR_LIBRARY}/helper.bash"

# what are we trying to do
msg "Saving list of installed packages..."

# step 1 - get raw package list, filter for "ii" which indicates installation
msg "1/5 - getting list from dpkg, grepping list for installed packages."
dpkg -l | grep ^ii > "${DIR_TEMPDIR}"/dpkg.raw.dump
if [ $? -ne 0 ]; then
  msg "Error getting list of installed packages (dpkg -l | grep ^ii)"
  exit 1
fi

# step 2 - get rid of multiple spaces
msg "2/5 - reducing spaces (via tr) to make filtering easier."
cat  "${DIR_TEMPDIR}"/dpkg.raw.dump | tr -s " " > "${DIR_TEMPDIR}"/tr.raw.dump
if [ $? -ne 0 ]; then
  msg "Error getting list of installed packages (tr)"
  exit 2
fi
rm "${DIR_TEMPDIR}"/dpkg.raw.dump

# step 3 - get 2nd field which is the package name
msg "3/5 - cutting to get installed package names"
cut -d" " -f2 "${DIR_TEMPDIR}"/tr.raw.dump > "${DIR_TEMPDIR}"/cut.raw.dump
if [ $? -ne 0 ]; then
  msg "Error getting list of installed packages (cut)"
  exit 3
fi
rm "${DIR_TEMPDIR}"/tr.raw.dump

# step 4 - remove package.list line entries from list of installed packages
msg "4/5 - removing default packages (assuming default desktop install)"
cat "${DIR_TEMPDIR}/cut.raw.dump" | grep -v -x -F --file="${DIR_RESOURCES}/packages.list" > "${DIR_TEMPDIR}"/diffpackages.raw.dump
if [ $? -ne 0 ]; then
  msg "Error getting list of installed packages (grep -F --file)"
  exit 4
fi
rm "${DIR_TEMPDIR}"/cut.raw.dump

msg "5/5 - removing kernel packages"
grep -v "^linux-" "${DIR_TEMPDIR}"/diffpackages.raw.dump > "${DIR_SAVECONFIG}"/installed-packages.txt
if [ $? -ne 0 ]; then
  msg "Error getting list of installed packages (grep -v 'linux-')"
  exit 5
fi

rm "${DIR_TEMPDIR}"/diffpackages.raw.dump

msg "Package list saved to: ""${DIR_SAVECONFIG}"/installed-packages.txt
exit 0
