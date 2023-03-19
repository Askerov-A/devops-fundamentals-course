#!/bin/bash

. ./shared.sh
fetchSourceCode https://github.com/EPAM-JS-Competency-center/shop-angular-cloudfront ./client-repo

function checkQuality {
    cd ./client-repo

    printCommandName "Run linter"
    npm run lint
    exitIfFails $? "Lint files"

    printCommandName "Run tests"
    npm run test -- --watch=false
    exitIfFails $? "Run tests"

    printCommandName "Run e2e tests"
    npm run e2e
    exitIfFails $? "e2e tests"

    printCommandName "Run audit"
    npm audit
    exitIfFails $? "Run audit"
}

checkQuality
