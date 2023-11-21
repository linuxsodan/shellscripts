#!/bin/bash -e

c=5000

rm -rf prop{1..3}
mkdir -p prop{1..3}

echo "================================="
echo "提案1: echo -n ''"
echo "================================="

cd prop1

cat << PROP > prop.sh
for i in {1..$c}
do
echo -n '' > \$i
done
PROP

time bash prop.sh

cd ..

echo "================================="
echo "提案2: touch"
echo "================================="

cd prop2

cat << PROP > prop.sh
for i in {1..$c}
do
touch \$i
done
PROP

time bash prop.sh

cd ..

echo "================================="
echo "提案3: touch １回で"
echo "================================="

cd prop3

cat << PROP > prop.sh
touch {1..$c}
PROP

time bash prop.sh

cd ..

set -x
ls -1U prop1/ | wc -l
ls -1U prop2/ | wc -l
ls -1U prop3/ | wc -l

time /bin/ls -1  prop1/ > /dev/null
time /bin/ls -U  prop1/ > /dev/null
time /bin/ls prop1/ > /dev/null



rm -r prop{1..3}
