#! /bin/bash

################################################################################################################################
#INSTRUCTIONS:
#Run the script with the following parameters
#@param: train file
#@param: test file
#@param: smoothing method file
#@param: ngram_order
# P(w | c) = C(w, c)/C(c)
################################################################################################################################

train_file=$1
test_file=$2
lexicon="lexicon_w2c_without_O.txt"
input_test="test_no_concepts.txt"
automata_txt="automata_w2c_without_O.txt"
automata_fst="automata_w2c_without_O.fst"
method_file=$3
ngram_order=$4
sentence_counter=0
if [ "$#" -ne 4 ]; then
    echo "Illegal number of parameters"
    echo -e "Incorrect syntax, use the following one.\n-arg1=train_file \n-arg2=test_file \n-arg3=smoothing_method_file \n-arg4=ngram_order"
    exit 1
fi
    ./gen_lex_w2c_without_O.sh $1 $lexicon
    ./Word2Concept_Without_O.py $1 $2
    fstcompile --isymbols=$lexicon --osymbols=$lexicon $automata_txt > $automata_fst
    farcompilestrings --symbols=$lexicon --unknown_symbol='<unk>' concepts_sentence.txt > tag_sentence.far
    while read -r method
    do
          output="automata_"$method"_"$order".txt"
          evaluation="eval_"$method"_"$order".txt"
          folder=$method"_w2c_without_O"
          if [ ! -d "$folder" ]; then
            # Control will enter here if $DIRECTORY does not exists.
            mkdir $folder
            touch $folder/$output
          fi
> $folder/$output
        while read -r line
        do
            ngramcount --order=$ngram_order --require_symbols=false tag_sentence.far > pos$method$order.cnt
            ngrammake --method=$method pos$method$order.cnt > pos$method$order.lm
            echo "$line" | farcompilestrings --symbols=$lexicon --unknown_symbol='<unk>' --generate_keys=1 --keep_symbols | farextract --filename_suffix='.fst'
          fstcompose 1.fst $automata_fst | fstcompose - pos$method$order.lm | fstrmepsilon | fstshortestpath | fsttopsort | fstprint --isymbols=$lexicon --osymbols=$lexicon >> $folder/$output
            echo " " >> $folder/$output
            ((sentence_counter++))
            echo "Line $sentence_counter: $line"
        done < $input_test
        awk '{print $4}' < $folder/$output | awk -v RS= -v ORS="\n\n" "1" > tmp.txt
        ./compute_output.py tmp.txt tmp1.txt concept_list.txt
        paste NLSPARQL.test.data tmp1.txt > $folder/final_$method_$order.txt
        perl conlleval.pl -d "\t" < $folder/final_$method_$order.txt > $folder/$evaluation
        rm pos* 1.fst tmp* concept_list*
    done < $method_file
