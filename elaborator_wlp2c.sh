#! /bin/bash

################################################################################################################################
#INSTRUCTIONS:
#Run the script with the following parameters
#@param: train file
#@param: test file
#@param: train features
#@param: smoothing method file
#@param: test features
#@param: ngram_order
# P(w, l, p | c) = C(w, l, p, c)/C(c)

################################################################################################################################

train_file=$1
test_file=$2
train_features=$3
test_features=$5
lexicon="lexicon_WordLemmaPos2concepts.txt"
input_test="test_no_concepts.txt"
automata_wlp2c_txt="automata_WordLemmaPos2concepts.txt"
automata_wlp2c="automata_WordLemmaPos2concepts.fst"
method_file=$4
ngram_order=$6
sentence_counter=0
if [ "$#" -ne 6 ]; then
    echo "Illegal number of parameters"
    echo -e "Incorrect syntax, use the following one.\n-arg1=train_file \n-arg2=test_file \n-arg3=train_features \n-arg4=smoothing_method_file \n-arg5=test_features \n-arg6=ngram_order"
    exit 1
fi
#generate lexicon for the WordLemmaPos2Concept transducer

    ./gen_lex_WordLemmaPos2Concept.sh $1 $3 $lexicon
#generate the automaton, the ngram file and the test file

    ./WordLemmaPos2Concept.py $1 $5 $3
#compile the automaton

    fstcompile --isymbols=$lexicon --osymbols=$lexicon $automata_wlp2c_txt > $automata_wlp2c
#compile the training file with only the concept for the LM

    farcompilestrings --symbols=$lexicon --unknown_symbol='<unk>' concepts_sentence.txt > tag_sentence.far
#train and test with the method specified in the smoothing method file and test the model with the testing file

    while read -r method
    do
      output="automata_"$method"_"$order".txt"
          evaluation="eval_"$method"_"$order".txt"
          folder=$method"_wlp2c"
          if [ ! -d "$folder" ]; then
            # Control will enter here if $DIRECTORY does not exists.
            mkdir $folder
            touch $folder/$output
          fi
> $folder/$output
        while read -r line
        do
#train the LM model

            ngramcount --order=$ngram_order --require_symbols=false tag_sentence.far > pos$method$order.cnt
            ngrammake --method=$method pos$method$order.cnt > pos$method$order.lm
#test the automaton with each sentence in the testing file

            echo "$line" | farcompilestrings --symbols=$lexicon --unknown_symbol='<unk>' --generate_keys=1 --keep_symbols | farextract --filename_suffix='.fst'
          fstcompose 1.fst $automata_wlp2c | fstcompose - pos$method$order.lm | fstrmepsilon | fstshortestpath | fsttopsort | fstprint --isymbols=$lexicon --osymbols=$lexicon >> $folder/$output
            echo " " >> $folder/$output
            ((sentence_counter++))
            echo "Line $sentence_counter: $line"
        done < $input_test
#compute the output and evaluate the result

        awk '{print $4}' < $folder/$output | awk -v RS= -v ORS="\n\n" "1" > tmp.txt
        awk '{print $2}' < $test_file > tmp_test.txt
        awk '{print $1"$"$3"$"$2}' < $test_features | awk '{if ($1=="$" || $1="$$") print""; else print;}' > tmp_test_feat.txt
        paste tmp_test_feat.txt tmp_test.txt tmp.txt > $folder/final_$method_$order.txt
        perl conlleval.pl -d "\t" < $folder/final_$method_$order.txt > $folder/$evaluation
        rm pos* 1.fst tmp*.txt
    done < $method_file