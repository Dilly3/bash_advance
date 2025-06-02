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

instructions() {
echo "=============== CALORIE CALCULATOR =============="
read -p  "ENTER NUMBER OF STEPS: " steps
}

instructions
if [ -z "${steps}" ]; then (terminate "enter steps" 127 ) fi 

readonly CALORIES_PER_STEP=0.04

burnt=$(echo "$steps * $CALORIES_PER_STEP" | bc )
 echo "Calories Burnt: ${burnt}"
exit 0
