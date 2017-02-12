library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library ("plotly")

# Leaflet bindings are a bit slow; for now we'll just sample to compensate
set.seed(100)
zipdata <- allzips[sample.int(nrow(allzips), 10000),]
zipdata <- zipdata[order(zipdata$centile),]

function(input, output, session) {

## Interactive Map ##


  # Create the map
  output$map <-  renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
      setView(lng = -96.76152, lat = 32.98648 , zoom = 4)
  })
  
  
  
  # # Show a popup at the given location
  showZipcodePopup <- function(zipcode, lat, lng) {
    selectedZip <- allzips[allzips$zipcode == zipcode,]
    content <- as.character(tagList(
      tags$strong(HTML(sprintf("%s, %s %s",
                               selectedZip$city.x, selectedZip$state.x, selectedZip$zipcode
      ))), tags$br(),
      sprintf("Median household income: %s", dollar(selectedZip$income * 1000)), tags$br(),
      sprintf("Percent of adults with BA: %s%%", as.integer(selectedZip$education)), tags$br(),
      sprintf("Adult population: %s", selectedZip$population)
    ))
    leafletProxy("map") %>% addPopups(lng, lat, content, layerId = zipcode)
  }
  
  # A reactive expression that returns the set of zips that are
  # in bounds right now
  zipsInBounds <- reactive({
    if (is.null(input$map_bounds))
      return(zipdata[FALSE,])
    bounds <- input$map_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)

    subset(zipdata,
      latitude >= latRng[1] & latitude <= latRng[2] &
        longitude >= lngRng[1] & longitude <= lngRng[2])
  })

  #To identify any changes in color
    color<-eventReactive(input$color,{
    output$default <- renderText({ paste("Color by",input$color) })
    
    input$color 
    }  )

    #to identify changes in Size
  size<-eventReactive(input$size,{
  output$default <- renderText({ paste("Size by",input$size) }) 
    
    input$size
    }  )
  
  # to Dynamically plot the scatter plot
  output$scatterPlot <- renderPlotly ({
    # If no zipcodes are in view, don't plot
    if (nrow(zipsInBounds()) == 0)
    return(NULL)
    
    #print(plot_ly(data = zipsInBounds(),type = "scatter",mode = 'markers', x = ~income, y = ~population))
    if(input$ploty=='education' && input$plotx=='income' ){
      plot_ly(data = zipsInBounds(),type = "scatter",mode = 'markers', x = ~income, y = ~education) %>% layout(title = "Graph income by education")
      
    }
    else if(input$ploty=='income' && input$plotx=='education'){
      plot_ly(data = zipsInBounds(),type = "scatter",mode = 'markers', x = ~education, y = ~income) %>% layout(title = "Graph education by income")
      
    }
    else if (input$ploty=='income' && input$plotx=='population')
    {
           plot_ly(data = zipsInBounds(),type = "scatter",mode = 'markers', x = ~population, y = ~income ) %>% layout(title = "Graph population by income")
      
    }
    else if (input$ploty=='population' && input$plotx=='income')
    {
           plot_ly(data = zipsInBounds(),type = "scatter",mode = 'markers', x = ~income, y = ~population) %>% layout(title = "Graph income by population")
                                                                                                            
    }
    
    else if (input$ploty=='population' && input$plotx=='education')
    {
     
      plot_ly(data = zipsInBounds(),type = "scatter",mode = 'markers', x = ~education, y = ~population) %>% layout(title = "Graph education by population")
      
    }
    else {
      
      plot_ly(data = zipsInBounds(),type = "scatter",mode = 'markers', x = ~education, y = ~income) %>% layout(title = "Graph education by income")
    }
    
  })

  #change the longitude based on Zip dynamically
  longi<-eventReactive(input$zip,{ 
  
  if(length(allzips[allzips$zipcode == input$zip,]$longitude)!=0) 
  {
    a<-allzips[allzips$zipcode == input$zip,]$longitude
  }
  else 
  {
    #default to Dallas
    a<--96.76152
  }
  
  return(a)
})
  

  #change the latitude based on Zip dynamically
  lati<-eventReactive(input$zip,{
  
  if(length(allzips[allzips$zipcode == input$zip,]$latitude)!=0) 
  {
    a<-allzips[allzips$zipcode == input$zip,]$latitude
  }
  else 
  {
    #Default to Dallas
    a<-32.98648
  }
  
  return(a)
  })

