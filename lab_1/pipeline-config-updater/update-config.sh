#!/bin/bash

red=31
green=32
blue=34

function printColored {
    color=$1
    text=$2
    echo "\e[${color}m${text}\e[0m"
}

function showErrorMessage {
    echo ""
    printColored $red "ERROR: You don't have jq installed."
    echo ""
    printColored $blue "------------------------"
    printColored $blue "Please do the following:"
    printColored $blue "------------------------"
    echo ""
    printColored $blue "MacOS:   Install it via Homebrew"
    printColored $green "         brew install jq"
    echo ""
    printColored $blue "Windows: Use Chocolatey NuGet"
    printColored $green "         chocolatey install jq"
    echo ""
    printColored $blue "Linux:   On Ubuntu or Debian use sudo-apt"
    printColored $green "         sudo apt-get install jq"
    echo ""
    echo ""
}

function showHelp {
    echo ""
    printColored $blue "Pipeline config modifier"
    printColored $blue "------------------------"
    echo ""
    printColored $green "-c | --configuration"
    printColored $blue "Which configuration to use? (production / dev)"
    echo ""
    printColored $green "-o | --owner"
    printColored $blue "Who is the owner of the source code?"
    echo ""
    printColored $green "-b | --branch"
    printColored $blue "Target branch"
    echo ""
    printColored $green "-p | --poll-for-source-changes"
    printColored $blue "If we need to poll for the changes"
    echo ""
    printColored $green "-r | --repo"
    printColored $blue "Repo link"
    echo ""
}

function checkIfJQExists {
    if [[ ! $(command -v jq) ]]
    then
        showErrorMessage
        exit 1
    fi
}

function modifyFile {
    currentDate=$(date +"%d-%m-%YT%T")

    configuration=$2
    branch=$3
    pollChanges=$4
    repo=$5
    owner=$6

    tmp=$(mktemp)

    jq \
        --arg branch "$branch" \
        --arg owner "$owner" \
        --arg repo "$repo" \
        --arg pollChanges "$pollChanges" \
        --arg configuration "$configuration" \
        '
            del(.metadata)
            | .pipeline.version = .pipeline.version + 1
            | .pipeline.stages[0].actions[0].configuration |=
                ((if $owner != "" then .Owner = $owner else . end) |
                (if $branch != "" then .Branch = $branch else . end) |
                (if $repo != "" then .Repo = $repo else . end) |
                (if $pollChanges != "" then .PollForSourceChanges = $pollChanges else . end) |
                (if $configuration != "" then .EnvironmentVariables = { BUILD_CONFIGURATION: $configuration } else . end))
        ' $1 > $tmp
    mv "$tmp" "pipeline-${currentDate}.json"
}

if [[ $1 == '--help' || $1 == '-h' ]]
then
    showHelp
    exit 1
fi    
if [[ $1 == '' || $1 == -* ]]
then
    printColored $red "ERROR: Please input the file name."
    exit 1
fi

fileName=$1

while [[ $# -gt 1 ]]
do
key="$2"

case $key in
    -c|--configuration)
    configuration="$3"
    shift
    shift
    ;;
    -o|--owner)
    owner="$3"
    shift
    shift
    ;;
    -b|--branch)
    branch="$3"
    shift
    shift
    ;;
    -p|--poll-for-source-changes)
    poll="$3"
    shift
    shift
    ;;
    -r|--repo)
    repo="$3"
    shift
    shift
    ;;
    *)    # unknown option
    echo "Unknown option: $key"
    exit 1
    ;;
esac
done

checkIfJQExists
modifyFile $fileName $configuration $branch $poll $repo $owner
