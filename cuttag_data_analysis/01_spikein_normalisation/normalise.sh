#!/bin/bash
    
## Author(s): Yinxiu Zhan
## Contact: yinxiu.zhan@fmi.ch
## This software is distributed without any guarantee under the terms of the GNU General
## Public License, either Version 2, June 1991 or Version 3, June 2007.


function usage {
    echo -e "usage : $(basename $0) -r reference -q query [-g genomeid] [-h]"
    echo -e "Use option -h|--help for more information"
}

function help {
    usage;
    echo 
    echo "---------------"
    echo "OPTIONS"
    echo
    echo "   -r|--reference REFERENCE : reference bam file against which you want to normalise the query."
    echo "   -q|--query QUERY: query bam file to normalise"
    echo "   [-g|--genomeid GENOMEID] : id the of spikein genome, default: J02459.1_spikein"
    echo "   [-h|--help]: help"
    exit;
}


# Transform long options to short ones
for arg in "$@"; do
  shift
  case "$arg" in
      "--reference") set -- "$@" "-r" ;;
      "--query")   set -- "$@" "-q" ;;
      "--genomeid")   set -- "$@" "-g" ;;
       *)        set -- "$@" "$arg"
  esac
done

REF=""
QUERY=""
GENOMEID="J02459.1_spikein"

while getopts ":r:q:g:h" OPT
do
    case $OPT in
        r) REF=$OPTARG;;
        q) QUERY=$OPTARG;;
        g) GENOMEID=$OPTARG;;
        h) help ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            usage
            exit 1
            ;;
    esac
done

if [ $# -lt 4 ]
then
    usage
    exit
fi


if ! [ -f $REF ]; then
	echo "$REF reference file does not exist"
	exit
fi

if ! [ -f $QUERY ]; then
        echo "$QUERY query file does not exist"
        exit
fi

if [ -f stats_mapped_reads.txt ]; then
	rm stats_mapped_reads.txt
fi

# extract normalisation factor
file=$REF
samtools view -o out.sam $file
rescaling=`awk '{if($3=="J02459.1_spikein") s++; else g++}END{print g/s}' out.sam`
for file in $REF $QUERY; do
	samtools view -o out.sam $file
	awk '{if($3=="J02459.1_spikein") s++; else g++}END{print "'"$file"'", g, s, g/s/"'"$rescaling"'"}' out.sam >> stats_mapped_reads.txt
done



# normalise using bamCoverage
for file in $REF  $QUERY; do
        scaling_factor=`cat stats_mapped_reads.txt | grep $file | awk '{print $4}'`
        name=`echo $file | sed 's/\.bam//g'`
        bamCoverage  --scaleFactor $scaling_factor  --numberOfProcessors 5 --smoothLength 900 --binSize 300 --centerReads -b $file  -o $name.bw 

done
