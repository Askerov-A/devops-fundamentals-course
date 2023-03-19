#!/bin/bash

. ./shared.sh

function buildApp {
    cd ./client-repo
    printCommandName "Installing dependencies"
    npm install
    printCommandName "Building application"
    npm run build
    cd ../
}

fetchSourceCode https://github.com/EPAM-JS-Competency-center/shop-angular-cloudfront ./client-repo
buildApp
compressBuild ./build-client.zip ./client-repo/dist/app
