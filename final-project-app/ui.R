#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
#SEE ALSO 6.3.1 FROM:  https://mastering-shiny.org/action-layout.html

library(shiny)

fluidPage(
  tabsetPanel(
    tabPanel("Import data", 
      fileInput("file", "Data", buttonLabel = "Upload..."),
      textInput("delim", "Delimiter (leave blank to guess)", ""),
      numericInput("skip", "Rows to skip", 0, min = 0),
      numericInput("rows", "Rows to preview", 10, min = 1)
    ),
    tabPanel("Set parameters",
             tabsetPanel(
               tabPanel("subpanel1"),
                tabPanel("subpanel2")
             )),
    tabPanel("Visualise results")
  )
)