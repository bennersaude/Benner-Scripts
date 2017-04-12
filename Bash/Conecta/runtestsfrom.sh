#!/bin/bash
if [[ -z "$1" ]]; then
    echo "No dlls/projects found. Try passing as the first parameter.";
    exit 1;
fi

echo "Running tests..."

start_time=`date +%s`
TRESULT="$(/c/Program\ Files\ \(x86\)/NUnit\ 2.6.4/bin/nunit-console $1 //nologo)"
end_time=`date +%s`
ECODE="$(echo $?)"

if [[ $ECODE -eq 0 ]]; then
	echo "$TRESULT"
fi

echo "$TRESULT" | grep -oP '^[0-9]+\)[^\(]*'

echo "Tests finished in "`expr $end_time - $start_time`" s with exit code $ECODE"

exit "$ECODE"
