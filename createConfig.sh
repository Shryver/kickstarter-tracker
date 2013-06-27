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
	echo "USER=$1"	> $beg$1$end
	cat skel/skel.sh>> $beg$1$end
	chmod +x $beg$1$end
}

checkArgs $1
