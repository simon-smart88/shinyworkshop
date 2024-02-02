library(shiny)
library(leaflet)
library(terra)

ui <- fluidPage(
  leafletOutput(),
  downloadButton()
)

server <- function(input, output) {

  #load in data
  fcover <- terra::rast("london_fcover.tif")
  wards <- sf::st_read("London_Ward.shp", quiet = TRUE)

  #reproject shapes to same CRS as the raster
  wards <- sf::st_transform(wards, terra::crs(fcover))

  renderLeaflet({
    leaflet() %>%
      addProviderTiles("Esri.WorldTopoMap") %>%
      addPolygons() %>%
      addRasterImage()})

  leafletProxy()

  #to access values from this and pass them to fitBounds, you need to use e.g. bbox[[1]]
  bbox <- sf::st_bbox()

  fitBounds()

  selected_point <- data.frame(x = , y = ) %>%
    sf::st_as_sf(coords = c("x", "y"), crs = 4326)

  index_of_polygon <- sf::st_intersects(selected_point, wards, sparse = T) %>%
    as.numeric()

  #example of subsetting the imagery for a specific ward
  ward_fcover <- terra::crop(fcover, wards[wards$NAME == "Darwin",], mask = TRUE)

  downloadHandler(
    filename = function() {
      "file.png"
    },
    content = function(file) {

    }
  )
}

shinyApp(ui = ui, server = server)
