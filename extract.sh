#!/bin/bash

echo "Usage:  extract.sh <Filename.out> <number> || -tags <tag>"

# Create a new silent file containing the top X structures

if ! [[ $2 =~ ^[1-9] ]] && [[ $2 != "-tags" ]] ; then
	echo "ERROR: Second argument must be a number or \"-tags\""
	exit
fi


if [ $2 != "-tags" ]; then
	echo "Extracting by score cutoff ..."
	num=$(($2))
	score=`grep SCORE: $1 | grep "-" | sort -n -k2 | awk '{print $2}' | sed -n "$num p"`
	score_plus=$(python -c "print ($score + 0.001)")
	echo "cut off: $score_plus"
	name=${1%.out}
	name=`echo $name | awk -F'/' '{print $NF}'`
	out_name=$name"_top$2.out"
	merge_silent.pl $1 -c $score_plus > $out_name

	echo "Created $out_name. Shall the sequences be exctracted, too? [y/n]"
	read answer
	if [ "$answer" == "n" ]; then
		continue
	else
		echo "Extracting sequences"
		get_sequence_from_silentfile.py $out_name
	fi

	echo "Shall the pdb files be exctracted, too? [y/n]. Default: No"
	read answer

	if [ "$answer" == "y" ]; then
			# Extract those PDB files
			extract_pdbs.default.macosclangrelease \
			-in:file:silent_struct_type binary \
			-in:file:fullatom \
			-in::file:silent_struct_type binary \
			-in:file:silent $out_name
	fi

else
	if [ -z $3 ]; then
		echo "ERROR: No tag name given."
		exit
	fi

  tags_nr=`expr $# - 2`
	names=""
	echo "Extracting decoys:"
	for i in ${@:3}; do
		names=`echo "$names " $i`
		echo $names
	done

	# Extract those PDB files
	extract_pdbs.default.macosclangrelease \
	-in:file:silent_struct_type binary \
	-in:file:fullatom \
	-in::file:silent_struct_type binary \
	-in:file:silent $1 \
	-in:ignore_unrecognized_res \
	-in:file:tags $names
fi
