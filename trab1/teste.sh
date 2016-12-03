#!/bin/bash
file=$1
if [ -f $file ] && [ -d "in" ] && [ -d "out" ]
then
	echo "Teste com executável: $file"
	for i in in/*.cm
	do
		t=$(echo $i | cut -d'/' -f2 | cut -d'.' -f1)
		t="out/"$t".out"
		echo "Comparando saída de $i com $t"
		./$1 < $i | diff $t -
	done
else
	echo "Não existe $1 ou a pasta 'in' ou a pasta 'out'"
fi