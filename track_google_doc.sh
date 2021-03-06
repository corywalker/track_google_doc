#!/usr/bin/env bash

echo ----------------------------------------------
date

rm -r doc.zip images *.html README.md
mkdir /tmp/tracktmp
rm -rf /tmp/tracktmp/*

# Now fail on errors
set -e

thetime=$(date)
./get_doc.sh > doc.zip
unzip doc.zip
rm doc.zip
html2text --ignore-links *.html > README.md
mv *.html /tmp/tracktmp/
git checkout *.html

if [[ `git status --porcelain` ]]; then
    # changes
    echo "CHANGES!"
    mv /tmp/tracktmp/*.html .
    # The true is to avoid early exit
    tidy -iqm *.html || true
    git add -A
    git commit -m "Revision as of $thetime"
    git push
else
    # no changes
    echo "NO CHANGES!"
fi
echo ----------------------------------------------
