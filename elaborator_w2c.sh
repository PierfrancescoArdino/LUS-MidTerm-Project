#! /bin/bash

################################################################################################################################
#INSTRUCTIONS:
#Run the script with the following parameters
#@param: train file
#@param: test file
#@param: smoothing method file
#@param: treshold cut off, if 0 no cut-off
#@param: ngram_order
# P(w | c) = C(w, c)/C(c)
################################################################################################################################

train_file=$1
test_file=$2
lexicon="lexicon_cut_off.txt"
input_test="test_no_concepts.txt"
lexicon_cutoff="lexicon_cut_off_test.txt"
automata="automata_cut_off.txt"
method_file=$3
treshold=$4
ngram_order=$5
sentence_counter=0
if [ "$#" -ne 5 ]; then
    echo "Illegal number of parameters"
    echo -e "Incorrect syntax, use the following one.\n-arg1=train_file \n-arg2=test_file \n-arg3=smoothing_method_file \n-arg4=threshold for cut-off (0-No cutoff) \n-arg5=ngram_order"

    exit 1
fi
#if treshold is 0 then  there will be no cut off
if [ "$treshold" == "0" ]; then
    lexicon="lexicon_no_cut_off.txt"
    automata="automata_no_cut_off.txt"
    lexicon_final="lexicon_no_cut_off_test.txt"
#generate lexicon for the Word2Concept transducer
    ./gen_lex.sh $1 $lexicon
#generate the automaton, the ngram file and the test file
    ./Word2Concept.py $1 $2 $4
#compile the automaton
    fstcompile --isymbols=$lexicon --osymbols=$lexicon $automata > automata.fst
#compile the training file with only the concept for the LM
    farcompilestrings --symbols=$lexicon --unknown_symbol='<unk>' concepts_sentence.txt > tag_sentence.far
#train and test with the method specified in the smoothing method file and test the model with the testing file
    while read -r method
    do
          output="automata_"$method"_"$order".txt"
          evaluation="eval_"$method"_"$order".txt"
          folder=$method"_w2c_no_cut_off"
          if [ ! -d "$folder" ]; then
            # Control will enter here if $DIRECTORY does not exists.
            mkdir $folder
            touch $folder/$output
          fi
        >$folder/$output
        while read -r line
        do
#train the LM model
            ngramcount --order=$ngram_order --require_symbols=false tag_sentence.far > pos$method$order.cnt
            ngrammake --method=$method pos$method$order.cnt > pos$method$order.lm
#test the automaton with each sentence in the testing file
            echo "$line" | farcompilestrings --symbols=$lexicon --unknown_symbol='<unk>' --generate_keys=1 --keep_symbols | farextract --filename_suffix='.fst'
          fstcompose 1.fst automata.fst | fstcompose - pos$method$order.lm | fstrmepsilon | fstshortestpath | fsttopsort | fstprint --isymbols=$lexicon --osymbols=$lexicon >> $folder/$output
            echo " " >> $folder/$output
            ((sentence_counter++))
            echo "Line $sentence_counter: $line"
        done < $input_test
#compute the output and evaluate the result
        awk '{print $4}' < $folder/$output | awk -v RS= -v ORS="\n\n" "1" > tmp.txt
        paste $test_file tmp.txt > $folder/final_$method_$order.txt
        perl conlleval.pl -d "\t" < $folder/final_$method_$order.txt > $folder/$evaluation
        rm pos* 1.fst tmp*
    done < $method_file
else
#generate lexicon for the Word2Concept transducer
    ./gen_lex.sh $1 $lexicon
#generate the automata, the ngram file and the test file

    ./Word2Concept.py $1 $2 $4
#compile the automata

    fstcompile --isymbols=$lexicon_cutoff --osymbols=$lexicon_cutoff $automata > automata.fst
#compile the training file with only the concept for the LM

    farcompilestrings --symbols=$lexicon_cutoff --unknown_symbol='<unk>' concepts_sentence.txt > tag_sentence.far
#train and the test with the method specified in the smoothing method file and test the model with the testing file

    while read -r method
    do
                output="automata_"$method"_"$order".txt"
          evaluation="eval_"$method"_"$order".txt"
          folder=$method"_w2c_cut_off"
          if [ ! -d "$folder" ]; then
            # Control will enter here if $DIRECTORY does not exists.
            mkdir $folder
            touch $folder/$output
          fi
          >$folder/$output
        while read -r line
        do
        #train the LM model

            ngramcount --order=$ngram_order --require_symbols=false tag_sentence.far > pos$method$order.cnt
            ngrammake --method=$method pos$method$order.cnt > pos$method$order.lm
#test the automaton with each sentence in the testing file

            echo "$line" | farcompilestrings --symbols=$lexicon_cutoff --unknown_symbol='<unk>' --generate_keys=1 --keep_symbols | farextract --filename_suffix='.fst'
          fstcompose 1.fst automata.fst | fstcompose - pos$method$order.lm | fstrmepsilon | fstshortestpath | fsttopsort | fstprint --isymbols=$lexicon_cutoff --osymbols=$lexicon_cutoff >> $folder/$output
            echo " " >> $folder/$output
            ((sentence_counter++))
            echo "Line $sentence_counter: $line"
        done < $input_test
#compute the output and evaluate the result

        awk '{print $4}' < $folder/$output | awk -v RS= -v ORS="\n\n" "1" > tmp.txt
        paste $test_file tmp.txt > $folder/final_$method_$order.txt
        perl conlleval.pl -d "\t" < $folder/final_$method_$order.txt > $folder/$evaluation
        rm pos* 1.fst tmp.txt
    done < $method_file
fi
