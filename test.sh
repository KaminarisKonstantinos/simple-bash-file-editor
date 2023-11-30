#!/usr/bin/env bash

COLUMNS="$(tput cols)"
WELCOME_MESSAGE="Welcome to Business Hall!"
TMPFILE=$(mktemp)

exec 3>"$TMPFILE"
exec 4<"$TMPFILE"

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
    if test ! -f "$FILE"; then
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
            read FILE_LOCATION
            if test -f "$FILE_LOCATION"; then
                echo
                echo "File selected!"
                FILE=$FILE_LOCATION
            else
                echo
                echo "File does not exist. Default file selected"
                FILE="./Businesses.csv"
            fi
            cp $FILE $TMPFILE
            ;;
        2)
            # Print business data
            check_file
            RESULT=$?
            if test "$RESULT" -eq 1; then
                echo "Enter business code"
                echo
                read BUSINESS_CODE
                echo
                awk -F"," -v x="$BUSINESS_CODE" '$1==x {print}' $TMPFILE | column -s "," -t -N ID,BusinessName,Adress,City,PostCode,Longitude,Latitude
                echo
            fi
            ;;
        3)
            # Update business data field
            check_file
            RESULT=$?
            if test "$RESULT" -eq 1; then
                echo "Enter business code"
                echo
                read BUSINESS_CODE
                echo
                echo "Old data"
                echo
                awk -F"," -v x="$BUSINESS_CODE" '$1==x {print}' $TMPFILE | column -s "," -t -N ID,BusinessName,Adress,City,PostCode,Longitude,Latitude
                echo
                awk -v x="$BUSINESS_CODE" 'BEGIN {FS=OFS=","} $1==x {$2="Starbucks"} 1' $TMPFILE > tmp && mv tmp $TMPFILE
                echo "New data"
                echo
                awk -F"," -v x="$BUSINESS_CODE" '$1==x {print}' $TMPFILE | column -s "," -t -N ID,BusinessName,Adress,City,PostCode,Longitude,Latitude
                echo
            fi
            ;;
        4)
            # Print entire file
            check_file
            RESULT=$?
            if test "$RESULT" -eq 1 ; then 
                echo
                cat $TMPFILE | column -s"," -t | more -df
            fi
            ;;
        5)
            # Save changes 
            check_file
            RESULT=$?
            if test "$RESULT" -eq 1; then
                echo -n "Are you sure to want to save the changes? (y,n)"
                read INPUT1
                if [[ "$INPUT1" =~ [yY] ]]; then
                    cp $TMPFILE $FILE
                    echo "Changes saved in $FILE."
                else
                    echo "Changes not saved."
                fi
            fi
            ;;
        6)
            exec 3>&-
            rm "$TMPFILE"
            echo
            echo "Thank you for using Business Hall!" 
            ;;
        "")
            ;;
        *)
            echo "Invalid input."
            ;;
    esac
}

# Main program starts here

# this block prints the welcome message
echo
echo
echo
printf "%*s\n" $(( (${#WELCOME_MESSAGE} + COLUMNS) / 2)) "$WELCOME_MESSAGE"
echo 
echo 
echo -n "Press <ENTER> to continue..."

# main app prompt
INPUT=0
while [ "$INPUT" != "6" ]; do

    if [[ $INPUT = [1-5] ]]; then
        echo -n "Press <ENTER> to continue..."
    fi
    read

    print_menu
    read INPUT

    echo
    perform_action "$INPUT"

done
