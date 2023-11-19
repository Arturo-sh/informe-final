#!/bin/env bash

# Colors
red='\e[1;31m'
green='\e[1;32m'
reset='\e[0m'

# Add file .docx to working directory
git add "INFORME FINAL RP-23.docx"

# Commit message
echo -e -n "${green}Agrega un nombre de versión: ${reset}"
read COMMIT_MESSAGE

# If the commit message is empty end the script
if [ "${COMMIT_MESSAGE}" == "" ]; then
    echo -e "${red}You need to specify a message for this file version${reset}"
    echo -e "${red}Run the script again${reset}"
    exit 1
fi

# Get the current date for the commit
CURRENT_DATE=$(date +"%d/%m/%Y %H:%M:%S")

# Make the commit
git commit -m "${COMMIT_MESSAGE} -> ${CURRENT_DATE}"

# Push changes to remote repository
git push
