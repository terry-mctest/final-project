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
  
  theme = bslib::bs_theme(bootswatch = "morph"),
  #https://bootswatch.com/

      
  tabsetPanel(
  
    # *ABOUT* TAB
    tabPanel("ABOUT",
      titlePanel("BLAH BLAH BLAH"),
      h1("this is h1"),
      h2("this is h2"),
      h3("this is h3"),
      h4("h4"),
      h5("h5"),
      "no h",
      br(),
      "still no h blah blah blah",
      br(),
      "whatever"
    ),
    
    
    # *DATA EXPLORATION* TAB
    tabPanel("DATA EXPLORATION",
      tabsetPanel(
               
        tabPanel("Basic descriptives",
          #titlePanel("lkjafds"),
          sidebarLayout(
            sidebarPanel(
              selectInput("bd_dropdown", "Select measure of interest:",
                choices = c("fixed_acidity" = 1, 
                            "volatile_acidity" = 2, 
                            "citric_acid" = 3,
                            "residual_sugar" = 4, 
                            "chlorides" = 5, 
                            "free_sulfur_dioxide" = 6,
                            "total_sulfur_dioxide" = 7, 
                            "density" = 8, 
                            "pH" = 9, 
                            "sulphates" = 10,
                            "alcohol" = 11, 
                            "quality" = 12, 
                            "type" = 13),
                selected = 1),
              br(),
              #conditionalPanel(condition = "input.bd_dropdown != 'type'",
                radioButtons("bd_radio", "Disaggregate/filter by wine type?",
                  choices = c("Disaggregate (red vs. white)" = 1, 
                              "Show red only" = 2,
                              "Show white only" = 3, 
                              "No disaggregation/filtering" = 4),
                selected = 1#)
              )
            ),
            mainPanel(
              plotOutput("bd_plot")
            )
          )
        ), 

        tabPanel("Associations with wine quality")
        )
    ),

        
    # *MODELING* TAB
    tabPanel("MODELING",
      tabsetPanel(
               
        tabPanel("Modeling Info", 
          fileInput("file", "Data", buttonLabel = "Upload..."),
          textInput("delim", "Delimiter (leave blank to guess)", ""),
          numericInput("skip", "Rows to skip", 0, min = 0),
          numericInput("rows", "Rows to preview", 10, min = 1)),
                
        tabPanel("Model Fitting"),
                
        tabPanel("Prediction")
      )
    )
  )
)