#! /bin/python3
import sys
from collections import Counter
import math
import operator

if len(sys.argv)!=4:
    print("Errore")
    exit(0)
print(len(sys.argv))
train_file = sys.argv[1]
ngram_file = "concepts_sentence.txt"
test_file = sys.argv[2]
treshold = int(sys.argv[3])
test_notag_file = "test_no_concepts.txt"
automata_file = "automata_cut_off.txt" if treshold !=0 else "automata_no_cut_off.txt"
lexicon_file = "lexicon_cut_off.txt" if treshold !=0 else "lexicon_no_cut_off.txt"
lexicon_file_fin = lexicon_file[:-4]+"_test.txt"
file_data = []
word_cutoff = {}
concept_dict ={}
concepts_data = []
test_data = []


with open(train_file) as f:
    tmp = f.read().split('\n')
    concepts_string = ""
    for line in tmp:
        if line != '':
            x, y = line.split('\t')
            concepts_string = concepts_string + str(y) + "\t"
            file_data.append((x, y))
            if x in word_cutoff:
                word_cutoff[x] += 1
            else:
                word_cutoff[x] = 1
            if y in concept_dict:
                concept_dict[y] += 1
            else:
                concept_dict[y] = 1
        else:
            concepts_data.append(concepts_string[:-1])
            concepts_string = ""

concept_dict_removed = {}
to_delete =[]
if treshold !=0:
    for key, value in word_cutoff.items():
        if value < treshold:
            for item in file_data:
                if key == item[0]:
                    to_delete.append(item)
                    concept_dict[item[1]] -= 1
                    if item[1] in concept_dict_removed:
                        concept_dict_removed[item[1]] += 1
                    else:
                        concept_dict_removed[item[1]] = 1
for i in to_delete:
    file_data.remove(i)
file_map = Counter(file_data)
data = list(set(file_data))
data.sort()
with open(automata_file, "w") as w:
    for item in data:
        prob = -math.log(file_map[item] / concept_dict[item[1]])
        prob = 0.0 if prob == 0.0 else prob
        print("0" + "\t0\t" + str(item[0]) + "\t" + str(item[1]) + "\t" + str(prob), file=w)
    if treshold == 0:
        for key, value in concept_dict.items():
            print("0" + "\t0\t<unk>\t" + str(key) + "\t" + str(-math.log(1 / len(concept_dict))), file=w)
    else:
        for key in concept_dict_removed:
                print("0" + "\t0\t<unk>\t" + str(key) + "\t" + str(-math.log(concept_dict_removed[key] / sum(val for key, val in concept_dict_removed.items()))), file=w)
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
lexicon_data =[]
with open(lexicon_file,"r") as f:
    tmp = f.read().split('\n')
    for line in tmp:
        if line != '':
            x, y = line.split('\t')
            lexicon_data.append(x)
print(concept_dict_removed)
print(len(concept_dict))
with open(lexicon_file_fin, "w") as w4:
    counter = 0
    print("<eps>" + "\t" + str(counter), file=w4)
    for line in lexicon_data:
        if line in word_cutoff and word_cutoff[line] >= treshold:
            counter += 1
            print(line +"\t" + str(counter), file=w4)
    for line in concept_dict:
        counter += 1
        print(line + "\t" + str(counter), file=w4)
    counter +=1
    print("<unk>" + "\t" + str(counter), file=w4)
