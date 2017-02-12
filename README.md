# Talk to R 

Talk to R is a Voice Enabled Web App built on R for analysing data using maps

The Web App is hosted live at https://abhiplot.shinyapps.io/talk_to_r_shiny/

You can run this App in R Studio:

```
if (!require(devtools))
  install.packages("devtools")

devtools::install_github("rstudio/leaflet")
devtools::install_github("hadley/dplyr")
devtools::install_github("cran/plotly")
devtools::install_github("cran/RColorBrewer")
devtools::install_github("hadley/scales")
devtools::install_github("cran/lattice")

library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library (plotly)
library(leaflet)
library(Shiny)

shiny::runGitHub("abhishekms1047/Talk-to-R-Shiny")

```

Data compiled for Coming Apart: The State of White America, 1960–2010 by Charles Murray (Crown Forum, 2012). 
This app was inspired by the Washington Post's interactive feature Washington: _[Washington: A world apart](http://www.washingtonpost.com/sf/local/2013/11/09/washington-a-world-apart/)_.
