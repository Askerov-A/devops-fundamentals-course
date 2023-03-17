#!/bin/bash

function COUNT_FILES {
    DIR=$1
    FILES=`find $DIR -type f | wc -l`
    echo $FILES
}

COUNT_FILES $1