# To cater to goto zip command
GoToPlace<-eventReactive(input$zip,{
  
  output$default <- renderText({ paste("Go to Zipcode",input$zip) })
  
  if(length(allzips[allzips$zipcode == input$zip,]$latitude)!=0) 
  {
    a<-cbind(allzips[allzips$zipcode == input$zip,]$city.y,allzips[allzips$zipcode == input$zip,]$zipcode)
    
  }
  else 
  {
    a<-cbind("WRONG","ZIPCODE :)")
  }
  colnames(a)<- c("City","Zipcode")
  return(a)
  
  
})

#to identify changes in zoom
zoom<-eventReactive(input$zoom,{
  
output$default <- renderText({ paste("Zoom") })
  input$zoom
})

#to identify changes in feature for top N 
feature<-eventReactive(input$feature,{
  input$feature
})

#to fetch data points for top N feature
points <- eventReactive(c(input$feature,input$top), {

  if(is.numeric(input$top))
{
  if(feature()=='education'){
  output$default <- renderText({ paste("Top",input$top,"places by Education") })
  
  a<-cbind(top_n(allzips,input$top,education)$city.y,top_n(allzips,input$top,education)$zipcode)
  
  }
  else if(feature()=='income'){
  output$default <- renderText({ paste("Top",input$top,"places by Income") })
    a<-cbind(top_n(allzips,input$top,education)$city.y,top_n(allzips,input$top,education)$zipcode)
    
  }
  else if (feature() =='population')
  {
   output$default <- renderText({ paste("Top",input$top,"places by Population") })
    a<-cbind(top_n(allzips,input$top,education)$city.y,top_n(allzips,input$top,education)$zipcode)
   
  }

  else {
  output$default <- renderText({ paste("Try agian, Default :'Top N places by Education'") })
  a<-cbind(top_n(allzips,input$top,education)$city.y,top_n(allzips,input$top,education)$zipcode)
   
  }
  
}
  
  
  else{
    output$default <- renderText({ paste("Try agian, Default :'Top N places by Education'") })
    a<-cbind(top_n(allzips,input$top,education)$city.y,top_n(allzips,input$top,education)$zipcode)
    
  }
  colnames(a)<- c("City","Zipcode")
  
  returnValue(a)
  
  }
)

#to change viewing area based on lat,long and zoom
observe({
  mapa<-leafletProxy("map")
  mapa %>%setView(lat = lati(),lng = longi(),zoom = zoom()) 
  })


#to change view to for 'go to zipcode ' command
observe({
  mapa<-leafletProxy("map")
  mapa %>%clearMarkers()
  mapa%>% addMarkers(lat=lati(),lng =longi())
  GoToPlaceData<- GoToPlace()
  output$TopN_output <- renderDataTable(GoToPlaceData,
                                        options = list(
                                          pageLength = 7,
                                          iDisplayLength=5,                    # initial number of records
                                          aLengthMenu=c(5,10),    # records/page options
                                          bLengthChange=0,        # show/hide records per page dropdown
                                          bFilter=0,              # global search box on/off
                                          bInfo=0                # information on/off (how many records filtered, etc)
                                          #bAutoWidth=0           # automatic column width calculation, disable if passing column width via aoColumnDefs
                                        )) 
  })


# to render 'top N values'
observe({
 
a<- points()
output$TopN_output <- renderDataTable(a,
options = list(
  
              # pageLength = 7,
               iDisplayLength=5,                    # initial number of records
               aLengthMenu=c(5,10),    # records/page options
               bLengthChange=0,        # show/hide records per page dropdown
               bFilter=0,              # global search box on/off
               bInfo=0,                # information on/off (how many records filtered, etc)
               bAutoWidth=0           # automatic column width calculation, disable if passing column width via aoColumnDefs
))



})




