library(shiny)
library(leaflet)
library(terra)

ui <- fluidPage(
  leafletOutput("map"),
  downloadButton("dl")
)

server <- function(input, output) {

  #load in data
  fcover <- terra::rast("../exercise3/london_fcover.tif")
  wards <- sf::st_read("../exercise3/London_Ward.shp", quiet = TRUE)

  #reproject shapes to same CRS as the raster
  wards <- sf::st_transform(wards, terra::crs(fcover))

  #plot the data in leaflet
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("Esri.WorldTopoMap") %>%
      addPolygons(data = wards) %>%
      addRasterImage(fcover)
      })

  #create a proxy map
  proxy_map <- leafletProxy("map")

  #select the ward that is clicked on
  selected_ward <- reactive({
    req(input$map_shape_click)
    selected_point <- data.frame(x = input$map_shape_click$lng, y = input$map_shape_click$lat ) %>%
      sf::st_as_sf(coords = c("x", "y"), crs = 4326)

    index_of_polygon <- sf::st_intersects(selected_point, wards, sparse = T) %>%
      as.numeric()

    wards[index_of_polygon,]
  })

  #use the proxy map to change the bounds
  observe({
    bbox <- sf::st_bbox(selected_ward())
    proxy_map %>%
      fitBounds(lng1 = bbox[[1]], lng2 = bbox[[3]], lat1 = bbox[[2]], lat2 = bbox[[4]])
  })

  #download the image
  output$dl <- downloadHandler(
    filename = function() {
      "file.png"
    },
    content = function(file) {
      ward_fcover <- terra::crop(fcover, selected_ward(), mask = TRUE)
      png(filename = file, width = 800, height = 800)
      plot(ward_fcover)
      dev.off()
    }
  )
}

shinyApp(ui = ui, server = server)
