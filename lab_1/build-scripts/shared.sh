#!/bin/bash

red=31
green=32
blue=34

function countFiles {
    dir=$1
    filesNumber=`find $dir -type f | wc -l`
    echo $filesNumber | xargs
}

function printColored {
    color=$1
    text=$2
    echo "\e[${color}m${text}\e[0m"
}

function printCommandName {
    printColored $blue "-----"
    printColored $blue $1
    printColored $blue "-----"
}

function fetchSourceCode {
    repoUrl=$1
    folderName=$2

    if [[ ! -d "./${folderName}" ]]
    then
        printCommandName "Cloning the repo"
        git clone $repoUrl $folderName
    else
        printCommandName "Pulling the updates"
        cd "./${folderName}"
        git pull
        cd ../
    fi
}

function compressBuild {
    compressedFile=$1
    buildDist=$2

    printCommandName "Compressing build"
    if [[ -f $compressedFile ]]
    then
        rm $compressedFile
    fi

    zip -r -j $compressedFile $buildDist
    filesNumber=$(countFiles $buildDist)
    printColored $green "Succesfully created ${compressedFile}. It contains ${filesNumber} files."
}

function exitIfFails {
    operation=$2

    if [[ $1 == 0 ]]
    then
        echo ""
        printColored $green "Operation '${operation}' finished successfully"
        echo ""
    else
        echo ""
        printColored $red "ERROR: Operation '${operation}' has been failed"
        exit 0
    fi
}
