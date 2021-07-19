# System Requirements 
# Software: R, Python, SAMtools, tabix
# Operating system: Linux, OS X, Windows
# Memory: Minimum 4 GB of RAM. Recommended >8 GB.
# Disk space: 1.5 GB for sample (depending on sequencing depth)
# R version: 3.2.0
# Python version: 2.7, 3.4, 3.5, 3.6 (or PyPy)




# This is the Sequenza-Utils pre-processing section, this part of the analysis was run on a cluster system within a linux environment. It may also work on python but you need to add '!' at the start of each coding line if you want to carry out this process on Jupyters Notebook

sequenza-utils gc_wiggle --w 50 --fasta hg19.fa -o hg19.gc50Base.wig.gz # Processing the GC wiggle track file along with the reference genome, make sure to use samtools view command in order to verify which reference genome was used for your samples.

sequenza-utils bam2seqz --normal normal_sample.bam --tumor tumor_sample.bam \ # Processing the BAM file along with the Wiggle file in order to produce the seqz file.
--fasta genome.fa.gz -gc genome_gc50.wig.gz --output sample.seqz.gz

sequenza-utils bam2seqz --normal tumor_sample.bam --tumor tumor_sample.bam \ # Workaround method to producing the seqz file if you do not have the normal version of the tumour sample.
--normal2 non_matching_normal_sample.bam --fasta genome.fa.gz \
-gc genome_gc50.wig.gz --output sample.seqz.gz




sequenza-utils seqz_binning --seqz sample.seqz.gz --window 50 \ # Binning Process of the original seqz file, this is mainly to save up on memory and disk space - additionally the processing part later on is faster if the file is smaller.
-o sample_bin50.seqz.gz


# The next section below was carried out in a R Studio environment. This is the main section of sequenza and where the actual analysis takes place.


library(sequenza)
getwd()
setwd('Working Directory')
test <- sequenza.extract('sample') # The sequenza.extract command process the seqz file, segments it and normalizes it 
CP <- sequenza.fit(test) # The sequenza.fit runs a grid search on the file in order to estimate ploidy and cellularity.
sequenza.results(sequenza.extract = test,                      # This final command generates the result files and produces the outputs within the desired directory. The files produced are pdf format and include quality control assessments and visualization data of the ploidy and copy number estimates.  
                 cp.table = CP, sample.id = "Test",
                 out.dir="TEST")