#This observer is responsible for maintaining the circles and legend,
# according to the variables the user has chosen to map to color and size.

observe({
  
  if( color()=='education')
  {
    colorBy<-'education'
   
    
  }
  else if ( color()=='population')
  {
    
    
    colorBy<-'population'
  }  
  else if(color()=='population') 
  {
  
    colorBy<-'income'
  }
  
  else 
  {
    output$default <- renderText({ paste("Try Again,Default: 'Color by income'")})
    colorBy<-'income'
    
  }
  
  
  if(size()=='education')
  {
    
    sizeBy<-'education'
  }
  else if (size()=='population')
  {
   
    sizeBy<-'population'
  }  
  else if(size()=='income')
  {
    
    sizeBy<-'income'
  }
  else
  {
    output$default <- renderText({ paste("Try Again,Default: 'Size by income'",input$size) })
    sizeBy<-'income'
  }
  
    output$color1 <- renderText({ input$color })
    output$size1 <- renderText({ input$size })
 
    colorData <- zipdata[[colorBy]]
    pal <- colorBin("Spectral", colorData, 7, pretty = FALSE)
  

 
    radius <- zipdata[[sizeBy]] / max(zipdata[[sizeBy]]) * 30000
 
  

  leafletProxy("map", data = zipdata) %>%
    clearShapes() %>%
    addCircles(~longitude, ~latitude, radius=radius, layerId=~zipcode,
      stroke=FALSE, fillOpacity=0.4, fillColor=pal(colorData)) %>%
    addLegend("bottomleft", pal=pal, values=colorData, title=colorBy,
      layerId="colorLegend")
})
# 

  # When map is clicked, show a popup with city info
  
  observe({
    leafletProxy("map") %>% clearPopups()
    event <- input$map_shape_click
    if (is.null(event))
      return()

    isolate({
      showZipcodePopup(event$id, event$lat, event$lng)
    })
  })


  ## Data Explorer  tab to display data##

  observe({
    cities <- if (is.null(input$states)) character(0) else {
      filter(cleantable, State %in% input$states) %>%
        `$`('City') %>%
        unique() %>%
        sort()
    }
    stillSelected <- isolate(input$cities[input$cities %in% cities])
    updateSelectInput(session, "cities", choices = cities,
      selected = stillSelected)
  })

  observe({
    zipcodes <- if (is.null(input$states)) character(0) else {
      cleantable %>%
        filter(State %in% input$states,
          is.null(input$cities) | City %in% input$cities) %>%
        `$`('Zipcode') %>%
        unique() %>%
        sort()
    }
    stillSelected <- isolate(input$zipcodes[input$zipcodes %in% zipcodes])
    updateSelectInput(session, "zipcodes", choices = zipcodes,
      selected = stillSelected)
  })

  observe({
    if (is.null(input$goto))
      return()
    isolate({
      map <- leafletProxy("map")
      map %>% clearPopups()
      dist <- 0.5
      zip <- input$goto$zip
      lat <- input$goto$lat
      lng <- input$goto$lng
      showZipcodePopup(zip, lat, lng)
      map %>% fitBounds(lng - dist, lat - dist, lng + dist, lat + dist)
    })
  })

  output$ziptable <- DT::renderDataTable({
    df <- cleantable %>%
      filter(
        Score >= input$minScore,
        Score <= input$maxScore,
        is.null(input$states) | State %in% input$states,
        is.null(input$cities) | City %in% input$cities,
        is.null(input$zipcodes) | Zipcode %in% input$zipcodes
      ) %>%
      mutate(Action = paste('<a class="go-map" href="" data-lat="', Lat, '" data-long="', Long, '" data-zip="', Zipcode, '"><i class="fa fa-crosshairs"></i></a>', sep=""))
    action <- DT::dataTableAjax(session, df)

    DT::datatable(df, options = list(ajax = list(url = action)), escape = FALSE)
  })
}
