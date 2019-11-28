#!/usr/bin/python

from sys import argv
import re

f = open(argv[1],"r")
pattern=r'(\[[A-Za-z:*_*]*\])'
num=0

# get rid of ".out"
file_name = argv[1].split('.')
name_lst = file_name[0:(len(file_name)-1)]
name_str = ""
for i in name_lst:
	name_str += i
	name_str += "."
out_file_name = name_str + "fasta"


output = open(out_file_name, 'w')


for line in f:
	if re.search('ANNOT',line) != None:
		string = line.split()[1]
		name = line.split()[2]
		elements = re.split(pattern,string)
		sequence = ""
		for i in elements:
			if re.search('\[|X',i) == None:
				sequence = sequence + i
		num += 1
		#print "> " + str(num)
		#print sequence
		#output.write("> " + str(num) +"\n")
		output.write("> " + name + "\n")
		output.write(sequence + "\n")

exit(0)






