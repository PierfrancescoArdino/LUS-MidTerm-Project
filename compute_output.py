#! /bin/python3
'''
LUS mid-term project, Spring 2017
Student: Pierfrancesco Ardino, 189159

This script simply check if the output concept is in the concept list, if not it means that the output concept is the word
itself and so has to be changed into the O concept
#### HOW-TO USE####
Do not run this script independently.
Please refer to the elaborator_w2c_without_O.sh that will creates the lexicon, runs this script and trains the automaton
Do not touch any file in the directory.
'''
import sys
output_original = sys.argv[1]
output_file = sys.argv[2]
concept_file = sys.argv[3]

with open(output_original) as f, open(concept_file) as f1, open(output_file, "w") as w:
    tmp = f.read().split('\n')
    tmp1 = f1.read().split('\n')
    print(tmp)
    for line in tmp:
        if line != '':
            if line in tmp1:
                print(line,file=w)
            else:
                print("O", file=w)
        else:
            print("", file=w)