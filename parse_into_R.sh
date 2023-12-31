#!/bin/bash
#SBATCH --cpus-per-task=4
#SBATCH --mail-user=karen.keegan@moredun.ac.uk
#SBATCH --mail-type=END,FAIL


source activate R_env

Rscript parsefilter_blasttable.R /mnt/shared/scratch/kkeegan/personal/extraction_exp/super_accuracy_BLAST/Barcode_1/barcode_1.txt.gz /mnt/shared/scratch/kkeegan/personal/extraction_exp/super_accuracy_BLAST/Barcode_1/barcode_1_parsed.txt 90 1E-12 5 200
