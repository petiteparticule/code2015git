# code2015git
Canada Open Data Experience 2015

A bit of R code that I wrote for CODE 2015 in Montréal.

You need the following R libraries to run tis code: library(ggplot2) library(zoo) library(DAAG) library(mapdata) library(ggmap)

You need to have the following 2 files in your current_dir/data/ 2011_SFGSME_EFCPME_T14_eng.csv 2011_SFGSME-EFCPME_T1_eng.csv

data set from here http://open.canada.ca/data/en/dataset/c34ca68e-85bb-43d6-a261-7b42ce9b31e8

run in R console as: source("code2015.R") code2015_govfund()

Here is the sessionInfo:

sessionInfo() R version 3.1.2 (2014-10-31) Platform: x86_64-apple-darwin14.0.0 (64-bit)
locale: [1] en_CA.UTF-8/en_CA.UTF-8/en_CA.UTF-8/C/en_CA.UTF-8/en_CA.UTF-8

attached base packages: [1] stats graphics grDevices utils datasets methods base

other attached packages: [1] plotly_0.5.23 mapproj_1.2-2 ggmap_2.3 mapdata_2.2-3
[5] DAAG_1.20 lattice_0.20-29 zoo_1.7-11 maps_2.3-9
[9] ggplot2_1.0.0 RJSONIO_1.3-0 RCurl_1.95-4.5 bitops_1.0-6
[13] devtools_1.7.0

loaded via a namespace (and not attached): [1] colorspace_1.2-4 digest_0.6.8 evaluate_0.5.5
[4] formatR_1.0 grid_3.1.2 gtable_0.1.2
[7] httr_0.6.1 knitr_1.9 labeling_0.3
[10] latticeExtra_0.6-26 MASS_7.3-35 munsell_0.4.2
[13] plyr_1.8.1 png_0.1-7 proto_0.3-10
[16] RColorBrewer_1.1-2 Rcpp_0.11.3 reshape2_1.4.1
[19] RgoogleMaps_1.2.0.7 rjson_0.2.15 scales_0.2.4
[22] stringr_0.6.2 tools_3.1.2
