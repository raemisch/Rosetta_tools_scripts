#!/bin/bash

echo "usage: ./duplicate_frags.sh <3mer file> <9mer file>"

if [ "$2" == "" ]; then echo "one fragment  file is missing ... exiting"; exit 1; fi

if [ -f $1 ]; then
	echo ""
else
	echo "$1 does not exist"
	exit 1
fi


# Check number of fragment frames
positions=`cat $1 | egrep 'position|FRAME' | wc -l`
echo "$positions fragment positions found in $1"

hasFrame=`head $1 | grep FRAME | wc -l`
if [ $hasFrame = 1 ]; then
	# New fragment file:
	#####  Dummy fragments   ##############################################################################################
	# copy the first two frames to be used as dummy frags. Those are the ones, that overlap between the monomers. They are
	# not going to be used be asym. fold and dock
	# Two frames are exactly 2002 lines long
	head -2002 $1 > tmp
	new1A=`expr $positions + 1`
	new1B=`expr $positions + 3`
	new2A=`expr $positions + 2`
	new2B=`expr $positions + 4`
	sed -E -i '' 's/FRAME[[:space:]]+1[[:space:]]+3/FRAME   '$new1A'  '$new1B'/g' tmp
	sed -E -i '' 's/FRAME[[:space:]]+2[[:space:]]+4/FRAME   '$new2A'  '$new2B'/g' tmp
	#####  Duplicate fragments  ############################################################################################
	# copy frags file to tmp
	cat $1 >> tmp
	int1=1
	int2=3
	while [ $int1 -le $positions ]; do
		new1=`expr $int1 + $positions + 2`
		new2=`expr $int2 + $positions + 2`
		sed -E -i '' 's/FRAME[[:space:]]+'$int1'[[:space:]]+'$int2'/FRAME   '$new1'  '$new2'/g' tmp
		let int1++
		let int2++
	done
else
	# Old fragment file:
	#####  Dummy fragments   ##############################################################################################
	# copy the first two frames to be used as dummy frags. Those are the ones, that overlap between the monomers. They are
	# not going to be used be asym. fold and dock
	# Two frames are exactly 1603 lines long
	head -1603 $1 > tmp
	new1A=`expr $positions + 1`
	new1B=`expr $positions + 3`
	new2A=`expr $positions + 2`
	new2B=`expr $positions + 4`
	sed -E -i '' 's/position:\s+1/position:           '$new1A'/g' tmp
	sed -E -i '' 's/position:\s+2/position:           '$new2A'/g' tmp

	####  Duplicate fragments  ############################################################################################
	# copy frags file to tmp
	cat $1 >> tmp
	int1=1
	while [ $int1 -le $positions ]; do
		new1=`expr $int1 + $positions + 2`
		sed -E -i '' 's/position:\s+'$int1'\s/position:           '$new1' /g' tmp
		let int1++
	done
fi
	cp $1 $1\_duplicated
	cat tmp >> $1\_duplicated
	rm tmp
	frag_nr=`egrep 'position|FRAME' $1\_duplicated | wc -l`
	echo "New 3mer fragments in: $1_duplicated. Number of fragments: $frag_nr"

##############################################################################################
# same procedure for the 9mer file

positions=`cat $2| egrep 'position|FRAME' | wc -l`
echo "$positions fragment positions found in $2"
hasFrame=`head $1 | grep FRAME | wc -l`

if [ $hasFrame = 1 ]; then
	head -17608 $2 > tmp
	# Renumber dummy fragments
	int1=1
	int2=9
	while [ $int1 -le 8 ]; do
		new1=`expr $int1 + $positions`
		new2=`expr $int2 + $positions`
		sed -E -i '' 's/FRAME[[:space:]]+'$int1'[[:space:]]+'$int2'/FRAME   '$new1'  '$new2'/g' tmp
		let int1++
		let int2++
	done
	# Append and rename real fragments
	cat $2 >> tmp
	int1=1
	int2=9
	while [ $int1 -le $positions ]; do
		new1=`expr $int1 + $positions + 8`
		new2=`expr $int2 + $positions + 8`
		sed -E -i '' 's/FRAME[[:space:]]+'$int1'[[:space:]]+'$int2'/FRAME   '$new1'  '$new2'/g' tmp
		let int1++
		let int2++
	done
else
	# old fragments
	head -18017 $2 > tmp
	# Renumber dummy fragments
	int1=1
	int2=9
	while [ $int1 -le 8 ]; do
		new1=`expr $int1 + $positions`
		sed -E -i '' 's/position:\s+'$int1'\s/position:          '$new1' /g' tmp
		let int1++
	done
	# Append and rename real fragments
	cat $2 >> tmp
	int1=1
	int2=9
	while [ $int1 -le $positions ]; do
		new1=`expr $int1 + $positions + 8`
		sed -E -i '' 's/position:\s+'$int1'\s/position:          '$new1' /g' tmp
		let int1++
	done
fi
cp $2 $2\_duplicated
cat tmp >> $2\_duplicated
rm tmp
frag_nr=`egrep 'position|FRAME' $2\_duplicated | wc -l`
echo "New 9mer fragments in: $2_duplicated. Number of fragments: $frag_nr"

exit 0
