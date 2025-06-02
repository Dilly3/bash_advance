#!/usr/bin/env bash


# This script get name from user and greets the user
# ========================================================
# In this script some command line variables were put to practice
# $# : is used to check the number of argument passed 
# $0 : is used to get the name of the script
# tr : is used to transform provided name to Upper case ( tr 'a-z' 'A-Z' )
# +%H : is used to extract hour from date ( date +%H )

set -e 
set -o pipefail

readonly SCRIPT_NAME=${0##*/}

terminate() {
msg="${1}"
code=${2:-160} 
echo "Error: ${msg} " >&2
exit ${code}
}

usage() {
cat <<EOF
==================================================
${SCRIPT_NAME} script:  greets user with the name provided.
Arguments:
  name: The name of the user to greet, (only contain alphabeths)
Options:
  -h , --help    Displays help message and exits
====================================================

EOF
}

greet() {
echo "Hello $1, $2."
}

[[ $# -ne 1 ]] && ( usage;terminate "you need name of user" 127  )

if [[ ${1} == "-h" || ${1} == "--help" ]]; then
usage
fi
if [[ ! ${1} =~ ^[a-zA-Z]+$ ]]; then
usage
fi

name="$( echo $1 | tr 'a-z' 'A-Z' )"
nowHour=$(date +%H)
if [[ nowHour -gt 12 && nowHour -lt 16 ]] ; then ( greet ${name} "Good Afternoon" )
elif [[ nowHour -gt 16 ]] ; then 
( greet $name "Good Evening" ) 
else 
( greet $name "Good Morning" )
fi

exit 0


