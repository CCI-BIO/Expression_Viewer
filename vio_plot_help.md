---
title: "vio_plot_help"
output: html_document
---



### Violin plot

The violin plot module allows the user to generate a set of violin plots based on a specified category and the TPM values of each of the samples for a specific gene. 

The module requires the user to upload 2 files:

* **1. TPM count table.**

* **2. Sample metadata file.**

<img src="Instruction_images/vio_plot_1.jpg" alt="plot of chunk unnamed-chunk-2" width="75%" style="display: block; margin: auto;" />

The module provides the option to select any gene that is present in the TPM counts file. Furthermore, the TPM values represented in the plot can be converted to log-TPM if required. 

Metadata categories can be selected from the drop down list and the constructed plot will be stratified accordingly. If necessary specific metadata groups within a category can be filtered out. 

<img src="Instruction_images/vio_plot_2.jpg" alt="plot of chunk unnamed-chunk-3" width="75%" style="display: block; margin: auto;" />

The final violin plot can then be downloaded using the download button below the interactive plot. 
