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

for n in {1..21}; do $CORE $n >family-core-$n.pg; done
for n in {1..50}; do $DP $n >family-dp-$n.pg; done
for n in {1..39}; do $QPT $n >family-qpt-$n.pg; done
for n in {2..40}; do $RR $n >family-rr-$n.pg; done
for n in {1..18}; do $TC $n >family-tc-$n.pg; done
for n in {1..18}; do $TCP $n >family-tcp-$n.pg; done

for seed in {21..80}; do
	for size in 200; do
		$RNGAME $size $size 1 $size $seed >random-highdegree-$size-$seed.pg
	done
done

for seed in {1..20}; do
	for size in 100 200 500 1000 2000; do
		# games with indegree and outdegree <= 4
		seed2=0
		while true; do
			$STGAME $size 1 4 1 4 $((seed2+seed)) >steady-$size-$seed.pg
			if grep ' ;' steady-$size-$seed.pg >/dev/null; then
				# sometimes the generated game is invalid: contains nodes without successors
				# then we increase the seed by 100 and we try again
				seed2=$((seed2+100))
			else
				break
			fi
		done
	done
done

echo "DONE!"
