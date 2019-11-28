#!/usr/bin/python
from sys import argv

file = open(argv[1],'r')
name = ""
for i,line in enumerate(file):
    if line[0] != '>':
        #file_name = "resfile_" + str((i+1)/2)
        file_name = "resfile_" + name
        out_file=open(file_name,'w')
        out_file.write("NATRO\n")
        out_file.write("start\n")
        for indx,aa in enumerate(line):
          if aa != "\n" and aa != "":
            out_file.write( str(indx+1) + " A " + "PIKAA " + aa + "\n" )
    else:
        name = line[1:].strip()
        print "resfile_" + name
