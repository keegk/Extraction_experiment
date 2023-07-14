#!/bin/bash

#SBATCH --job-name="super_rebasecalling_fast5_files"
#SBATCH --mail-user=karen.keegan@moredun.ac.uk
#SBATCH --mail-type=END,FAIL
#SBATCH --cpus-per-task=32
#SBATCH --partition=long
#SBATCH --mem=50G
export PATH=/home/kkeegan/projects/jhi/bioss/kkeegan_onttestdata/ont-guppy-cpu/bin:$PATH
echo "Input path is $1"
echo "Save path is $2"
echo "number of threads is $3"

guppy_basecaller --input_path $1 --save_path $2 --recursive --config $3 --barcode_kits "SQK-RBK004" --trim_barcodes --cpu_threads_per_caller $4 --num_callers $5  