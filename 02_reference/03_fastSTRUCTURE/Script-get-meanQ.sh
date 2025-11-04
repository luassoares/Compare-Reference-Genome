#!/bin/bash

for file in `cat list-result-alti`; do
cd RESULT_${file}.str
cp fS_run_K.3.meanQ ../RESULTS-BESTK-ALL/${file}.fS_run_K.3.meanQ
cd ../
done

for file in `cat list-result-grp`; do
cd RESULT_${file}.str
cp fS_run_K.5.meanQ ../RESULTS-BESTK-ALL/${file}.fS_run_K.5.meanQ
cd ../
done

for file in `cat list-result-phylo`; do
cd RESULT_${file}.str
cp fS_run_K.5.meanQ ../RESULTS-BESTK-ALL/${file}.fS_run_K.5.meanQ
cd ../
done
