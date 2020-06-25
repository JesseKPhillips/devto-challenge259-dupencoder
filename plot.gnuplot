set term png
set output "graph.png"
set xlabel "Character Count"
set ylabel "Time (ms)"
plot 'haskell.dat' with lines , \
     'php.dat' with lines, \
     'go.dat' with lines, \
     'pointer.dat' with lines, \
     'pointer2.dat' with lines
