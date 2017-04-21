#! /bin/bash
doc=$1
output=$2
rm $2
awk '{print $1}' $1 > tmp.txt
awk '{print $2}' $1 >> tmp.txt
arr=($(awk '{print $1}' tmp.txt | sort | uniq))
cont=0
echo -e "<eps>\t$cont" >> $output
((cont++))
for token in ${arr[@]}
do
  echo -e "$token\t$cont" >> $output
  ((cont++))
done
((cont++))
echo -e "<unk>\t$cont" >> $output
