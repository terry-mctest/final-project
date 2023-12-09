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
      h1("WELCOME TO THE WINE QUALITY DATA TOOL", align = "center"),
      br(),
      'The Wine Quality Data Tool is designed to facilitate use of the Wine Quality data made available by the UC-Irvine Machine Learning Repository at ',
      tags$a(href = "https://archive.ics.uci.edu/dataset/186/wine+quality", "https://archive.ics.uci.edu/dataset/186/wine+quality"),'. The data in question are comprised of subjective quality ratings and various physicochemical measures associated with over 4,000 red and white variants of the Portuguese "Vinho Verde" wines. These measures include:',
      tags$ul(
        tags$li("Fixed acidity"), 
        tags$li("Volatile acidity"),
        tags$li("Citric acid"), 
        tags$li("Residual sugar"),
        tags$li("Chlorides"), 
        tags$li("Free sulfur dioxide"),
        tags$li("Total sulfur dioxide"), 
        tags$li("Density"),
        tags$li("pH"), 
        tags$li("Sulphates"),
        tags$li("Alcohol"), 
        tags$li("Quality (on a 0-10 rating scale)"),
        tags$li("Type (red or white)"), 
      ),
      h3("Features of This Tool"),
      "This tool is comprised of the following three primary tabs, with the second and third of these tabs allowing users to drill down to various sub-tabs:",
      tags$ul(
        tags$li(strong(tags$i("About.")), "Basic information about the tool"), 
        tags$li(strong(tags$i("Data Exploration,")),"which contains the following sub-tabs:"),
          tags$ul(
            tags$li(tags$i("Basic descriptives:")," This tab allows for generation of uni- and bi-variate visualizations and summary statistics"),
            tags$li(tags$i("Associations with wine quality:")," This tab allows for generation of multivariate visualizations and summary statistics regarding associations between wine type, physicochemical properties, and wine quality"),
          ),
        tags$li(strong(tags$i("Modeling,")),"which contains the following sub-tabs:"),
          tags$ul(
            tags$li(tags$i("Modeling info:"),""),
            tags$li(tags$i("Model fitting:"),""),
            tags$li(tags$i("Prediction:"),"")
          ),
      ),
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
    
    
    ##########################
    # *DATA EXPLORATION* TAB #
    ##########################
    tabPanel("DATA EXPLORATION",
      tabsetPanel(

        #################################
        # *BASIC DESCRIPTIVES* (sub)TAB #
        #################################
        tabPanel("Basic descriptives",
          sidebarLayout(
            sidebarPanel(
              selectInput("bd_dropdown", "First, select measure of interest:",
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
                radioButtons("bd_radio", "Then select preferred disaggregation/filtering approach:",
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
              selectInput("q_dropdown", "First, select measure of interest:",
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
              radioButtons("plot_type_radio", "Then select desired plot type:",
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

        
    ##################
    # *MODELING* TAB #
    ##################
    tabPanel("MODELING",
      tabsetPanel(

        ############################
        # *MODELING INFO* (sub)TAB #
        ############################
        
        tabPanel("Modeling Info" 
        ),

                        
        ###############################
        # *MODELING FITTING* (sub)TAB #
        ###############################
        
        tabPanel("Model Fitting",
          titlePanel(h2("MODELING WINE QUALITY", align="center")),
          sidebarLayout(
            sidebarPanel(
              useShinyjs(), #allow for jumping to the top of mainpanel output
              radioButtons("model_radio", 
                           "First, select the type of model to be fit:",
                choices = c("Multiple linear regression (MLR)" = 1, 
                            "Random forest (RF)" = 2,
                            "Both MLR and RF" = 3), 
                selected = 1),
              br(),
              sliderInput("slider", label="Next, define the proportion of records to be randomly selected for use in model training (records not used for model training will be used for model testing):", 
                          min=50, max=90, value=80, step=1, post="%"),
              br(),
              numericInput("cv", "Then select the desired number of cross-validation folds (between 3 and 6):", 3, min = 3, max = 6),
              br(),
              conditionalPanel(condition = "input.model_radio != 1",
                  numericInput("div", "RF tuning parameter divisor:", 2, 
                               min = 1.25, max = 5, step = 0.25)),
              br(),
              conditionalPanel(condition = "input.model_radio != 2",
                checkboxGroupInput("mlr_preds", 
                      "Don't forget to select right-side variables for your MLR model!",
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
                              "type")# = 13),
              )),
              br(),
              conditionalPanel(condition = "input.model_radio != 1",
                checkboxGroupInput("rf_preds", 
                      "Don't forget to select right-side variables for your RF model!",
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
                              "type")# = 13),
              )),
              actionButton("run_model", "Click here to run model")
            ),
            mainPanel(
                strong(h3(textOutput("m1_title"))),
                verbatimTextOutput("m1"),
                strong(h3(textOutput("m2_title"))),
                verbatimTextOutput("m2"),
                strong(h3(textOutput("m3_title"))),
                verbatimTextOutput("m3"),
                strong(h3(textOutput("m4_title"))),
                verbatimTextOutput("m4")
              )
          )
        ),

                        
        #########################
        # *PREDICTION* (sub)TAB #
        #########################
        
        tabPanel("Prediction",
          titlePanel(h2("PREDICTING WINE QUALITY", align="center")),
          strong('If you have already fit a model on the "Model Fitting" tab, you can then predict wine quality for a specific wine by selecting the feature values of said wine using the inputs to follow (each feature below is initialized to its mean value in the wine quality data); after doing so, click on "Predict Wine Quality" to obtain wine quality rating(s) as predicted by your model(s).'),
          sidebarLayout(
            sidebarPanel(
              
              #--initialize predictor vars to mean value in our input data
              #--dont constrain to actual min/max, but constrain to values which
              #  are "just outside" the actual min/max
              #--adjust "steps" and "digits" based on values in the input data
              
              numericInput("fixed_acidity_p", "fixed acidity:", 
                           round(mean(red_and_white$fixed_acidity),digits=1), 
                           min = 0, max = 20, step = 0.1),
              numericInput("volatile_acidity_p", "volatile acidity:", 
                           round(mean(red_and_white$volatile_acidity),digits=1),
                           min = 0, max = 2, step = 0.1),
              numericInput("citric_acid_p", "citric acid:",
                           round(mean(red_and_white$citric_acid),digits=1), 
                           min = 0, max = 2, step = 0.1),
              numericInput("residual_sugar_p", "residual sugar:", 
                           round(mean(red_and_white$residual_sugar),digits=1), 
                           min = 0, max = 70, step = 1),
              numericInput("chlorides_p", "chlorides:",
                           round(mean(red_and_white$chlorides),digits=1), 
                           min = 0, max = 1, step = 0.1),
              numericInput("free_sulfur_dioxide_p", "free sulfur dioxide:", 
                           round(mean(red_and_white$free_sulfur_dioxide),
                                 digits=0), 
                           min = 0, max = 300, step = 1),
              numericInput("total_sulfur_dioxide_p", "total sulfur dioxide:", 
                           round(mean(red_and_white$total_sulfur_dioxide),
                                 digits=0), 
                           min = 0, max = 500, step = 1),
              numericInput("density_p", "density:", 
                           round(mean(red_and_white$density),digits=3), 
                           min = 0, max = 1.5, step = 0.001),
              numericInput("p_h_p", "pH:",
                           round(mean(red_and_white$p_h),digits=1), 
                           min = 1, max = 5, step = 0.1),
              numericInput("sulphates_p", "sulphates:",
                           round(mean(red_and_white$sulphates),digits=1), 
                           min = 0, max = 2, step = 0.1),
              numericInput("alcohol_p", "alcohol:", 
                           round(mean(red_and_white$alcohol),digits=1), 
                           min = 0, max = 15, step = 0.1),
              selectInput("type_p", "Type:", choices = c("Red", "White")),
              actionButton("predict", "Predict Wine Quality")
            ),
            mainPanel(
            )
          )
        )
      )
    )
  )
)
