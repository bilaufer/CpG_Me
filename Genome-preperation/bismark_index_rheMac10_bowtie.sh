#!/bin/bash
#
#SBATCH --job-name=rheMac10
#SBATCH --workdir /share/lasallelab/genomes/
#SBATCH --partition=production               
#SBATCH --ntasks=12
#SBATCH --mem=18000
#SBATCH --output=rheMac10.out # File to which STDOUT will be written
#SBATCH --error=rheMac10.err # File to which STDERR will be written
#SBATCH --time=0-05:00:00

export mainPath="/share/lasallelab"
PATH="$PATH:${mainPath}/programs/CpG_Me/Bismark-master/"
module load bowtie2/2.3.4.1
module load samtools/1.10

mkdir ${mainPath}/genomes/rheMac10
cd ${mainPath}/genomes/rheMac10

rsync --copy-links --recursive --times --verbose rsync://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/003/339/765/GCF_003339765.1_Mmul_10/GCF_003339765.1_Mmul_10_genomic.fna.gz .

gunzip GCF_003339765.1_Mmul_10_genomic.fna.gz

mv GCF_003339765.1_Mmul_10_genomic.fna rheMac10.fa

bowtie2-build --threads 12 --verbose rheMac10.fa rheMac10

mkdir Bowtie2
mv *.bt2 Bowtie2/

bismark_genome_preparation --bowtie2 --parallel 6 --verbose .