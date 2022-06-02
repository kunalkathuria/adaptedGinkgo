#!/usr/bin/bash

sampleTag=$1
sNum=$2
undoSD=$3
info=$4
ginkgoDir=$5
ginkgoDirU=${5}/uploads

echo Processing sample $sampleTag
sNumPrev=$(( $sNum - 1 ))

DIR_DEST=${ginkgoDirU}/${sampleTag}_runs/run_${sNum}
DIR_BAM=${ginkgoDirU}/${sampleTag}_runs/run_0
mkdir -p $DIR_DEST
if [ $sNum -eq 1 ]
then
    ./bam2BedZip.sh ${DIR_BAM} 1
    mv ${DIR_BAM}/*.bed.gz $DIR_DEST
else
    # save space by copying bed files from previous run
    echo $sNumPrev is sNumPrev
    nGZ=$(ls ${ginkgoDirU}/${sampleTag}_runs/run_${sNumPrev}/*.gz | wc -l)
    if [ $nGZ -lt 3 ]
    then
        echo Insufficient number of bed files
        continue
    else
        rm -f -r $DIR_DEST/*
        mv ${ginkgoDirU}/${sampleTag}_runs/run_${sNumPrev}/*.gz $DIR_DEST
    fi
fi

# write list of files for Ginkgo, copy config file
cd $DIR_DEST
ls *.bam.bed.gz > list
cp ${ginkgoDir}/config .
echo run ${sNum}:${info} > info
cd -

# run Gg
cd $ginkgoDir
./scripts/analyze.sh ${sampleTag}_runs/run_${sNum} $undoSD
cd -

echo done with sample $sampleTag
