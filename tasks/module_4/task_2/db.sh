#!/bin/bash

fileName=users.db
folder=./data
fullPath="${folder}/${fileName}"

command=$1
param=$2

function createDb {
    if [[ ! -d $folder ]]
    then
        mkdir $folder
        echo "Created new db folder"
    fi
    if [[ ! -f "${folder}/${fileName}" ]]
    then
        touch $fullPath
        echo "Created new db file"
    fi
}

function validateLatinLetters {
    if [[ $1 =~ ^[A-Za-z_]+$ ]]
    then
        return 0
    else
        return 1
    fi
}

function add {
    read "userName?Enter username: "
    validateLatinLetters $userName
    if [[ "$?" == 1 ]];
    then
      echo "Name must have only latin letters"
      exit 1
    fi

    read "role?Enter role: "
    validateLatinLetters $userName
    if [[ "$?" == 1 ]];
    then
      echo "Role must have only latin letters"
      exit 1
    fi

    echo "${userName}, ${role}" | tee -a $fullPath
}

function list {
    echo $param
    if [[ $param == "--inverse" ]]
    then
        cat -n $fullPath | tail -r
    else
        cat -n $fullPath
    fi
}

function find {
    read "userName?Whom are we looking for? "
    result=$(grep "${userName}," $fullPath)

    if [[ $result ]]
    then
        echo $result
    else
        echo "We don't have such a user"
        exit 1
    fi
}

function backup {
    currentDate=$(date +"%d-%m-%YT%T")
    fileName="${folder}/${currentDate}-${fileName}.backup"
    cp $fullPath $fileName
    echo "Created new backup: ${fileName}"
}

function restore {
    fileToRestore=$(ls $folder/*-$fileName.backup | tail -n 1)

    if [[ ! -f $fileToRestore ]]
    then
        echo 'Nothing to restore, sorry'
        exit 1
    fi

    cat $fileToRestore > $fullPath
    echo "Restored ${fileToRestore}"
}

function help {
    echo "Current script has the following commands:"
    echo "--"
    echo ""
    echo "add       Adds new user to db"
    echo "          Both the user & role values should be latin"
    echo ""
    echo "backup    Creates the db backup"
    echo ""
    echo "restore   Restores last backup"
    echo ""
    echo "find      Find your user by name"
    echo ""
    echo "list      List all your users"
    echo "          --inverse - revert the list order"
}

createDb
case $command in
  add)            add ;;
  backup)         backup ;;
  restore)        restore ;;
  find)           find ;;
  list)           list ;;
  help | '' | *)  help ;;
esac
