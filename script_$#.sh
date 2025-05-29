#!/usr/bin/env bash

# The $# shell variable is used to get the number of passed in argument in a shell function or shell script

set -e 
set -o pipefail 

terminate() {
local -r msg="${1}"
local -r code=${2:-130}

echo "Error: ${msg}"
exit ${code}
}

[[ $# -gt 0 ]] || (terminate "enter steps" 127 ) 

readonly CALORIES_PER_STEP=0.04
calories=${1}

burnt=$(echo "$calories * $CALORIES_PER_STEP" | bc )
 echo "Calories Burned: ${burnt}"
exit 0
