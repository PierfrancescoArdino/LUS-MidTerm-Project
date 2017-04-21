#! /bin/python3
import sys

if len(sys.argv)!=4:
    print("Errore")
    exit(0)
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