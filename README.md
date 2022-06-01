# adaptedGinkgo
An adaptation of Ginkgo (Garvin, T et al, 2015: https://www.nature.com/articles/nmeth.3578) for single cell CNV calling
# Description
An adapted version of single-cell CNV caller Ginkgo (https://www.nature.com/articles/nmeth.3578) which includes new CNV calling thresholds (empirically established using a Gaussian Mixture Model), filtering of additional genomic outlier regions ("bins") and filtering of low-quality cells based on genome-wide MAD scores. Please refer to [manuscript]() for more details on methodology.
# Requirements
Unix-based OS with bash  
R (version 3.6 and higher)  
Python (version 2.6 and higher)  
Ginkgo installed (https://github.com/robertaboukhalil/ginkgo)  
samtools on the path ("which samtools")  
bedtools on the path  ("which bedtools") 
# Installation
Clone adaptedGinkgo to your local directory by running:
```
git clone https://github.com/kunalkathuria/adaptedGinkgo.git
```
Go to source code directory and run installation file:
```
cd /path_to_adaptedGinkgo/source
./install.sh
```
# Usage
Go to the "bin" directory to run:
```
cd /path_to_adaptedGinkgo/bin
./runAdaptedGinkgo
```
