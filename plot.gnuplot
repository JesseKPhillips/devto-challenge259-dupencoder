set term png
set output "graph.png"
set xlabel "Character Count"
set ylabel "Time (ms)"
plot 'haskell.dat' with lines , \
     'php.dat' with lines, \
     'go.dat' with lines, \
     'go2.dat' with lines, \
     'pointer.dat' with lines, \
