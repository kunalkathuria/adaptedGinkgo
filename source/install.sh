#!/usr/bin/env bash
ginkgoDir=$1
mkdir -p ../bin

cp process.R ${ginkgoDir}/scripts/
cp analyze.sh ${ginkgoDir}/scripts/
#cp ../resource/badBinList.ginkgo.original ${ginkgoDir}/genomes/hg19/badbins_variable_500000_101_bowtie.original
cp ${ginkgoDir}/genomes/hg19/badbins_variable_500000_101_bowtie ${ginkgoDir}/genomes/hg19/badbins_variable_500000_101_bowtie.original
cp ../resource/config ${ginkgoDir}/
if [ -f runAdaptedGinkgo ] 
then 
    mv runAdaptedGinkgo ../bin
fi
cp * ../bin
