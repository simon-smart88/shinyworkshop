library(shiny)
library(leaflet)

ui <- fluidPage(
  fileInput(),
  uiOutput(),
  plotOutput()
)

server <- function(input, output) {

  renderUI(selectInput())

  renderLeaflet()

  leaflet
}

shinyApp(ui = ui, server = server)


shinyscholar::select_query()
