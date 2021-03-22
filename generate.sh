#!/bin/bash

cd `dirname $0`
mkdir -p tests
cd tests

DIR=../oink/build
RNGAME=$DIR/rngame
STGAME=$DIR/stgame
CORE=$DIR/counter_core
DP=$DIR/counter_dp
M=$DIR/counter_m
QPT=$DIR/counter_qpt
RR=$DIR/counter_rr
TC=$DIR/tc
TCP=$DIR/tc+

echo -n "Generating tests in "; pwd

for file in $RNGAME $STGAME; do
	if [ ! -x $file ]; then
		echo "ERROR! File $file is missing!!"
		exit 1
	fi
done

for n in {1..78}; do $M $n >family-m-$n.pg; done

for seed in {1..20}; do
	for size in 100 200 500; do
		# random games of outdegree <= 2
		$RNGAME $size $size 1 2 $seed >random-lowdegree-$size-$seed.pg
	done
	for size in 100 200 500 1000 2000; do
		$RNGAME $size $size 1 $size $seed >random-highdegree-$size-$seed.pg
	done
done

echo "DONE!"
