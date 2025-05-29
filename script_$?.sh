#!/usr/bin/env bash

set -e 
set -o pipefail

# terminate function exits the script with an error code when there is error
terminate() {
local -r msg="${1}"
local -r code="${2:-130}"
echo "Error: $msg" >&2
exit ${code}
}

readonly FILE_CONV="./fqdn.ppt"
user=$(whoami)
readonly servers="server1,server2,server3"

IFS=', :'

 
[[ -s ${FILE_CONV} ]] || ( 
readonly errMsg="create the file and add a domain eg 'freedom.com' ";
terminate "${FILE_CONV} file is empty; ${errMsg}" 127
 )

readonly domain=$(cat ${FILE_CONV})

for server in $servers; do 
echo "${user}@${server}.${domain}"
done

exit 0
