#!/bin/bash

beg="conf/"
end=.sh

function checkArgs {
	if [[ $# -eq 1 ]]; then
		checkFile $1
	else
		usage
	fi
}

function checkFile {
	if [[ -f $1 ]]; then
		echo "config file already exists."
		usage
	else
		createFile $1
	fi
}

function usage {
	echo -ne "\tusage: $0 username"
}

function createFile {
	if [[ ! -d tmp/ ]]; then
		mkdir tmp
	fi
	if [[ ! -d conf/ ]]; then
		mkdir conf
	fi
	if [[ ! -d db/ ]]; then
		mkdir db
	fi
	if [[ ! -f db/db_$1 ]]; then
		touch db/db_$1
	fi

	echo "USER=$1"	> $beg$1$end
	cat skel/skel.sh>> $beg$1$end
	chmod +x $beg$1$end
}

checkArgs $1
