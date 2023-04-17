[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# The code developed for the paper Atinbayeva et al 2023

Here we put the scripts used to analyse the cut and tag data. The scripts are example scripts that need to be adapted to the user path and data structure

- mapping script: we used snakePipes/2.4.0 to align the fastq.gz files to the reference genome. The yaml file used to do the alignment is provided [here](https://github.com/zhanyinx/atinbayeva_paper_2023/blob/main/cuttag_data_analysis/00_mapping/config.yaml)

- normalisation: we used the lambda spike-in alone to detect homogeneous decrease in enrichment. Moreover, when we had different starting material which could affect quantification, we used cuttag performed on H3 as additional normaliser. The script used can be found [here](https://github.com/zhanyinx/atinbayeva_paper_2023/tree/main/cuttag_data_analysis/01_spikein_normalisation)
