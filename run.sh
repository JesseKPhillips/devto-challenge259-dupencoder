dmd -unittest -run dupenc.d
ldc2 -O dupenc.d
echo LDC
rm *.dat
./dupenc
gnuplot plot.gnuplot
