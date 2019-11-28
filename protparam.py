#!/usr/bin/python

from sys import argv
import re
from Bio.SeqUtils.ProtParam import ProteinAnalysis
from subprocess import call


#infile = open(argv[1],'r')
name = ""
MW = ""
EC_MW = ""

file_name=argv[1].split(".rtf")[0]
cmd = "textutil -convert txt " + argv[1]
call(['/bin/zsh','-i','-c',cmd])
string = file_name + ".txt"
infile=open(string,'r')

ofile_str = argv[1] + "_params.csv"
call(["rm",ofile_str])
ofile = open(ofile_str,'w')

ofile.write("name,MW,EC,EC/MW\n")

for line in infile:
	if re.search('^[0-9]+\.', line):
		name = '.'.join(line.strip().split('.')[1:])
	if re.search('^[A-Z]{20}', line):
		my_seq = line.strip().strip( '\*' )
		analysed_seq = ProteinAnalysis(my_seq)
		MW = analysed_seq.molecular_weight()
		W = analysed_seq.count_amino_acids()['W']
		Y = analysed_seq.count_amino_acids()['Y']
		C = analysed_seq.count_amino_acids()['C']
		EC = Y*1490 + W*5500 + C*125
		EC_MW = EC / MW
		ofile.write( name + "," + str(MW) + "," + str(EC) + "," +  str(EC_MW) + '\n' )
		print name + " " + str(MW) + " " + str(EC) + " " +  str(EC_MW)

ofile.close()
call(["open",ofile_str])
exit
