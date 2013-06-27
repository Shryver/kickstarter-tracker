#!/bin/bash

function checkArgs {
	if [[ $# -eq 2 ]]; then
		checkFile $1 $2
	else
		usage
	fi
}

function checkFile {
	if [[ -f $1 ]]; then
		addProjectToFile $1 $2
	else
		usage
	fi
}

function addProjectToFile {
	echo $2 >> $1
}

function usage {
	echo -ne "\tusage: $0 dbPath projectUrl"
}

checkArgs $1 $2
