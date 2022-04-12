#!/bin/bash

# identify who is running
realpath=$(realpath "${BASH_SOURCE[0]}")
indent="    "


echo "Sourced: $realpath"

# library routines go below here

msg ()
{
  echo "${indent}${1}"
}

# associative array has KEY
# $1 = key string to search for
# $2 = associative array
# https://stackoverflow.com/a/68701581/17303633
AAhasKey ()
{
  local -r needle="${1:?}"
  local -nr haystack=${2:?}

  [ -n ${haystack["$needle"]+found} ]
}

# associative array key delete
# $1 = key to delete
# $2 = associative array
AAdelKey ()
{
  [[ ${name[$locale]:-$zz} = "$zz" ]] || unset $2[$1]