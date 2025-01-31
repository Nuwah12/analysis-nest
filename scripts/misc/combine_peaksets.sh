#!/bin/bash

# Script for merging two .BED files
# Noah Burget
# 1/31/25

if [ $# -lt 2 ]; then
	echo "Usage: $0 <BED1> <BED2> [<BED3> ...]"
	exit 1
fi

# Make name for output file & basic checks
result=""
for n in "$@"; do
	# Check if files ecist
	if [ ! -f ${n} ]; then
		echo "Could not find file $n"
		exit 1
	fi
	result+="$(basename ${n} .bed)"
	# Check if this is the last argument; if not, add an underscore for naming aesthetics
	if [ "${n}" != "${@: -1}" ]; then
        	result+="_"
    	fi
done

result+=".bed"

# cat files together
cat $@ > $result

# sort the catted file
sort -k1,1 -k2,2n $result > "${result}.sorted"

# bedtools merge the sorted file
bedtools merge -i "${result}.sorted" > "$(basename $result .bed.sorted).bed"

# cleanup
rm ${result} "${result}.sorted"

echo $result
