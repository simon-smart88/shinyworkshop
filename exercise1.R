library(shiny)

ui <- fluidPage(
  sliderInput(),
  numericInput(),
  selectInput(),
  tableOutput()
)

server <- function(input, output) {

  data <- iris

  renderTable({})
}

shinyApp(ui = ui, server = server)
