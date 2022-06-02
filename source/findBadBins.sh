#!/usr/bin/env bash
varCutoff=1000 # no cutoff for cell copy number variance, can change if desired 
dir=$1 #$(pwd -P)
sampleTag=$2
ginkgoTag=$3 #Ginkgo run number
origBadBins=$4
ginkgoDir=$5
ginkgoDirU=${5}/uploads
bin=$6

mkdir -p ${dir}/badBinAnalysis_${sampleTag}_${ginkgoTag}
rm -f ${dir}/badBinAnalysis_${sampleTag}_${ginkgoTag}/*

cd ${dir}/badBinAnalysis_${sampleTag}_${ginkgoTag}
i=$sampleTag
# for advanced users, can add multiple individuals here to calculated outlier bins for aggregated bins
#indivs=$(cat $fileWithListOfSamples)
#for i in $indivs
#do
cat ${ginkgoDirU}/${i}_runs/run_${ginkgoTag}/binNormalCNs.txt >> var_temp
#done

mv var_temp binNormalCNs.all.txt
cat binNormalCNs.all.txt | grep variance | cut -d " " -f5,7 > cellSegVariances.txt 

module load conda_R/3.6
python ${bin}/prepMedianBinCNs.py ${dir}/badBinAnalysis_${sampleTag}_${ginkgoTag}/cellSegVariances.txt ${dir}/badBinAnalysis_${sampleTag}_${ginkgoTag}/binNormalCNs.all.txt $varCutoff ${dir}/badBinAnalysis_${sampleTag}_${ginkgoTag}
python ${bin}/writeMedianBinVals.py ${dir}/badBinAnalysis_${sampleTag}_${ginkgoTag}/binCNMatrix.txt ~/ginkgo/genomes/hg19/variable_500000_101_bowtie $origBadBins ${dir}/badBinAnalysis_${sampleTag}_${ginkgoTag}
Rscript ${bin}/findBadBins.R ${dir}/badBinAnalysis_${sampleTag}_${ginkgoTag}/medianBins.autosomes.txt autosomal ${sampleTag}_${i}_${ginkgoTag}
mv outlierBins.txt outlierBins.autosomes.txt
wc -l outlierBins.autosomes.txt
mv median_bin_values.png median_bin_values.autosomes.png
module unload conda_R/3.6

#orig bad bin here is okay, to feed to Ginkgo
cat outlierBins.autosomes.txt ${ginkgoDir}/genomes/hg19/badbins_variable_500000_101_bowtie | sort -n > badbins_variable_500000_101_bowtie.new
#in case empty whitespace written by findBadBins.R script
sed -i '/^[[:space:]]*$/d' badbins_variable_500000_101_bowtie.new
#just a check, should be 0
echo Number of duplicate bins
cat badbins_variable_500000_101_bowtie.new | uniq -d | wc -l

#feed to ginkgo
cp badbins_variable_500000_101_bowtie.new ${ginkgoDir}/genomes/hg19/badbins_variable_500000_101_bowtie
cd -
