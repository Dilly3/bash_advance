#

#!/usr/bin/env bash

set -e 
set -o pipefail 
set -u

work_dir=$(dirname "$(readlink -f "${0}")")
food_options_file=${work_dir}/"food_options.txt"
user=${1}

# initialize array
declare -a lunch_options=()
declare -A food_stock=()
terminate() {
msg="Error: $1"
code="${2:-130}"
printf '%s\n' "${msg}" >&2
exit ${code}
}

printColor() {
text=$1
color=$2 
printf "\e[1;${color}m%s\e[0m\n" "${text}"
}
 
welcome() {
echo "Welcome to Food Park"
echo "==============================="
printf "%s\n" "enter your name:"
read name
printf "%s\n\n" "Welcome ${name^^}"

}

instruction() {
echo "Welcome to Food Park StoreKeep"
echo "==============================="
echo "Enter the food Item and Quantity available"
echo "Example: 'jollof rice' 3 " 
printf "%s\n\n"  "========================="
}

if [[ $# -lt 1 ]]; then 
terminate 'enter user argument ("admin" or "customer")' "127" 
fi

loadFoodOptions() {
# function load food options:
# - get input from user
# - checks if food_options_file exist and create it 
# - add the input(list of food) to food_options_file  
 
count=1
printf '%s\n' "Enter Food Options. To exit enter end"
while true; do
# read input from user
read -p "Food number ${count}:" food qty
# Check food and qty is present
if [[ ! -z ${food} && -z ${qty} ]]; then
instruction
exit 127
fi
if [[ $( echo "${food}" | tr 'a-z' 'A-Z' ) == "END" ]]; then
break
fi
# check if input start with atleast 3 alphabeth 
if [[ ! "${food}" =~ ^[a-zA-Z]{3,}* ]]; then
 (
terminate "food must start with atleast 3 aphabeth" "127"
)
fi

# add food to array
for (( i = 0 ; i < ${qty} ; i++ )); do
lunch_options[${#lunch_options[@]}]="${food}"
done
# add count
(( count++ ))

# repeat while loop
done

# persist array by saving in a file
# check if file exist if not create file

[[  -f "${food_options_file}" ]] || ( 
	cd $work_dir; 
	touch  "${food_options_file##*/}"
chmod 755 "$food_options_file"
	 ) 

# if file exist save array to file
printf '%s\n' "${lunch_options[@]}" >> "${food_options_file}"

# set array to empty
lunch_options=()

}

getRandom() {
mapfile -t lunch_options < "${food_options_file}"
if [[ ${#lunch_options[@]} -gt 0 ]]; then 
random_index=$(( RANDOM % ${#lunch_options[@]} ))
food_choice=${lunch_options[$random_index]}
printColor "Your Food Choice Today is: ${food_choice^^}" "33"
# remove selected food from list
unset lunch_options[${random_index}] 

# check if food options length is zero
if [ "${#lunch_options[@]}" -lt 1 ]; then
# null file 
: >  "${food_options_file}" 
else
# persist food options
printf '%s\n' "${lunch_options[@]}" > "${food_options_file}"
fi

else
printColor "We are out of food" "42"
fi
}

welcome
if [[ $( echo "${user}" | tr 'a-z' 'A-Z' ) == "ADMIN" ]]; then
instruction
 loadFoodOptions
exit 0
elif [[ $( echo "${user}" | tr 'a-z' 'A-Z' ) == "CUSTOMER" ]]; then
getRandom
fi 

exit 0
