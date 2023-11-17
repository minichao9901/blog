#! /bin/bash

#Replace script
#Example:
run_dir=`echo $(cd "$(dirname "$0")"; pwd)`
run_dir=`echo ${run_dir} | sed 's:/$::1'`

for file in `ls *.tcl`; do
	cat $file	|\
	sed "s:/.*/perc:${run_dir}:g"	|\
	sed "s:\$PERC_RULEDIR:${run_dir}:g" > ${file}.tmp
	mv ${file}.tmp $file
done

cd inc
for file in `ls *.tcl`; do
	cat $file	|\
	sed "s:/.*/perc:${run_dir}:g" |\
	sed "s:\$PERC_RULEDIR:${run_dir}:g" > ${file}.tmp
    mv ${file}.tmp $file
done
