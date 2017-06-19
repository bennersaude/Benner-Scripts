#!/bin/bash

my_dir="$(dirname "$0")"
source "$my_dir/configs.sh"

DLLS=''
if [[ -z "$1" ]]; then
    echo "No dlls/projects found. Try passing as the first parameter.";
    exit 1;
fi
if [[ "$1" == *dll ]]; then
    DLLS="$1";
else
    DLLS="$(find **/bin/$1 -iname '*Tests.dll' -o -iname '*Test.dll' -o -iname '*TesteUnitario.dll' | tr '\n' ' ')";
fi

echo "Running tests..."

start_time=`date +%s`
TRESULT="$("$NUNIT_EXE" $DLLS //nologo)"
ECODE="$(echo $?)"
end_time=`date +%s`

if [[ $ECODE -eq 0 ]]; then
    echo "$TRESULT" | awk '!/ Ignored : / && !/ NotRunnable : /'
else
    echo "$TRESULT" | grep -oP '^[0-9]+\)[^\(]*' | awk '!/ Ignored : / && !/ NotRunnable : /'
fi

echo "Tests finished in "`expr $end_time - $start_time`" s with exit code $ECODE"

exit "$ECODE"
