DNA-mapping --mapq 1 -i fastq/ -o output --trim --fastqc --properPairs --dedup --alignerOpts="--local --very-sensitive-local --no-discordant --no-mixed -I 10 -X 700" config.yaml
