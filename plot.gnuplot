set term png
set output "graph.png"
plot 'haskel.dat' with lines , \
     'php.dat' with lines, \
     'go.dat' with lines, \
     'pointer.dat' with lines
