#!/bin/sh

circos -conf data/circos/etc/circos.conf
mv circos.png data/circos/
mv circos.svg data/circos/
open data/circos/circos.png
