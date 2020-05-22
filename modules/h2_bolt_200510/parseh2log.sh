in=$1

#in="h2results/h2_bolt_ilamax_ilamin.log"

tail -n 10 ${in} |  grep -A 3 'Variance component 1:  "modelSnps"' | \
  tail -3 | perl -ane 's/.+:|[()]//g; s/^\s//; print $_' > tmp