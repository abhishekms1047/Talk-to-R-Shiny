# Talk to R 

Talk to R is a Voice Enabled Web App built on R for analysing data using maps

The Web App is hosted live at https://abhiplot.shinyapps.io/talk_to_r_shiny/

You can also run this App in R Studio locally:

```
if (!require(devtools))
  install.packages("devtools")

devtools::install_github("rstudio/leaflet")
devtools::install_github("hadley/dplyr")
devtools::install_github("cran/plotly")
devtools::install_github("cran/RColorBrewer")
devtools::install_github("hadley/scales")
devtools::install_github("cran/lattice")
devtools::install_github("krlmlr/bindr")

library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library (plotly)
library(leaflet)
library(Shiny)
library(bindr)

shiny::runGitHub("abhishekms1047/Talk-to-R-Shiny")

```

After the application start 

Voice commands can be issued:



Top N places by income/population/education

    Example:
```
    Top 10 places by income
    
    Top 3 places by population
    
    Top 24 places by education
```
Go to zip code 75252

    Example:
```
    Go to zip code 75252

    Go to zip code 18943

    Go to zip code 75252
```

```
Zoom in
```

```
Zoom out
```


Color by income/population/education

    Example:
```
    Color by income

    Color by population
```


Size by income/population/education

    Example: 
```
    Size by income

    Size by population
```    

Graph income/population/education by income/population/education

   
```Example:
    Graph income by population

    Graph education by income 
```



Data compiled for Coming Apart: The State of White America, 1960–2010 by Charles Murray (Crown Forum, 2012). 
This app was inspired by the Washington Post's interactive feature Washington: _[Washington: A world apart](http://www.washingtonpost.com/sf/local/2013/11/09/washington-a-world-apart/)_.
