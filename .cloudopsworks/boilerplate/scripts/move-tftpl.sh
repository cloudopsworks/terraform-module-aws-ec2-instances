#!/bin/bash

find . -depth 1 -name "*.tftpl" | sed -e "s/\\.tftpl$//g" | xargs -I {} mv {}.tftpl {}.tf