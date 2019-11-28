#!/usr/bin/python

from sys import argv
from re import search

file = open(argv[1], 'r')

current_name = ""

all_positions = [8,11,27,32,34,36,38,39,40,41,43,46,47,49,50,55,62,63,66,67,70,72,74,75,76,78,81,91,95,96,105,107,115,121,123,124,125,127,131,133,135,141,144,151,155,159,163,165,166,167,168]
current_list = []
current_PGSs = []
for line in file:
	if ( search('>',line) ):
		current_name = line.split('>')[1].strip()
		current_list.append(current_name)
		continue
	elif ( search("[a-zA-Z]",line) == None ):
		continue
	else:
		indx = 0
		for c in line:
			if ( (c == 'N') and (line[indx+1] != 'P') and (line[indx+2] == 'S' or line[indx+2] == 'T' )):
					current_PGSs.append(indx+1)
			indx += 1

		for i in all_positions:
			if ( i in current_PGSs ):
				current_list.append(str(i))
			else:
				current_list.append('')
		print(','.join(current_list))
		current_list = []
		current_PGSs = []
