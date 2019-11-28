#!/usr/bin/python

from sys import argv
from re import search

file = open(argv[1], 'r')

dict = {}

for line in file:
	indx = 0
	for c in line:
		if ( (c == 'N') and (line[indx+1] != 'P') and (line[indx+2] == 'S' or line[indx+2] == 'T' )):
			if ( dict.has_key(indx+1) == False ):
				dict[indx+1] = 1
			else:
				dict[indx+1] += 1
		indx += 1
                
for key in dict:
    print str(key) + " " + str(dict[key]) 
