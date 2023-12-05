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
  
    ###############
    # *ABOUT* TAB #
    ###############
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

        #################################
        # *BASIC DESCRIPTIVES* (sub)TAB #
        #################################
        tabPanel("Basic descriptives",
          sidebarLayout(
            sidebarPanel(
              selectInput("bd_dropdown", "Select measure of interest:",
                choices = c("fixed_acidity",# = 1, 
                            "volatile_acidity",# = 2, 
                            "citric_acid",# = 3,
                            "residual_sugar",# = 4, 
                            "chlorides",# = 5, 
                            "free_sulfur_dioxide",# = 6,
                            "total_sulfur_dioxide",# = 7, 
                            "density",# = 8, 
                            "p_h",# = 9, 
                            "sulphates",# = 10,
                            "alcohol",# = 11, 
                            "quality",# = 12, 
                            "type"),# = 13),
                selected = 1),
              br(),
              conditionalPanel(condition = "input.bd_dropdown != 'type'",
                radioButtons("bd_radio", "Disaggregate/filter by wine type?",
                  choices = c("Disaggregate (reds vs. whites)" = 1, 
                              "Show reds only" = 2,
                              "Show whites only" = 3, 
                              "No disaggregation/filtering" = 4),
                selected = 1))
              ),
            mainPanel(
              plotOutput("bd_plot"),
              tableOutput("bd_table")
            )
          ) 
        ),
        
        ##########################################
        # *ASSOCIATIONS W/WINE QUALITY* (sub)TAB #
        ##########################################
        tabPanel("Associations with wine quality",
          sidebarLayout(
            sidebarPanel(
              selectInput("q_dropdown", "Select measure of interest:",
                choices = c("fixed_acidity",# = 1, 
                            "volatile_acidity",# = 2, 
                            "citric_acid",# = 3,
                            "residual_sugar",# = 4, 
                            "chlorides",# = 5, 
                            "free_sulfur_dioxide",# = 6,
                            "total_sulfur_dioxide",# = 7, 
                            "density",# = 8, 
                            "p_h",# = 9, 
                            "sulphates",# = 10,
                            "alcohol"),# = 11), 
                selected = 1),
              br(),
              radioButtons("plot_type_radio", "Desired plot type:",
                choices = c("Scatterplot/Jitterplot" = 1,
                            "Boxplot" = 2),
                selected = 1),
              br(),
              radioButtons("wine_type_radio", "Disaggregate by wine type?",
                  choices = c("Yes" = 1, 
                              "No" = 2),
                selected = 1)
            ),
            mainPanel(
              plotOutput("q_plot"),
              strong("NOTE: Wine quality was rated on a scale of 0 to 10, where 0 indicates the lowest quality, and 10 indicates the highest quality."),
              br(),
              br(),
              h5("Correlation Coefficient(s):"),
              tableOutput("q_table")
            )                 
          )
        )
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
