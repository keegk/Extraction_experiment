# Extraction_experiment Background
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

**Methodology**

**Step 1**: *Rebasecalling the fast5 files from the sequencing run*

For each barcode/extraction method, the pass and fail fast5 files from the sequencing run after 18hrs were combined and then rebasecalled using super accuracy guppy basecaller (version 6.0.1), bash script titled 'super_basecalling_SQK_RBK004.sh'.

**Step 1.1**: *QC of reads based on the summary sequencing files"

Read QC statistics were generated from the summary sequencing files from each of the barcodes (guppy basecalling using version 6.0.1 outputs a unique summary sequencing file for each barcode). The R notebooks "<extraction method>_summary_seq.Rmd" are notebooks that detail how the read QC statistics (e.g no. of reads, mean Q score etc) were generated. There are seven of these R notebooks (one for each extraction method) with the only difference between them being the name change to the extraction method being examined and filtering of the correct barcode that corresponds to this extraction method.



**Step 2**: Concatenating the 'pass' fastq files for each barcode

Following basecalling using super accuracy mode, each barcode's new 'pass' fastq files were concatenated into one using the script 'concat_fastq_SQK_RBK004.sh' setting the input path as the the pass directory for a specific rebasecalled barcode (e.g  /mnt/shared/scratch/kkeegan/personal/extraction_exp/Rebasecalled_trimmed_super_accuracy/barcode_1/pass/barcode01) and the output path being the same directory but with the file name specific to the barcode being concatenated (e.g /mnt/shared/scratch/kkeegan/personal/extraction_exp/Rebasecalled_trimmed_super_accuracy/barcode_1/pass/barcode01/concat_barcode1.fastq)

**Step 3**: Cleaning up and converting fastq files to fasta

I check for any duplicated reads that may be present and I also convert this fastq file to fasta for BLAST ANALYSIS not using a bash script but by running an interactive job on the cluster (srsh command to initiate interactive job) and for trimming, use the package SeqKit (conda install -c bioconda seqkit) and running seqkit rmdup concat.fastq -s -o clean.fastq. Barcode1 = 29 duplicates removed. Barcode 2 = 9 duplicates removed. Barcode3 = 45 duplicates removed. Barcode 4 = 4 duplicates removed. Barcode 5 = 2 duplicates removed. Barcode 6 = 9duplicates removed. Barcode 7 = 0 duplicates removed. 

To convert these clean.fastq to clean.fasta, I simply use the package seqtk (conda install -c bioconda seqtk) and convert each barcodes concatenated cleaned fastq file to fasta using 'seqtk seq -a clean.fastq > cleaned_fasta.fasta'. Note the pass folder of barcode2 and barcode 5 has a directory called barcode1 which has three fastq files of total size 11KB. I did not include these fastq file in the final barcode 1 cleaned fasta file as im not 100% sure if it is barcode 1 (given that it is in the wrong barcode directory). 

**Step 4**:BLAST each barcodes cleaned, concatenated fasta file

Done using blast_ncbi_outfmt7.sh with database set to NCBI nt database (a mirror nt database on the HPCC Crop Diversity)

**Step 5**: Parse the blast text file per barcode into R

Done using parsefilter_blasttable.R run in parse_into_R.sh script.

**Step 6**: Filter out any potential incorrect barcodes and add fully taxonomy to reads

In the notebook "taxonomizr_blast_tidied_2025.Rmd", each barcodes parsed blast text file is loaded into R. For each barcode, any reads detected in that barcodes summary seq file (see Step 1.1 above) that were assigned to the wrong barcode are filtered out of the blast text file. The seven blast text files (one per extraction method) are then merged into a final dataset (combined_blast) and using the Taxonomizr package
v 0.10.6, the reads in combined_blast are assigned full taxonomy classification (from superkingdom to species) based on the subject taxonomic ID each read aligned to. Dataframe with all this information is called merged_with_taxa_2025.

**Step 7**: Further filtering of blast reads in R

Using the notebook "loose_stringent_filtering.Rmd", the dataframe merged_with_taxa_2025, two further filtering approaches are applied to the blast results; loose and stringent, resulting in two dataframes: loose_ext_exp_2025 and stringent_ext_exp_2025. The flowchart below illustrates the filtering criteria in each of these datasets:

![filtering_flow_chart](https://github.com/user-attachments/assets/7e24707f-eb6e-4c1c-837c-6612e9ccc52b)

**Step 8**: QC and taxa info for manuscript models

After the MagAttract method was chosen as the DNA extraction method of choice, 3 additional Nanopore runs were completed with N = 60 samples, and the read QC and taxa results of samples in these runs were used as input into a set of models looking at the effect of sample precipitation, DNA concentraion and volume of sample used in Magattract DNA extraction on read QC/taxa. These runs and models were additional tests to insure MagAttract model still produced quality data on a wider range of samples.

The R notebook "sum_seq_metrics_model2025" uses information from the summary sequencing files of each of these runs (generated using Guppy) to give data on the number of reads, number of bases and number of reads passing the Qscore filtering, variables which will be used in subsequent models evaluating the MagAttract method and modifications to the method.


**Results**

*Superkingdom counts/proportions per extraction method, bacterial phyla proportions and heatmap per extraction method**

The R notebook "superkingdom_bacteria_plots_2025.Rmd" has the code used to generate the figures used in the manuscript, namely; the superkingdom counts per extraction method, the bacterial phyla proportions per extraction method and the heatmap of bacterial phyla per extraction method. Note there are two versions of each of these figures in the manuscript - one for the loose filtering dataset and corresponding figures using the stringent filtering dataset.
