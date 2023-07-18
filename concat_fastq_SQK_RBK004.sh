#!/bin/bash
#SBATCH --mail-user=karen.keegan@moredun.ac.uk
#SBATCH --cpus-per-task=12
#SBATCH --mail-type=END,FAIL

dir=$1
out=$2


fastq=$(find $dir -type f -name "*.fastq")

for i in $fastq ;do
   xargs cat $i >> $out
done
