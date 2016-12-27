#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# Here are five phrases that return predicted follow-on words:
#
# When you meet someone
# Made my birthday even
# Ughh Going To
# they've decided its more
# Your heart will 

library(shiny)
library(RSQLite)
source("ngramBackoff.R")

# Define UI for application that finds words that complete a phrase
ui <- fluidPage(
   
   # Application title
   titlePanel("Phrase Completer"),
   
   # Sidebar with a text input to enter a phrase 
   sidebarLayout(
      sidebarPanel(
        textInput("phrase", "Enter Phrase:", "")
      ),
      
      # Show a list of highest scoring options
      mainPanel(
         "Result Word Options:",
         textOutput("textResults")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

   output$textResults <- renderText({
     ngram_backoff(input$phrase)
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

