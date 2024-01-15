library(shiny)

ui <- fluidPage(
  fileInput(),
  uiOutput(),
  plotOutput()
)

server <- function(input, output) {

  renderUI(selectInput())

  renderPlot()
}

shinyApp(ui = ui, server = server)
