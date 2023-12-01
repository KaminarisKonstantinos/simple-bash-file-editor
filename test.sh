#################################################################
# 236064 1041756 Kaminaris Konstantinos
#################################################################

# Business Hall
# business data file manipulation
# basic file manipulation program that makes changes to a temporary file ($TMPFILE) before saving to the original ($FILE) 

#!/usr/bin/env bash

COLUMNS="$(tput cols)"
WELCOME_MESSAGE="Welcome to Business Hall!"
TMPFILE=$(mktemp)
FILE="./businesses.csv"

# make file descriptors even though they are not used, to make sure that $TMPFILE gets destroyed if the program happens to crash
exec 3>"$TMPFILE"
exec 4<"$TMPFILE"

print_menu () {
    echo 
    echo "Select business file - - - - - - -(1)"
    echo "Print business data - - - - - - - (2)"
    echo "Update business data field - - - -(3)"
    echo "Print entire file - - - - - - - - (4)"
    echo "Save changes - - - - - - - - - - -(5)"
    echo "Exit - - - - - - - - - - - - - - -(6)"
    echo
    echo -n "Select one of the options above by typing the respective number: "
}

select_file () {
    echo -n "Enter the path to your selected business file: "
    read FILE_LOCATION
    if test -f "$FILE_LOCATION"; then
        echo
        echo "File selected!"
        FILE=$FILE_LOCATION
    else
        echo
        echo "File does not exist. Default file selected."
        FILE="./businesses.csv"
    fi
    # copy the original file to our temporary one
    cp $FILE $TMPFILE
}

print_business_data () {
    echo -n "Enter business id: "
    read BUSINESS_ID
    echo
    # check if business id exists
    awk -F"," -v x="$BUSINESS_ID" '$1==x {print}' $TMPFILE > tmp
    if [[ -s tmp ]]; then
        awk_on_screen
    else
        echo "Business ID not found."
    fi
    rm -f tmp
    echo
}

# print the business data in table format
awk_on_screen () {
    awk -F"," -v x="$BUSINESS_ID" '$1==x {print}' $TMPFILE | column -s "," -t -N ID,BusinessName,Adress,City,PostCode,Longitude,Latitude
}

update_data () {
    echo -n "Enter business id: "
    read BUSINESS_ID
    echo
    # check if business id exists
    awk -F"," -v x="$BUSINESS_ID" '$1==x {print}' $TMPFILE > tmp
    if [[ -s tmp ]]; then
        change_field
    else
        echo "Business id not found."
    fi
    rm -f tmp
    echo
}

change_field () {
    ask_for_field_index
    if [[ "$FIELD_INDEX" = [1-7] ]]; then
        echo -n "Enter new field value: "
        read FIELD_VALUE
        echo
        read -p "Are you sure you want to change the value to $FIELD_VALUE? (y/n): " -n 1
        echo
        echo
        if [[ "$REPLY" =~ [yY] ]]; then
            echo "Old data:"
            echo
            awk_on_screen
            echo
            # Make the change on tmpfile, not original file
            awk -v x="$BUSINESS_ID" -v y="$FIELD_INDEX" -v z="$FIELD_VALUE" 'BEGIN {FS=OFS=","} $1==x {$y=z} 1' $TMPFILE > tmp && mv tmp $TMPFILE
            echo "New data:"
            echo
            awk_on_screen
            echo
            echo "Update successful!"
        else
            echo "Update canceled."
        fi
    else
        echo "Invalid selection."
    fi
}

ask_for_field_index () {
    echo
    echo "ID (1)"
    echo "Name (2)"
    echo "Adress (3)"
    echo "City (4)"
    echo "PostCode (5)"
    echo "Longitude (6)"
    echo "Latitude (7)"
    echo
    read -p "Select the field you would like to change by entering its respective number (1-7): " -n 1 FIELD_INDEX
    echo
}

print_entire_file () {
    echo
    cat $TMPFILE | column -s"," -t | more -df
}

save_changes () {
    read -p "Are you sure to want to save the changes to $FILE? (y/n): " -n 1
    echo
    echo
    if [[ "$REPLY" =~ [yY] ]]; then
        cp $TMPFILE $FILE
        echo "Changes saved to $FILE!"
    else
        echo "Changes not saved."
    fi
}

quit () {
    echo
    read -p "Exit Business Hall? (y/n) :" -n 1
    echo
    if [[ "$REPLY" =~ [yY] ]]; then
        exec 3>&-
        rm "$TMPFILE"
        echo
        echo "Thank you for using Business Hall!" 
    else
        echo
        INPUT=0
    fi
}

perform_action () {
    case "$1" in

        1)
            select_file
            ;;
        2)
            print_business_data
            ;;
        3)
            update_data
            ;;
        4)
            print_entire_file
            ;;
        5)
            save_changes
            ;;
        6)
            quit
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

cp $FILE $TMPFILE

# main app prompt
INPUT=0
while [ "$INPUT" != "6" ]; do

    echo -n "Press <ENTER> to continue..."
    read

    print_menu
    read -n 1 INPUT

    echo
    perform_action "$INPUT"

done
