#!/bin/bash

submodulename=${1?usage $0 submodule submodulepath}
submodulepath=${2-$submodulename}

# Remove config entries:
git config -f .git/config --remove-section submodule.$submodulename
git config -f .gitmodules --remove-section submodule.$submodulename

# Remove directory from index:
git rm --cached $submodulepath

#Commit
git add .gitmodules
git commit -m "remove $submodulename"

#Delete unused files:
rm -rf $submodulepath
rm -rf .git/modules/$submodulename

#Commit
git add $submodulepath
git commit -m "remove $submodulename"
