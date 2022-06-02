#!/usr/bin/env bash

DIR=$1
THREADS=$2
cd $DIR

for i in $(ls ${DIR}/*.bam)
do
    echo $i
done | xargs -P $THREADS -n1 sh -c 'samtools view -h -b -F 1280 $1 | tee ${1}_nodup.bam | bedtools bamtobed -i - > ${1}.bed' sh

for i in $(ls ${DIR}/*.bam.bed)
do
    echo $i
done |  xargs -P $THREADS -I {} gzip {}

cd -
