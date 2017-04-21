#! /bin/bash
doc=$1
lemma=$2
output=$3
rm $3
awk '{print $2}' $1 > tmp.txt
awk '{print $2}' $2 >> tmp.txt
arr=($(awk '{print $1}' tmp.txt | sort | uniq))
cont=0
echo -e "<eps>\t$cont" >> $output
((cont++))
for token in ${arr[@]}
do
  echo -e "$token\t$cont" >> $output
  ((cont++))
done
echo -e "<unk>\t$cont" >> $output
