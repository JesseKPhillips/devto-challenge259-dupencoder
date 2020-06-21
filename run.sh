dmd -unittest -run dupenc.d
ldc2 -O dupenc.d
echo LDC
./dupenc
