dmd -unittest -run dupenc.d
echo DMD
dmd -O -inline -run dupenc.d
gdc-9 -O3 dupenc.d
echo GDC
./a.out
ldc2 -O dupenc.d
echo LDC
./dupenc
