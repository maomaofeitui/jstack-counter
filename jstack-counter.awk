BEGIN {
  newThread=0;
  }

/^$/ {newThread=1; printf $0;}

 /pl\.zxspeccy|oracle\.jdbc|com\.mchange\.v2/ && /at/ {
  if(newThread == 1) {
  sub(/\(.+/, "", $2);
	methodsCounters[$2] = methodsCounters[$2] + 1;
	newThread = 0;
  }
}

END {
 print "Interesting threads counts:";
 n = asorti(methodsCounters, sorted)
 for(method in methodsCounters) {print method, methodsCounters[method]}
}
