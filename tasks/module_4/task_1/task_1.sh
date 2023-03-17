#!/bin/bash

# default value
TRESHOLD=30

function SET_TRESHOLD {
    if [[ $# -le 0 ]]
    then
        printf "Treshold set to ${TRESHOLD}\n"
    else
        if [[ $1 =~ ^-?[0-9]+([0-9]+)?$ ]]
        then
            TRESHOLD=$1
        fi
    fi
}

function CHECK_PARTITION {
    let "TRESHOLD += 0"
    printf "Treshold = %d\n" $TRESHOLD

    df -Ph | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5,$1 }' | while read data;
    do
        used=$(echo $data | awk '{print $1}' | sed s/%//g)
        p=$(echo $data | awk '{print $2}')
        if [[ ! $used =~ ^-?[0-9]+([0-9]+)?$ ]]
        then
            continue
        fi
        if [ $used -ge $TRESHOLD ]
        then
            echo "WARNING: The partition \"$p\" has used $used% of total available space - Date: $(date)"
        fi
    done
}

SET_TRESHOLD $1
CHECK_PARTITION
