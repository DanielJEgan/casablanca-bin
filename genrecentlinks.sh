#!/bin/bash
set -u
set -e

pushd /Volumes/Data1/Recent


SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
for f in `find /Volumes/Data1/TV -type f  -exec /usr/bin/stat -f '%Sm %N'  -t '%F' {} \;|grep -v '/.DS_Store'|sort|sed -E 's,(.*/.*/Season.*)/.*,\1,'|sed -E 's,( Movies/.+)/.*,\1,'|sort -u`
do
  linkname=`echo $f|sed 's,.*/Volumes/Data1/,,'|sed 's,/, ~ ,g'`
  ln -sf "$f" "$linkname"
done
IFS=$SAVEIFS


popd
