library(shiny)

ui <- fluidPage(
  sliderInput("petal_length", "Petal length", min = 0, max = 10, value = c(2, 5), step = 0.1),
  numericInput("petal_width", "Minimum petal width", value = 0),
  selectInput("species", "Species", choices = unique(iris$Species)),
  tableOutput("table")
)

server <- function(input, output) {

  output$table <- renderTable({iris[iris$Petal.Length >= input$petal_length[1] &
                                    iris$Petal.Length <= input$petal_length[2] &
                                    iris$Sepal.Width >= input$petal_width &
                                    iris$Species == input$species,]})
}

shinyApp(ui = ui, server = server)
