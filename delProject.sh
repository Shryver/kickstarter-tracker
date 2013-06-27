#!/bin/bash

end=_new

function checkArgs {
	if [[ $# -eq 2 ]]; then
		checkFile $1 $2
	else
		usage
	fi
}

function checkFile {
	if [[ -f $1 ]]; then
		removeProjectFromFile $1 $2
	else
		usage
	fi
}

function removeProjectFromFile {
	grep -v "$2" $1 >> $1$end
	mv $1$end $1
}

function usage {
	echo -ne "\tusage: $0 dbPath projectUrl"
}

checkArgs $1 $2
