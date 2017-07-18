#!/bin/bash

branchEncontrada=$(gcheckouts.sh | grep -iP "$1" | tac | awk '!x[$0]++' | head -5 | tac)

array=($branchEncontrada)
arraylength=${#array[@]}
for (( i=0; i<${arraylength}; i++ ));
do
  count=`expr $arraylength - $i`
  echo $count") " ${array[$i]}
done

read -p "Number? " -n 1 -r
echo

if [[ $REPLY =~ ^[1]$ ]]; then
    echo "$branchEncontrada" | tail -1 | xargs git checkout
elif [[ $REPLY =~ ^[2]$ ]]; then
    echo "$branchEncontrada" | tail -2 | head -1 | xargs git checkout
elif [[ $REPLY =~ ^[3]$ ]]; then
    echo "$branchEncontrada" | tail -3 | head -1 | xargs git checkout
elif [[ $REPLY =~ ^[4]$ ]]; then
    echo "$branchEncontrada" | tail -4 | head -1 | xargs git checkout
elif [[ $REPLY =~ ^[5]$ ]]; then
    echo "$branchEncontrada" | head -1 | xargs git checkout
fi
