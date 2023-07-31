#!/bin/bash
#SBATCH --cpus-per-task=8
#SBATCH --mail-user=karen.keegan@moredun.ac.uk
#SBATCH --mail-type=END,FAIL


source activate R_env

Rscript parse_v1_1.R /mnt/shared/scratch/kkeegan/personal/extraction_exp/super_accuracy_BLAST/Barcode_1/barcode_1.txt.gz /mnt/shared/scratch/kkeegan/personal/extraction_exp/super_accuracy_BLAST/Barcode_1/barcode_1_parsed.txt 90 1E-12 5 200
