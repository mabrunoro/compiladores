#!/bin/bash

DATA=/home/zambon/Teaching/2016-2/CC/laboratorio/tests/
IN=$DATA/in
OUT=$DATA/out2

EXE=./scanner

for infile in `ls $IN/*.tny`; do
    base=$(basename $infile)
    outfile=$OUT/${base/.tny/.out}
    $EXE < $infile > $outfile
done
