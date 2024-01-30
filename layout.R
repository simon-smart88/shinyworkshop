
ui <- fluidPage(
  tags$head(
    tags$style(type="text/css", 
               ".shiny-options-group {display:none}"
    )),
  radioButtons("radio","", choices = c(1:4)),
  uiOutput("ui")
)

server <- function(input, output, session){
  
  observe({
    query <- parseQueryString(session$clientData$url_search)
    print(query)
    if (!is.null(query$radio)) {
      updateRadioButtons(session, "radio", selected = as.numeric(query$radio))
    }
  })
  
  output$ui <- renderUI({
    if (input$radio == 4){
    out <- tagList(
    titlePanel("My fourth app"
  ),
    tabsetPanel(
      tabPanel("Tab 1", 
               sidebarLayout(
                 sidebarPanel(
                   numericInput("number", "Pick a number", value = 10),
                   selectInput("select", "Select an animal", choices = c("Cat", "Dog"))
                 ),
                 mainPanel(
                   plotOutput("plot"),
                   tableOutput("table")
                 )
               )
      ),
      tabPanel("Tab 2",
               fluidRow(
                 column(width = 3,
                        textInput("word", "Type a word"),
                        sliderInput("slider", "Pick a value", min = 10, max = 100, value = 50)
                 ),
                 column(width = 6,
                        leafletOutput("map")
                 ),
                 column(width = 3,
                        checkboxInput("check", "Tick me")
                 )
               )
      ),
      tabPanel("Tab 3",
               plotOutput("another_plot")
      )
    ))}
    
    if (input$radio == 1){
      out <- tagList(
        titlePanel(
          "My first Shiny app"
        ),
        sidebarLayout(
          sidebarPanel(
            textInput("name", "What is your name?")
          ),
          mainPanel(
            plotOutput("plot")
          )
        )
      )
    
    }
    if (input$radio == 2){
      out <- tagList(
        titlePanel(
          "My second app"
        ),
        tabsetPanel(
          tabPanel("Tab 1",
            sidebarLayout(
              sidebarPanel(
                textInput("name", "What is your name?")
              ),
              mainPanel(
                plotOutput("plot")
              )
            )),
            tabPanel("Tab 2",
                     plotOutput("another_plot")
                     ),
            tabPanel("Tab 3")

        )
      )
    }
    
    if (input$radio == 3){
      out <- tagList(
        titlePanel( "My third app"),
        fluidRow(
          column(width = 3,
                 textInput("name", "What is your name?")
                 ),
          column(width = 6,
                 plotOutput("plot")
                 ),
          column(width = 3,
                 plotOutput("another_plot")
          )
        )
      )
    }
    out
})
  
  output$plot <- renderPlot(plot(iris$Sepal.Length, iris$Sepal.Width))
  output$another_plot <- renderPlot(plot(iris$Petal.Length, iris$Petal.Width))
}

shinyApp(ui, server, options = list(port = 6110))