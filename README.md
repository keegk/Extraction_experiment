# Extraction_experiment
This is the pipeline for analysing my MinION 'Extraction experiment' samples. 

Kit used: SQK-RBK004 (7 barcodes utilised). Flow cell R9.4.1. Run time=18hrs. Date of run: 22/02/2023. Each barcode represents a separate DNA extraction method. For each extraction method, three aliquots of extracted DNA from Biological replicate 3 (BR3) were combined and ethanol precipitated to produce approx 100ng of DNA per extraction method (apart from barcode 6, MagATTract, which only had a starting DNA input of 25ng for library prep). 
Barocde1:FASTDNA
Barcode2: MagMAX
Barcode3: 3 peaks
Barcode4: Phenol-chloroform
Barcode5: UCP Pathogen kit
Barcode6: MagAttract
Barcode7:Genomic tip 100/G

Step One: Rebasecalling the fast5 files from the sequencing run. 

For each barcode/extraction method, the pass and fail fast5 files from the sequencing run after 18hrs were combined and then rebasecalled using super accuracy guppy basecaller (version 6.0.1), bash script titled 'super_accuracy_SQK_RBK004.sh'.
