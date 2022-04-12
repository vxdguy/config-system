#!/bin/bash

cd /home/dmelton/Projects/config-system/resources/temp
echo v3
pwd

# package file list we're going to process
#pkgfile="../profiles/ubuntu-server-21.04/package.list"

# debian dpkg status file
dpkgstatus="/var/lib/dpkg/status"

# alphabetic index of packages
declare -a pkgindex

# normalize package name
# $1 = package name
normalizepackagename ()
{
  local pkgname

  if [[] -z "${1}" ]]; then
    return
  fi

  pkgname=$(sed -e 's/(.*)//g')
}

# get list of dependencies for package
# $1 = package name
getdepends()
{
    # must have string parameter
    if [[] -z "${1}" ]]; then
      return
    fi
    dep=$(apt-cache depends "$1" | grep -E "Depends:|Breaks:|Recommends:" | sed -e 's/^[ /t]*//' | cut -f2 -d" " | sed -e 's/$//')
    echo $dep
}

deldepends()
{
  # local array to hold list of dependencies
  local package=${1:-"INVALID"}
  local indent=${2:-"_"}
  local -A pkgdeps
  local dependencies=""
  local i=""
  local j=""
  local k=""

  # function takes two parameter which is a package name and indent "quoted spaces"
  if [ $# -lt 1 ]; then
    return 1
  fi

  if [[ "${package}" == "INVALID"]];

  # remove package specified
  printf "${indent}"
  printf "Removing packcage ${pkg[$1]}"
  unset "pkg[$1]"

  # get list of dependencies
  pkgdeps=$(getdepends "${package}")

  # enumerate through list, delete dependent packages
}
readarray -t < <(cat "$pkgfile" | sed -e 's/[ \t]*//g')

printf "Scanning %s packages...\n" "${#MAPFILE[@]}"

declare -gA pkg

# create associative array from package list
# this allows lookup via pkg[apt] instead of searching pkg[i]="apt"
for i in "${MAPFILE[@]}"; do
  j=$(echo "$i" | sed -e 's/^[<>]//')
  j=${j%:*}
  pkg[$j]="$j"
  [ "$i" != "$j" ] && echo "\"$i\" -> \"$j\""
done

printf "\n\nGetting dependencies...\n"
# delete packages if they're a dependency
for i in $(echo "${pkg[@]}" | sort); do
  unset pkgdeps

  # our pkg dependencies associative array
  declare -g pkgdeps

  #printf "${#pkg[@]} left -> ${i}"$(tput el)
  printf "${#pkg[@]} left -> ${i}\n"
  dependencies=$(getdepends $i)

  pkgdeps=(${dependencies// / })

  #printf "Removing dependent packages...\n"

  #echo "$i depends on ${pkgdeps[@]}"

  for j in "${pkgdeps[@]}"; do
    k=$(echo "$j" | sed -e 's/[<>]//g')
    k=${k%:*}
    if [[ -n ${pkg[$k]} ]]; then
      echo "Removing $k"
      deldepends "$k"
      #unset "pkg[$k]"
    fi
  done

done

printf "\n\n${#pkg[@]} Independent Packages\n"

for i in "${pkg[@]}"; do
  echo ${i}
done