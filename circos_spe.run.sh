#!/bin/sh

circos -conf data/circos/etc/circos_spe.conf
mv circos.png data/circos/circos_spe.png
mv circos.svg data/circos/circos_spe.svg
open data/circos/circos_spe.png
