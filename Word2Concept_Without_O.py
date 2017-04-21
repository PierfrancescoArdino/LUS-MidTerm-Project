#! /bin/python3
import sys
from collections import Counter
import math
import operator

if len(sys.argv)!=3:
    print("Errore")
    exit(0)
print(len(sys.argv))
train_file = sys.argv[1]
ngram_file = "concepts_sentence.txt"
test_file = sys.argv[2]
test_notag_file = "test_no_concepts.txt"
automata_file = "automata_w2c_without_O.txt"
lexicon_file = "lexicon_w2c_without_O.txt"
lexicon_file_fin = lexicon_file[:-4]+"_test.txt"
file_data = []
word_cutoff = {}
concept_dict ={}
concepts_data = []
test_data = []
concept_dict_real = []

with open(train_file) as f:
    tmp = f.read().split('\n')
    concepts_string = ""
    for line in tmp:
        if line != '':
            x, y = line.split('\t')
            if y == "O":
                concepts_string = concepts_string + str(x) + "\t"
                file_data.append((x, x))
                if x in concept_dict:
                    concept_dict[x] += 1
                else:
                    concept_dict[x] = 1

            else:
                concepts_string = concepts_string + str(y) + "\t"
                file_data.append((x, y))
                if y in concept_dict:
                    concept_dict[y] += 1
                else:
                    concept_dict_real.append(y)
                    concept_dict[y] = 1
        else:
            concepts_data.append(concepts_string[:-1])
            concepts_string = ""
file_map = Counter(file_data)
data = list(set(file_data))
data.sort()
with open(automata_file, "w") as w:
    for item in data:
        prob = -math.log(file_map[item] / concept_dict[item[1]])
        print("0" + "\t0\t" + str(item[0]) + "\t" + str(item[1]) + "\t" + str(prob), file=w)
    for key, value in concept_dict.items():
        print("0" + "\t0\t<unk>\t" + str(key) + "\t" + str(-math.log(1 / len(concept_dict))), file=w)
    print("0", file=w)

with open(ngram_file, "w") as w2:
    for line in concepts_data[:-1]:
        print(line, file=w2)

with open(test_file) as f:
    tmp = f.read().split('\n')
    output_string = ""
    for line in tmp:
        if line != '':
            x, y = line.split('\t')
            output_string = output_string + str(x) + "\t"
        else:
            test_data.append(output_string[:-1])
            output_string = ""

with open(test_notag_file, "w") as w3:
    for line in test_data[:-1]:
        print(line, file=w3)

with open("concept_list.txt","w") as w4:
    for line in concept_dict_real:
        print(line, file=w4)
