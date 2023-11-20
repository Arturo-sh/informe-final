#!/bin/env bash

# Colors
red='\e[1;31m'
green='\e[1;32m'
yellow='\e[1;33m'
blue='\e[1;34m'
purple='\e[1;35m'
cyan='\e[1;36m'
reset='\e[0m'

# Boxes for the messages
box1=$(echo -e ${green}[${reset}${green}*${reset}${green}]${reset})
box2=$(echo -e ${green}[${reset}${blue}*${reset}${green}]${reset})
box3=$(echo -e ${green}[${reset}${red}*${reset}${green}]${reset})
box4=$(echo -e ${green}[${reset}${purple}*${reset}${green}]${reset})

# Move to the repository path
cd /c/xampp/htdocs/informe-final/

# Function to terminate the script
function handleCommitStatus() {
    case "${1}" in
        "0")
            echo -e "\v\t${box1} ${green}Commit successfully applied${reset}"
            ;;
        "1")
            echo -e "\v\t${box2} ${blue}There are no changes to apply${reset}"
            ;;
        "2")
            echo -e "\v\t${box3} ${red}You need to specify a message for the commit${reset}"
            echo -e "\t    ${red}Press Ctrl + C to exit${reset}"
            return
            ;;
        *)
            echo -e "\v\t${box4} ${purple}Unknow error code${reset}"
            ;;
    esac

    # Wait for the user to press Enter key to continue
    echo -e -n "\v\t${cyan}Press Enter key to continue...${reset}" && read -r
    exit ${1}
}

# Get status for the local changes
STATUS=$(git status | grep -io "nothing to commit")

# If status message is "nothing to commit", terminate the script
if [[ "${STATUS}" == "nothing to commit" ]]; then
    handleCommitStatus 1
fi

# Add file .docx to working directory
git add "INFORME FINAL RP-23.docx"

# Show the local repository status
git status
echo -e "${blue}------------------------------${reset}"

while true; do
    # Add a commit message
    echo -e -n "\n${green}Mensaje del commit: ${reset}"
    read -r COMMIT_MESSAGE

    # If the commit message is empty, terminate the script
    if [[ -z "${COMMIT_MESSAGE}" ]]; then
        handleCommitStatus 2
    else
        break
    fi
done

# Get the current date for the commit
CURRENT_DATE=$(date +"%d/%m/%Y %H:%M:%S")

# Make the commit
git commit -m "${COMMIT_MESSAGE} -> ${CURRENT_DATE}"

# Push changes to remote repository
git push

# Terminate the script with exit code successful (0)
handleCommitStatus 0