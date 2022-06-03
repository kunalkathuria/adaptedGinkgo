# adaptedGinkgo
An adaptation of Ginkgo (Garvin, T et al, 2015: https://www.nature.com/articles/nmeth.3578) for single cell CNV calling
# Description
An adapted version of single-cell CNV caller Ginkgo (https://www.nature.com/articles/nmeth.3578) which includes new CNV calling thresholds (empirically established using a Gaussian Mixture Model), filtering of additional genomic outlier regions ("bins") and filtering of low-quality cells based on genome-wide MAD scores. Please refer to [manuscript]() for more details on methodology.
# Requirements
Unix-based OS with bash  
R (version 3.6 and higher) including libraries "dplyr" and "tidyr"  
Python (version 2.6 and higher)  
Ginkgo installed with all R dependencies (https://github.com/robertaboukhalil/ginkgo)  
samtools on the path ("which samtools")  
bedtools on the path  ("which bedtools") 
# Installation
Clone adaptedGinkgo to your local directory by running:
```
git clone https://github.com/kunalkathuria/adaptedGinkgo.git
```
Go to source code directory and run installation file with the first argument being the full local path to the Ginkgo directory:
```
cd /path_to_adaptedGinkgo/source
./install.sh /path_to_Ginkgo/
```
# Usage
Go to the "bin" directory to run with listed arguments:
```
cd /path_to_adaptedGinkgo/bin
./runAdaptedGinkgo [path_to_single_cell_BAM_files] [sample_name] [work_dir] [full_path_to_Ginkgo_master] 
```
# Results
1. The CNV calls for all cells should then be found in /path_to_Ginkgo/uploads/sample_name_runs/run_2/CNV1
2. The genome-wide MAD scores for all cells would be found in /path_to_Ginkgo/uploads/sample_name_runs/run_2/genomewideMAD.allCells.txt, which can be used to filter out cells with high MAD scores as per some (perhaps data-specific) criteria.

