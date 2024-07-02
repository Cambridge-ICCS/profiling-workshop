#!/usr/bin/env bash

rm -r score-p-simple*

# Run the "Normal" Binary
#========================================================
mpirun -n 2 simple.exe

# Run the Instrumented Binary
#========================================================
mpirun -n 2 simple-inst.exe
mv scorep-* score-p-simple-inst

# Run the Instrumented Binary with perf hardware counters
#========================================================
export SCOREP_METRIC_PERF='cache-misses:u'

mpirun -n 2 simple-inst.exe
mv scorep-* score-p-simple-inst-perf
