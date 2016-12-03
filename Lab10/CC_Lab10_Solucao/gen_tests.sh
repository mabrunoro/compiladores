#!/bin/bash

DATA=/home/zambon/Teaching/2016-2/CC/laboratorio/tests/
IN=$DATA/in10
OUT=$DATA/out10

EXE=./compiler

for infile in `ls $IN/*.lp`; do
    base=$(basename $infile)
    outfile=$OUT/${base/.lp/.out}
    $EXE < $infile > $outfile
done
