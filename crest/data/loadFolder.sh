#!/bin/bash
# loading all cresthashes of a year and then archiving the entire files
# JHK, 20161003

for f in 2015/*.json; do
    ./loadCrestHashes.py $f
done
tar cfv 2015.tar 2015/
zstd --ultra -22 -r 2015.tar
rm 2015.tar
rm -R 2015/