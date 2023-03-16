#!/bin/bash

for i in $(find . -name '.git'); do
    d=${i%.git} 
    cd $d 
    echo $d 
    git checkout master
    git pull 
    cd - >/dev/null
done