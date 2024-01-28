library(shiny)

ui <- fluidPage(
  sliderInput(),
  numericInput(),
  selectInput(),
  tableOutput()
)

server <- function(input, output) {

  renderTable({iris})
}

shinyApp(ui = ui, server = server)
