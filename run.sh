#!/bin/bash

cd `dirname $0`

echo "Algorithms: Standard Zielonka / Warsaw QPT Zielonka / Liverpool QPT Zielonka"
echo "Runnning time is in seconds"
echo "For Zielonka algorithms we also output the number of iterations"

timeout=900 #seconds

for f in `cd tests; ls *.pg | sort -k 1,1 -k 2,2 -k 3,3g -k 4,4g -t-` 
do
    echo -n "$f"
    for mode in zlkpp-std zlkpp-waw zlkpp-liv; do
        LOGFILE=`mktemp` || exit 1
        oink/build/oink tests/$f --$mode --no-loops --no-wcwc -t -v -z $timeout > $LOGFILE
        if [ $? -ne 0 ]; then
            if grep 'terminated due to timeout' $LOGFILE >/dev/null; then
	        IT='-'
        	RT=">$timeout"
       	    else
       	        echo; echo "ERROR while solving!!!"
       	        exit 1 
       	    fi
        else
            IT=`grep "iterations" $LOGFILE | cut -dh -f2 | cut -d' ' -f2`
            RT=`grep "solving took" $LOGFILE | cut -dk -f2 | cut -d' ' -f2`
        fi
        rm -f $LOGFILE
        echo -n ";$RT;$IT"
    done
    echo
done
