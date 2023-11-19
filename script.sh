#!/bin/env bash

# Colors
red='\e[1;31m'
green='\e[1;32m'
blue='\e[1;34m'
cyan='\e[1;36m'
reset='\e[0m'

# Move to the repository path
cd /c/xampp/htdocs/informe-final/

# Get status for the local changes
STATUS=$(git status | grep -io "nothing to commit")

# If status message is "nothing to commit", terminate the script
if [ "${STATUS}" == "nothing to commit" ]; then
    echo -e "${blue}There's no changes${reset}"

    # Wait for the user to press Enter key to continue
    echo -e -n "${cyan}Press Enter key to continue...${reset}" && read
    exit 1
fi

# Add file .docx to working directory
git add "INFORME FINAL RP-23.docx"

# Show the local repository status
git status
echo -e "${blue}------------------------------${reset}"

# Add a commit message
echo -e -n "${green}Agregue un nombre de versión: ${reset}"
read COMMIT_MESSAGE

# If the commit message is empty, terminate the script
if [ "${COMMIT_MESSAGE}" == "" ]; then
    echo -e "${red}You need to specify a message for this file version${reset}"
    echo -e "${red}Run the script again${reset}"

    # Wait for the user to press Enter key to continue
    echo -e -n "${cyan}Press Enter key to continue...${reset}" && read
    exit 1
fi

# Get the current date for the commit
CURRENT_DATE=$(date +"%d/%m/%Y %H:%M:%S")
echo "${COMMIT_MESSAGE} -> ${CURRENT_DATE}"

# Make the commit
git commit -m "${COMMIT_MESSAGE} -> ${CURRENT_DATE}"

# Push changes to remote repository
git push

# Wait for the user to press Enter key
echo -e -n "${cyan}Press Enter key to continue...${reset}" && read
