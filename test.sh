#!/usr/bin/env bash

columns="$(tput cols)"
welcomeMessage="Welcome to Business Hall!"
tmpfile=$(mktemp)

exec 3>"$tmpfile"
exec 4<"$tmpfile"

print_menu () {
    echo 
    echo "Select one of the following options by typing the respective number: "
    echo "Select business file - - - - - - -(1)"
    echo "Print business data - - - - - - - (2)"
    echo "Update business data field - - - -(3)"
    echo "Print entire file - - - - - - - - (4)"
    echo "Save changes - - - - - - - - - - -(5)"
    echo "Exit - - - - - - - - - - - - - - -(6)"
    echo
}

check_file () {
    if test ! -f "$file"; then
        echo "No file selected. Please select a file first."
        return 0
    else
        return 1
    fi
}

perform_action () {
    case "$1" in

        1)
            # Select business file
            echo "Enter the path to your selected business file"
            read file_location
            if test -f "$file_location"; then
                echo
                echo "File selected!"
                file=$file_location
            else
                echo
                echo "File does not exist. Default file selected"
                file="./Businesses.csv"
            fi
            cp $file $tmpfile
            ;;
        2)
            # Print business data
            check_file
            result=$?
            if test "$result" -eq 1; then
                echo "Enter business code"
                echo
                read business_code
                echo
                awk -F, -v x="$business_code" '$1==x {print}' $tmpfile | column -s "," -t -N ID,BusinessName,Adress,City,PostCode,Longitude,Latitude
                echo
            fi
            ;;
        3)
            # Update business data field
            check_file
            result=$?
            if test "$result" -eq 1; then
                echo hello >&3
            fi
            ;;
        4)
            # Print entire file
            check_file
            result=$?
            if test "$result" -eq 1 ; then 
                echo
                cat $tmpfile | column -s "," -t | more -df
            fi
            ;;
        5)
            # Save changes 
            check_file
            result=$?
            if test "$result" -eq 1; then
                head -n 1 <&4
            fi
            ;;
        6)
            exec 3>&-
            rm "$tmpfile"
            echo
            echo "Thank you for using Business Hall!" 
            ;;
    esac
}

# Main program starts here

# this block prints the welcome message
echo
echo
echo
printf "%*s\n" $(( (${#welcomeMessage} + columns) / 2)) "$welcomeMessage"
echo 
echo 

# main app prompt
input=0
while [ "$input" != "6" ]; do

    print_menu
    read input

    # handle edge case where input is empty string
    if [ -z "$input" ]; then
        input=0
    fi

    echo
    perform_action "$input"

done




