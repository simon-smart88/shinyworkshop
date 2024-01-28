library(shiny)

ui <- fluidPage(
  fileInput("upload", "Upload data"),
  uiOutput("x_column_out"),
  uiOutput("y_column_out"),
  plotOutput("plot")
)

server <- function(input, output) {

  #read the csv after uploading
  df <- reactive({
    req(input$upload) #dependent on the file having been uploaded
    read.csv(input$upload$datapath)
    })

  output$x_column_out <- renderUI({
    req(input$upload) #you could use req(df()) too, but the effect is the same
    selectInput("x_column", "X column", choices = colnames(df()))
    })

  output$y_column_out <- renderUI({
    req(input$upload)
    selectInput("y_column", "Y column", choices = colnames(df()))
    })

  output$plot <- renderPlot({
    req(input$upload)
    plot(df()[[input$x_column]],
         df()[[input$y_column]],
         xlab = input$x_column,
         ylab = input$y_column)
  })


}

shinyApp(ui = ui, server = server)
