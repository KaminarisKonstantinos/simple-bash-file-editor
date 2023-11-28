#!/usr/bin/env bash

columns="$(tput cols)"
welcomeMessage="Welcome to Business Hall!"

echo
echo
echo
printf "%*s\n" $(( (${#welcomeMessage} + columns) / 2)) "$welcomeMessage"
echo 
echo 
echo 

echo "Please select one of the following options by typing the respective number: "
echo "Select business file - - - - - - -(1)"
echo "Print business data - - - - - - - (2)"
echo "Update business data field - - - -(3)"
echo "Print entire file - - - - - - - - (4)"
echo "Save changes - - - - - - - - - - -(5)"
echo "Exit - - - - - - - - - - - - - - -(6)"

read input
echo $input




