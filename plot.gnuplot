set term png
set output "graph.png"
plot 'haskel.dat' with lines , \
     'haskel2.dat' with lines , \
     'php.dat' with lines, \
     'pointer.dat' with lines
