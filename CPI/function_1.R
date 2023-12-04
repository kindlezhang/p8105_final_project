
library(RColorBrewer)

map_draw = function(data, year){
  

  # Create a color palette with handmade bins.
  mybins = c(0,20,40,60,80,100)
  mypalette = 
    colorBin( palette="YlOrBr", 
              domain=data[[year]], 
              na.color="transparent", 
              bins=mybins)
  
  # Prepare the text for tooltips:
  mytext = 
    paste(
      "Country: ", data$NAME,"<br/>", 
      "Area: ", data$AREA, "<br/>", 
      "CPI: ", data[[year]], 
      sep="") |> 
    lapply(htmltools::HTML)
  
  # final map
  leaflet(data = data)  |>  
    addTiles()  |> 
    setView( lat=10, lng=0 , zoom=2)  |> 
    addPolygons( 
      fillColor = ~mypalette(data[[year]]), 
      stroke=TRUE, 
      fillOpacity = 0.9, 
      color="white", 
      weight=0.3,
      label = mytext,
      labelOptions = labelOptions( 
        style = 
          list("font-weight" = "normal", 
               padding = "3px 8px"), 
        textsize = "13px", 
        direction = "auto"
      )
    ) |> 
    addLegend( pal=mypalette, 
               values=~year, 
               opacity=0.9, 
               title = "CPI index", 
               position = "bottomleft" )
}






