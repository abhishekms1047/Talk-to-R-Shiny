library(leaflet)
library(plotly)

# Choices for drop-downs
vars <- c(
  "education" = "education",
  "income" = "income",
  "Population" = "population"
)


navbarPage("TALK to R ", id="nav",
           
           
    tabPanel("Map",
    div(class="outer",

      tags$head(
        # Include our custom CSS
        includeCSS("styles.css"),
        includeScript("gomap.js")
      ),
      # below code is for adding annyang library for Rshhiny UI
      singleton(tags$head(
        tags$script(src="//cdnjs.cloudflare.com/ajax/libs/annyang/1.4.0/annyang.min.js"),
        includeScript('init.js')
      )),
      
      h5("Please refer 'How To Use' documentation OR Try voice commands- 'Top 10 places by Income','Go to zip code 13475','Zoom In','Color by Population','Size by income' , 'Graph Population by Income' "),
      #Below code is to include the leaflet maps in to UI
      leafletOutput("map", width="100%", height="100%"),
        
        
      
      absolutePanel(id = "controlsa", class = "panel panel-default", fixed = TRUE,
                    draggable = TRUE, top = 100, left =20 , right = "auto", bottom = "auto",
                    width = 400, height = "auto",

                    h5('Listening...'),verbatimTextOutput("default"),
                    dataTableOutput("TopN_output")
                    ),
      # Shiny versions prior to 0.11 should use class="modal" instead.
      absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
        draggable = TRUE, top = 100, left = "auto", right = 20, bottom = "auto",
        width = 400, height = "auto",
        #tags$a(href="https://www.linkedin.com/in/abhishekmshivalingaiah", "LinkedIn    "),
        #tags$a(href="https://www.linkedin.com/in/abhishekmshivalingaiah", "GitHub"),
        
        h6("Color By"),verbatimTextOutput("color1"),
        h6("Size By"),verbatimTextOutput("size1"),
        plotlyOutput("scatterPlot")
        
        
        ),
     
        tags$div(id="cite",
        'Data compiled for ', tags$em('Coming Apart: The State of White America, 1960–2010'), ' by Charles Murray (Crown Forum, 2012).'
      )
      
    )
  ),

  tabPanel("Data explorer",
    fluidRow(
      column(3,
        selectInput("states", "States", c("All states"="", structure(state.abb, names=state.name), "Washington, DC"="DC"), multiple=TRUE)
      ),
      column(3,
        conditionalPanel("input.states",
          selectInput("cities", "Cities", c("All cities"=""), multiple=TRUE)
        )
      ),
      column(3,
        conditionalPanel("input.states",
          selectInput("zipcodes", "Zipcodes", c("All zipcodes"=""), multiple=TRUE)
        )
      )
    ),
    fluidRow(
      column(1,
        numericInput("minScore", "Min score", min=0, max=100, value=0)
      ),
      column(1,
        numericInput("maxScore", "Max score", min=0, max=100, value=100)
      )
    ),
    hr(),
    DT::dataTableOutput("ziptable")
     ),
  
  
  # using iframe along with tags() within tab to display pdf with scroll, height and width could be adjusted
  tabPanel("How To Use", 
           tags$iframe(style="height:700px; width:100%; scrolling=yes", 
                       src="Talk_to_R_Documentation.pdf")
           
  ),
  
  

  conditionalPanel("false", icon("crosshair"))
)
