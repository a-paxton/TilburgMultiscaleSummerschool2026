# install.R
pkgs <- c("tidyverse", "phonfieldwork", "xml2", "reticulate", "knitr", "rmarkdown")
missing <- pkgs[!pkgs %in% rownames(installed.packages())]
if (length(missing)) install.packages(missing, repos = "https://cloud.r-project.org")