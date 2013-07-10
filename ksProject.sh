#!/bin/bash

function fetchTitle {
	grep "<meta property=\"og:title" $CACHE$1 \
	| rev | cut -c 4- | rev \
	| cut -c 36- \
	>> $DATA$1
}

function fetchGoal {
	grep "<meta property=\"twitter:data1" $CACHE$1 \
	| rev | cut -c 4- | rev \
	| cut -c 41- \
	>> $DATA$1
}

function fetchRaised {
	grep "<meta property=\"twitter:label1" $CACHE$1 \
	| rev | cut -c 4- | rev \
	| cut -c 53- \
	>> $DATA$1
}

function fetchTime {
	grep "<meta property=\"twitter:data2" $CACHE$1 \
	| rev | cut -c 4- | rev \
	| cut -c 41- \
	>> $DATA$1
}

function fetchTimeUnit {
	grep "<meta property=\"twitter:label2" $CACHE$1 \
	| rev | cut -c 10- | rev \
	| cut -c 42- \
	>> $DATA$1
}

function rssFileBegin {
	echo "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>"		>  $RSSFILE
	echo "<rss version=\"2.0\">"					>> $RSSFILE
	echo "<channel>"						>> $RSSFILE
	echo "  <title>Kickstarter - $USER </title>"			>> $RSSFILE
	echo "  <link>http://grenada42.com/</link>"			>> $RSSFILE
	echo "  <description>Kickstarter RSS for $USER</description>"	>> $RSSFILE
	echo "  <lastBuildDate>`date +\"%a, %d %b %Y %H:%M:%S %z\"`</lastBuildDate>"\
	>> $RSSFILE
}

function rssFileEnd {
	echo "</channel>"	>> $RSSFILE
	echo "</rss>"		>> $RSSFILE
}

function dataToRss {
	echo ""		>> $RSSFILE
	echo "<item>"	>> $RSSFILE
	a=0
	while read line; do
		a=$[a+i]
		if [[ a -eq 1 ]]; then
			b=title
			echo -ne "\t<$b>$line</$b>\n" 	>> $RSSFILE
		fi; if [[ a -eq 2 ]]; then
			b=description
			echo -ne "\t<$b>raised $line "	>> $RSSFILE
		fi; if [[ a -eq 3 ]]; then
			echo -ne "out of $line.\n"	>> $RSSFILE
		fi; if [[ a -eq 4 ]]; then
			echo -ne "\t\ttime left: $line ">> $RSSFILE
		fi; if [[ a -eq 5 ]]; then
			echo -ne "$line."		>> $RSSFILE
			echo -ne "</$b>\n"		>> $RSSFILE
		fi
	done <$1
	echo "</item>"	>> $RSSFILE
	echo ""		>> $RSSFILE
}

function exploitData {
	cat $DATA$1 >> $TXTFILE
	dataToRss $DATA$1
	rm $DATA$1
	rm $CACHE$1
	rm $WGETLOG
}

function fetchData {
	fetchTitle $1
	fetchGoal $1
	fetchRaised $1
	fetchTime $1
	fetchTimeUnit $1
	exploitData $1
}

function fetchInfos {
	if [[ -f $TXTFILE ]]; then
		rm $TXTFILE
	fi
	if [[ -f $TXTFILE ]]; then
		rm $RSSFILE
	fi
	a=$BASE
	rssFileBegin
	for project in `cat $DBFILE`; do
		a=$[a+i]
		wget $project -o $WGETLOG -O $CACHE$a
		fetchData $a
	done
	rssFileEnd
}
