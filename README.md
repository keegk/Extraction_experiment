# Extraction_experiment
This is the pipeline for analysing my MinION 'Extraction experiment' samples. 

Kit used: SQK-RBK004 (7 barcodes utilised).
Flow cell R9.4.1.
Run time=18hrs. 
Date of run: 22/02/2023.

Each barcode represents a separate DNA extraction method. For each extraction method, three aliquots of extracted DNA from Biological replicate 3 (BR3) were combined and ethanol precipitated to produce approx 100ng of DNA per extraction method (apart from barcode 6, MagATTract, which only had a starting DNA input of 25ng for library prep). 

**Barcode1**:FASTDNA

**Barcode2**: MagMAX

**Barcode3**: 3 peaks

**Barcode4**: Phenol-chloroform

**Barcode5**: UCP Pathogen kit

**Barcode6**: MagAttract

**Barcode7**:Genomic tip 100/G


**Step One**: *Rebasecalling the fast5 files from the sequencing run*

For each barcode/extraction method, the pass and fail fast5 files from the sequencing run after 18hrs were combined and then rebasecalled using super accuracy guppy basecaller (version 6.0.1), bash script titled 'super_basecalling_SQK_RBK004.sh'.

**Step Two**: Concatenating the 'pass' fastq files for each barcode

Following basecalling using super accuracy mode, each barcode's new 'pass' fastq files were concatenated into one using the script 'concat_fastq_SQK_RBK004.sh' setting the input path as the the pass directory for a specific rebasecalled barcode (e.g  /mnt/shared/scratch/kkeegan/personal/extraction_exp/Rebasecalled_trimmed_super_accuracy/barcode_1/pass/barcode01) and the output path being the same directory but with the file name specific to the barcode being concatenated (e.g /mnt/shared/scratch/kkeegan/personal/extraction_exp/Rebasecalled_trimmed_super_accuracy/barcode_1/pass/barcode01/concat_barcode1.fastq)

**Step three**: Cleaning up and converting fastq files to fasta

I check for any duplicated reads that may be present and I also convert this fastq file to fasta for BLAST ANALYSIS not using a bash script but by running an interactive job on the cluster (srsh command to initiate interactive job) and for trimming, use the package SeqKit (conda install -c bioconda seqkit) and running seqkit rmdup concat.fastq -s -o clean.fastq. Barcode1 = 29 duplicates removed. Barcode 2 = 9 duplicates removed. Barcode3 = 45 duplicates removed. Barcode 4 = 4 duplicates removed. Barcode 5 = 2 duplicates removed. Barcode 6 = 9duplicates removed. Barcode 7 = 0 duplicates removed. 

To convert these clean.fastq to clean.fasta, I simply use the package seqtk (conda install -c bioconda seqtk) and convert each barcodes concatenated cleaned fastq file to fasta using 'seqtk seq -a clean.fastq > cleaned_fasta.fasta'. Note the pass folder of barcode2 and barcode 5 has a directory called barcode1 which has three fastq files of total size 11KB. I did not include these fastq file in the final barcode 1 cleaned fasta file as im not 100% sure if it is barcode 1 (given that it is in the wrong barcode directory). 

**Step four**:BLAST each barcodes cleaned, concatenated fasta file

Done using blast_7.sh with database set to NCBI.

**Step five** Parsing the concatenated blast text files for loading in R.

Done using parse_v1_1.R run in parse.sh script.
