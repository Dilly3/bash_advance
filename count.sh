#!/usr/bin/env bash

# set -e options allows your script to fail immediately if and command fails
set -e
# set -o pipefail  makes error detection within pipes more reliable
set -o pipefail

counter=1
tmpfile="/tmp/$$.tmp"

echo $counter > "${tmpfile}"

( 
 counter="$(cat $tmpfile)"
(( counter++ ))
 echo "${counter}" > ${tmpfile}
 )

 counter=$(cat "$tmpfile") 
 echo "Counter: ${counter}"

# unlink remves a single file by deleting its directory link
unlink "${tmpfile}"

# check if file exist
[[ -f "${tmpfile}" ]] || (echo "file deleted")

exit 0
