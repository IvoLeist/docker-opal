FROM rocker/tidyverse

RUN R -e 'install.packages("dsBaseClient", repos=c(getOption("repos"), "http://cran.datashield.org"), dependencies=TRUE)'
RUN R -e 'install.packages("DSOpal", dependencies=TRUE)'