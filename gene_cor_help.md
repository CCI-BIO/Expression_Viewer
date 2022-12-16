---
title: "gene_cor_help"
output: html_document
---



### Pairwise gene correlation

The pairwise gene correlation module requires the user to upload 1 file:

* **1. TPM count table.**

<img src="Instruction_images/gene_cor_1.jpg" alt="plot of chunk unnamed-chunk-2" width="75%" style="display: block; margin: auto;" />

Two genes can be selected from the drop down lists (based on the first column of the TPM file). Additionally, different correlation methods (pearson, kendall and spearman) can be selected. 

A plot with log converted TPM values between the two specified genes will be output. The plot will also contain a linear model fitted line. Above the plot will be the relevant correlation coefficient (*r*) and associated p-value (*p*). 

<img src="Instruction_images/gene_cor_2.jpg" alt="plot of chunk unnamed-chunk-3" width="75%" style="display: block; margin: auto;" />

Downloaded images will have the correlation coefficient and associated p-value printed in the top left of the plot. 
