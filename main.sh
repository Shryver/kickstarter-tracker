#!/bin/bash

function checkArgs {
	if [[ $# -eq 1 ]]; then
		checkFile $1
	else
		usage
	fi
}

function checkFile {
	if [[ -f $1 ]]; then
		. $1
		. $KSPROJECT
	else
		echo "config file does not exist"
		usage
	fi
}

function usage {
	echo -ne "\tusage: $0 configFile"
	exit
}

checkArgs $1
fetchInfos
