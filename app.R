library(shiny)

ui <- fluidPage(
  titlePanel("Baby Names Explorer (Coming Soon)"),
  mainPanel(
    h3("This app is under construction")
  )
)

server <- function(input, output, session) {
  # Nothing yet
}

shinyApp(ui = ui, server = server)