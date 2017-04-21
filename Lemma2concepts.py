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
train_lemma_pos = sys.argv[3]
test_notag_file = "test_no_concepts.txt"
automata_file = "automata_lemma2concepts.txt"
lexicon_file = "lexicon_lemma2concepts.txt"
file_data = []
concept_dict = {}
concepts_data = []
test_data = []
with open(train_file) as f, open(train_lemma_pos) as f1:
    concepts_string = ""
    tmp = f.read().split('\n')
    tmp1 = f1.read().split('\n')
    for line_train, line_feats in zip(tmp, tmp1):
        if line_train != '':
            word_concepts = line_train.split('\t')
            word_tag_lemma = line_feats.split('\t')
            concepts_string = concepts_string + str(word_concepts[1]) + "\t"
            file_data.append((word_tag_lemma[2], word_concepts[1]))
            if word_concepts[1] in concept_dict:
                concept_dict[word_concepts[1]] += 1
            else:
                concept_dict[word_concepts[1]] = 1
        else:
            concepts_data.append(concepts_string[:-1])
            concepts_string = ""
file_map = Counter(file_data)
data = list(set(file_data))
data.sort()
with open(automata_file, "w") as w:
    for item in data:
        prob = -math.log(file_map[item] / concept_dict[item[1]])
        prob = 0.0 if prob == 0.0 else prob
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
            word, pos, lemma = line.split('\t')
            output_string = output_string + str(lemma) + "\t"
        else:
            test_data.append(output_string[:-1])
            output_string = ""

with open(test_notag_file, "w") as w3:
    for line in test_data[:-1]:
        print(line, file=w3)

