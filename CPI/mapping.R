# Download the shapefile.
# Unzip this file.

# Read this shape file with the sf library. 
# library(sf)
# world_spdf = 
#   st_read(dsn = "./non-website/kindle zhang/CPI/data/world_shape_file/",
#                     layer = "TM_WORLD_BORDERS_SIMPL-0.3")

# Clean the data object
# library(dplyr)
# world_spdf$POP2005[ which(world_spdf$POP2005 == 0)] = NA
# world_spdf$POP2005 =
#   as.numeric(as.character(world_spdf$POP2005)) / 1000000 |>  
#   round(2)

# -- > Now you have a Spdf object

# Library
# library(leaflet)

# Create a color palette for the map:
mypalette = 
  colorNumeric( palette="viridis", 
                domain=world_spdf$POP2005,
                na.color="transparent")
mypalette(c(45,43))

# Basic choropleth with leaflet?
# m = leaflet(world_spdf)  |>
#   addTiles()  |>
#   setView(lat = 10, lng = 0 , zoom = 2)  |>
#   addPolygons(fillColor = ~ mypalette(POP2005), stroke = FALSE)
# 
# m

# save the widget in a html file if needed.
# library(htmlwidgets)
# 
# saveWidget(m,
#            file = 
#              paste0(getwd(),
#                     "/non-website/kindle zhang/CPI/www/choroplethLeaflet1.html"))


# load ggplot2
library(ggplot2)

# Distribution of the population per country?
# world_spdf |>  
#   ggplot( aes(x=as.numeric(POP2005))) + 
#   geom_histogram(bins=20, fill='#69b3a2', color='white') +
#   xlab("Population (M)") + 
#   theme_bw()

# Color by quantile
# m = 
#   leaflet(world_spdf) |> 
#   addTiles()  |> 
#   setView( lat=10, lng=0 , zoom=2) |> 
#   addPolygons( stroke = FALSE, 
#                fillOpacity = 0.5, 
#                smoothFactor = 0.5, 
#                color = ~colorQuantile("YlOrRd", POP2005)(POP2005) )
# 
# m

# save the widget in a html file if needed.
# saveWidget(m, 
#            file=paste0( getwd(), 
#                         "/non-website/kindle zhang/CPI/www/choroplethLeaflet2.html"))

# Create a color palette with handmade bins.
library(RColorBrewer)
mybins = c(0,10,20,50,100,500,Inf)
mypalette = 
  colorBin( palette="YlOrBr", 
            domain=world_spdf$POP2005, 
            na.color="transparent", 
            bins=mybins)

# Prepare the text for tooltips:
mytext = 
  paste(
  "Country: ", world_spdf$NAME,"<br/>", 
  "Area: ", world_spdf$AREA, "<br/>", 
  "Population: ", round(world_spdf$POP2005, 2), 
  sep="") |> 
  lapply(htmltools::HTML)

# Final Map
m = 
  leaflet(world_spdf)  |>  
    addTiles()  |> 
    setView( lat=10, lng=0 , zoom=2)  |> 
    addPolygons( 
      fillColor = ~mypalette(POP2005), 
      stroke=TRUE, 
      fillOpacity = 0.9, 
      color="white", 
      weight=0.3,
      label = mytext,
      labelOptions = labelOptions( 
        style = 
          list("font-weight" = "normal", padding = "3px 8px"), 
        textsize = "13px", 
        direction = "auto"
      )
    ) |> 
    addLegend( pal=mypalette, 
               values=~POP2005, 
               opacity=0.9, 
               title = "Population (M)", 
               position = "bottomleft" )

m  

saveWidget(m, 
           file=paste0( getwd(), 
                        "/non-website/kindle zhang/CPI/www/choroplethLeaflet3.html"))