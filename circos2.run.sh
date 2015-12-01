#!/bin/sh

circos -conf data/circos/etc/circos2.conf
mv circos.png data/circos/circos2.png
mv circos.svg data/circos/circos2.svg
open data/circos/circos2.png
