#!/bin/bash

echo "usage: ./find_score.sh <scorefile> <scorename> [<line number>]"
echo ""

COUNTER=1
LINE=1
if [ $3 ]; then LINE=$3; fi


while [ `sed -n $LINE\p $1 | awk '{print $'$COUNTER'}'` != "description" ]; do
	SCORE=`sed -n $LINE\p $1 | awk '{print $'$COUNTER'}'`
	echo "score type:    $SCORE"
	if [ $SCORE = $2 ]; then
		echo "---------------------------------------"
		echo "$SCORE can be found in column $COUNTER"
		echo "---------------------------------------"
	fi
	let COUNTER=COUNTER+1
done
