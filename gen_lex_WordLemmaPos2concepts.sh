#! /bin/bash
doc=$1
lemma=$2
output=$3
rm $3
awk '{print $2}' $1 > tmp.txt
awk '{print $3}' $2 > tmp1.txt
awk '{print $2}' $2 > tmp2.txt
awk '{print $1}' $1 > tmp3.txt
paste -d $ tmp3.txt tmp1.txt tmp2.txt >> tmp.txt
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
rm tmp*