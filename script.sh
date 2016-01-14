#! /bin/bash

declare -a create
declare -a remove
declare -a iterations=(1 10 100 1000 10000 20000 30000 35000)

unique="`mktemp -u XXXXX`"
script="/tmp/idontknow-${unique}.sh"

cat <<EOF > "${script}"
#! /bin/bash

eval touch foo{1.."\$1"}
EOF
chmod 700 "${script}"

function fcreate () {
   exec 2>&1
   /usr/bin/time --format=%E "${script}" "$1"
}

function fremove () {
   exec 2>&1
   /usr/bin/time --format=%E ssh 151.155.232.124 "cd `pwd`; rm -f foo*"
}

echo ------------------------------------
echo "| # files  | create #s | remove #s |"
echo ------------------------------------
for ((x=0; x < ${#iterations[*]} ; x++))
do
   create[$x]="`fcreate ${iterations[$x]}`"
   remove[$x]="`fremove`"
   printf "| %8d | %9s | %9s |\n" ${iterations[$x]} ${create[$x]} ${remove[$x]}
done

rm "${script}"
