#! /bin/python3
'''
LUS mid-term project, Spring 2017
Student: Pierfrancesco Ardino, 189159

This is the last version of the project, it is similar to the Word2Concept test but works on an edited training set.
The training set has been modified assigning as concept for each word the word itself when the concept associated to the word is O.

The main operations it does are:
1- Calculate the likelihoods (probabilities of words given the concept) using the word itself as concept when it is associated to an O concept.
2- Create the ngram file for the LM and the test file.
#### HOW-TO USE####
Do not run this script independently.
Please refer to the elaborator_w2c_without_O.sh that will creates the lexicon, runs this script and trains the automaton
Do not touch any file in the directory.
'''
import sys
from collections import Counter
import math

train_file = sys.argv[1]
ngram_file = "concepts_sentence.txt"
test_file = sys.argv[2]
test_notag_file = "test_no_concepts.txt"
automata_file = "automata_w2c_without_O.txt"
file_data = []
concept_dict = {}
concepts_data = []
test_data = []
concept_dict_real = []
# Substitute the O with the word itself
# Compute the counters C(word,iob) and C(iob)
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
#Create the automaton file, compute the probabilities using the counters computed before
# without cut-off pairs <unk>-concept will have a probability equal to 1/#concepts
# P(word | iob) = C(word, iob) / C(iob)
with open(automata_file, "w") as w:
    for item in data:
        prob = -math.log(file_map[item] / concept_dict[item[1]])
        print("0" + "\t0\t" + str(item[0]) + "\t" + str(item[1]) + "\t" + str(prob), file=w)
    for key, value in concept_dict.items():
        print("0" + "\t0\t<unk>\t" + str(key) + "\t" + str(-math.log(1 / len(concept_dict))), file=w)
    print("0", file=w)

#Create the ngram file that will be used by the LM using only the the concept

with open(ngram_file, "w") as w2:
    for line in concepts_data[:-1]:
        print(line, file=w2)
#Create sentences from the test file to be used during the testing phase

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
#Create a concept list file to be used later in the testing phase
with open("concept_list.txt","w") as w4:
    for line in concept_dict_real:
        print(line, file=w4)
