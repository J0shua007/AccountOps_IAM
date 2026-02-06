#!/bin/bash


while true; do
file="data.csv"
line=0
Usernames=()
Passwords=()
Groups=()
LogDir="/home/kali/Documents/Project_2/"


exec > >(tee -a "${LogDir}AccountOps_$(date +'%Y%m%d').log") 2>&1

# Functions Sections :

# check the Password is Empty
function check_password_empty() {
    local name=$1
    local password=$2
    if [[ $password == "" ]]; then
        echo  -e "\033[31m[ CRITICAL ] Password is Empty for user :\033[0m ${name}"
        echo -e  "\033[32m[ HEAL ] Please Add password in csv file\033[0m"
        
    else
        echo -e "\033[32m[ OK ] Password is found for user:\033[0m ${name}"
    fi
}
        # Check the Group name is Empty
function check_group_empty() {
    local name=$1
    local group=$2

    if [[ $group == ""  ]]; then
        echo  -e "\033[33m[ WARN ] Group name is Empty for user: \033[0m ${name}"
        echo -e  "\033[32m[ HEAL ] Please Add Group name in csv file \033[0m "
        echo "-----------------------------------------------------"
    else
        echo -e "\033[32m[ OK ] Group name are found for user:\033[0m ${name}"
        echo "-----------------------------------------------------"
    fi
}

function create_users_csv() {
    for i in "${!Usernames[@]}"; do
        username="${Usernames[$i]}"
        password="${Passwords[$i]}"
        group="${Groups[$i]}"

        # Check if user already exists
        if id "$username" &>/dev/null; then
            echo -e "\033[33m[ WARN ] User $username already exists. Skipping creation.\033[0m"
            sleep 1
        else
            # Create user with specified group and set password
            useradd -m -G "$group" -s /bin/bash "$username"
            echo "$username:$password" | chpasswd
            chown -R "$username:$username" "/home/$username"
            chmod 700 "/home/$username"

            echo -e "\033[32m[ OK ] User $username created and added to group $group.\033[0m"
            sleep 1
        fi
    done
}

function create_users_read() {
    # Check if user already exists
     read -p "Enter username to create: " username
     read -p "Enter password for $username: " password
    if id "$username" &>/dev/null; then
        echo -e "\033[33m[ WARN ] User $username already exists. Skipping creation.\033[0m"
        sleep 1
    else
        # Create user and add to sudo group, set password
        useradd -m -G sudo -s /bin/bash "$username"
        echo "$username:$password" | chpasswd
        chown -R "$username:$username" "/home/$username"
        chmod 700 "/home/$username"
        echo -e "\033[32m[ OK ] User $username created with sudo access.\033[0m"
        sleep 1
    fi
}
function delete_user() {
    read -p "Are you sure you want to delete users? (yes/no): " confirm
    if [[ $confirm == "yes" ]]; then
        read -p "Enter the User to Delete: " user_to_delete
        if id "$user_to_delete" &>/dev/null; then
            userdel -r "$user_to_delete"
            echo -e "\033[32m[ OK ] User $user_to_delete deleted successfully.\033[0m"
        else
            echo -e "\033[31m[ ERROR ] User $user_to_delete does not exist.\033[0m"
        fi
    else
        echo -e "\033[31m[ ERROR ] Operation cancelled.\033[0m"
    fi
}

function list_sudo_users() {
    echo "Sudo Users:"
    getent group sudo | awk -F: '{print $4}' | tr ',' '\n'
}

function list_users_by_group() {
    read -p "Enter the group name: " group_name
    echo "Users in group $group_name:"
    getent group "$group_name" | awk -F: '{print $4}' | tr ',' '\n'
}

