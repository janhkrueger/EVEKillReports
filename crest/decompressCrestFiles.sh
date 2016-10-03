#!/bin/bash
# Decompressing previously with brotli stored json files
# JHK, 20161003

for f in *.json.bro; do
    fname=${f%.json.bro}
    /var/brotli/tools/bro --decompress --input "${fname}".json.bro --output "${fname}".json
done
