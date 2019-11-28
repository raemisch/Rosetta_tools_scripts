#!/usr/bin/python

import string
from sys import argv
import re

file=open(argv[1], "r")
LAST=""
NAME=""
LIST=[]
for line in file:
	if re.match('>', line):
		NAME = line
	else:
		if line != LAST and line not in LIST:
			print NAME.rstrip("\n")
			print line.rstrip("\n")
			LIST.append(line)
			LAST = line