function dry_run() {
    echo "Dry-run mode: No changes will be applied."
    for i in "${!Usernames[@]}"; do
        echo -e "\033[32m[ DRY-RUN ] Would create user: ${Usernames[$i]} with group: ${Groups[$i]}\033[0m"
    done
}
function add_user_to_group() {
    read -p "Enter username to add to group: " username
    read -p "Enter group to add user to: " groupname
    usermod -aG "$groupname" "$username"
    echo -e "\033[32m[ OK ] User $username added to group $groupname.\033[0m"
}

function remove_user_from_group() {
    read -p "Enter username to remove from group: " username
    read -p "Enter group to remove user from: " groupname
    gpasswd -d "$username" "$groupname"
    echo -e "\033[32m[ OK ] User $username removed from group $groupname.\033[0m"
}

function change_user_password() {
    read -p "Enter username to change password: " username
    read -p "Enter new password for $username: " newpassword
    echo "$username:$newpassword" | chpasswd
    echo -e "\033[32m[ OK ] Password for user $username changed successfully.\033[0m"
}

function lock_unlock_user() {
    read -p "Enter username to lock/unlock: " username
    read -p "Type 'lock' to lock or 'unlock' to unlock the user: " action
    if [[ $action == "lock" ]]; then
        usermod -L "$username"
        echo -e "\033[31m[ OK ] User $username has been locked.\033[0m"
    elif [[ $action == "unlock" ]]; then
        usermod -U "$username"
        echo -e "\033[32m[ OK ] User $username has been unlocked.\033[0m"
    else
        echo -e "\033[31m[ ERROR ] Please type 'lock' or 'unlock'.\033[0m"
    fi
}

if [[ $EUID -ne 0 ]]; then
        echo "Login as a Root User" >&2
        exit 1
else

    while IFS=',' read name password group; do

        line=$((line+1))

        # Checking First line and leave it

        if [ $line -eq 1 ]; then
                continue
        else
                Usernames+=("$name")
                Passwords+=("$password")
                Groups+=("$group")
        fi    
    done < "$file"
    sleep 2

    echo " 1 : Prechecks (CSV validation, empty fields, duplicates)"
    echo " 2 : Create users based on CSV file"
    echo " 3 : Create users with sudo access"
    echo " 4 : Add users to groups"
    echo " 5 : Remove users from groups"
    echo " 6 : Change user passwords"
    echo " 7 : Lock / Unlock users"
    echo " 8 : Delete users"
    echo " 9 : List sudo users"
    echo "10 : List users by group"
    echo "11 : Dry-run (show actions without executing)"
    echo "12 : Exit"

        echo  -e "\n"
        echo "-----------------------------------------------------"
        read  -p  "Enter your choice : " choice
        echo "-----------------------------------------------------"
        sleep 1

        case $choice in

            1)
    echo -e "\nPrechecks Selected:\n"
    for i in "${!Usernames[@]}"; do
        check_password_empty "${Usernames[$i]}" "${Passwords[$i]}"
        sleep 1
        check_group_empty "${Usernames[$i]}" "${Groups[$i]}"
        sleep 1
    done 
    ;;

2)
    echo "Create Users based on CSV file selected"
    create_users_csv 
    ;;

3)
    echo "Create Users with Sudo Access Selected"
    create_users_read
    ;;

4)
    echo "Add Users to Groups Selected"
    add_user_to_group
    ;;

5)
    echo "Remove Users from Groups Selected"
    remove_user_from_group
    ;;

6)
    echo "Change User Passwords Selected"
    change_user_password
    ;;

7)
    echo "Lock / Unlock Users Selected"
    lock_unlock_user
    ;;

8)
    echo "Delete Users Selected"
    delete_user
    ;;

9)
    echo "List Sudo Users Selected"
    list_sudo_users
    ;;

10)
    echo "List Users by Group Selected"
    list_users_by_group
    ;;

11)
    echo "Dry-run Selected (No changes will be applied)"
    dry_run
    ;;

12)
    echo "Exit Selected"
    exit 0
    ;;

*)
    echo "Invalid choice!"
    echo "Please select a valid option from the menu."
    ;;

esac
fi
done