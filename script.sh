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
box5=$(echo -e ${green}[${reset}${cyan}*${reset}${green}]${reset})

# Function to validate repository path
function handleRepositoryPath() {
    while true; do
        echo -e "\v\t${box4} ${purple} Arrastra la carpeta del repositorio a la terminal y presiona Enter${reset}"
        echo -e -n "\t    ${purple} Esto solo se hace una vez ${reset}"
        read -r REPO_PATH

        # Check if the path is empty
        if [[ -z "${REPO_PATH}" ]]; then
            echo -e "\v\t${box3} ${red}Debes arrastrar la carpeta del repositorio a la terminal${reset}"
        elif [[ ! -d "${REPO_PATH}" || ! -d "${REPO_PATH}/.git" ]]; then
            echo -e "\v\t${box3} ${red}La ruta especificada no es una carpeta o no es un repositorio de GIT${reset}"
        else
            echo "${REPO_PATH}" > $(pwd)/repository.txt
            break
        fi

        echo -e "\t    ${red}Presiona Ctrl + C para salir${reset}"
    done
}

# Get the path of the local repository
if [[ -f $(pwd)/repository.txt ]]; then
    REPO_PATH=$(cat $(pwd)/repository.txt)
        
    if [[ ! -d "${REPO_PATH}" || ! -d "${REPO_PATH}/.git" ]]; then
        echo -e "\v\t${box3} ${red}La ruta especificada en el fichero '$(pwd)/repository.txt' no es una carpeta o no es un repositorio de GIT${reset}"
        handleRepositoryPath
    fi
else
    handleRepositoryPath
fi

# Change to the local repository directory
cd "${REPO_PATH}" || exit 1

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

# Function to add files to the commit
function addFiles() {
    # Clean the file includeOnly.txt
    sed -i 's/[[:space:]]*$//' "$(pwd)/includeOnly.txt"

    # Read the file includeOnly.txt and save the files in an array 
    readarray -t FILES < "$(pwd)/includeOnly.txt"

    # Add each file to the commit
    for FILE in "${FILES[@]}"; do
        echo "Adding file: ${FILE}"
        git add "./${FILE}"
    done
}


# If file includeOnly.txt is empty, add all files else add only the files specified in the file
if [[ ! -f $(pwd)/includeOnly.txt ]]; then
    echo -e "includeOnly.txt" > "$(pwd)/includeOnly.txt"
    echo -e "\v\t${box4} ${purple}Por defecto únicamente se pasaran al área de trabajo los documentos listados en el fichero $(pwd)/includeOnly.txt para añadir TODOS los documentos reemplace el contenido del fichero includeOnly.txt con un punto .${reset}"    
fi

# Add files to the commit
addFiles

# Show the local repository status
git status
echo -e "${blue}-----------------------------------------------------------------${reset}"

# Show the repository name
echo -e "\v\t${box5} ${green}Repository: ${reset}$(basename "${REPO_PATH}")"

while true; do
    # Add a commit message
    echo -e -n "\v\t${green}Mensaje del commit: ${reset}"
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