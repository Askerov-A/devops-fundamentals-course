#!/bin/bash

. ./shared.sh

function buildApp {
    cd ./backend-repo
    printCommandName "Installing dependencies"
    npm install
    printCommandName "Building application"
    npm run build
    cd ../
}

fetchSourceCode https://github.com/EPAM-JS-Competency-center/nestjs-rest-api.git ./backend-repo
buildApp
compressBuild ./build-backend.zip ./backend-repo/dist
