library(shiny)
library(shinyjs)
library(readr)
library(janitor)


    #data for red+white wines
    red_and_white <- data.frame(read_csv("winequality-full.csv"))
    red_and_white <- clean_names(red_and_white)
    red_and_white$type <- as.factor(red_and_white$type)

    
fluidPage(
  
  theme = bslib::bs_theme(bootswatch = "morph"),
  #https://bootswatch.com/
  #solar
  #slate
  #morph

      
  tabsetPanel(
  
    ###############
    # *ABOUT* TAB #
    ###############
    tabPanel("ABOUT",
      titlePanel(h2("WELCOME TO THE WINE QUALITY DATA TOOL", align = "center")),
      br(),
      'The Wine Quality Data Tool is designed to facilitate use of the wine quality data made available by the UC-Irvine Machine Learning Repository at ',
      tags$a(href = "https://archive.ics.uci.edu/dataset/186/wine+quality", "https://archive.ics.uci.edu/dataset/186/wine+quality"),'. Included in these data are (1) a subjective quality rating of each wine, (2) a categorical indicator of wine type (red vs. white), and (3) eleven continuous measures of various physicochemical properties associated with each wine.  The measures in question are available for approximately 6,500 red and white variants of the Portuguese "Vinho Verde" wines.',
      br(), br(),
      div(img(src='17250728595289e_1920_rr.jpg', align = "center",
              height = "75%", width = "75%"), 
              style="text-align: center;"),
      br(),
      h3("Features of This Tool"),
      "A particular focus of this tool is the use of these data to better understand the determinants of wine quality. Users can interact with the data via three primary tabs included within the tool, the second and third of which allow users to drill down to various sub-tabs.  The tabs in question are as follows:",
      tags$ul(
        tags$li("The ",strong(tags$i("About")), "tab, which provides basic information about the tool"), 
        tags$li("The ",strong(tags$i("Data Exploration")),"tab, which contains the following sub-tabs:"),
          tags$ul(
            tags$li(tags$i("Basic descriptives:")," This tab allows for generation of uni- and bi-variate visualizations and summary statistics"),
            tags$li(tags$i("Associations with wine quality:")," This tab allows for generation of multivariate visualizations and summary statistics regarding associations between wine type, physicochemical properties, and wine quality"),
          ),
        tags$li("The ",strong(tags$i("Modeling")),"tab, which contains the following sub-tabs:"),
          tags$ul(
            tags$li(tags$i("Modeling info:"),"This tab provides further detail about the modeling components of the Wine Quality Data Tool"),
            tags$li(tags$i("Model fitting:"),"This tab allows the user to specify models and fit them to the data"),
            tags$li(tags$i("Prediction:"),"This tab allows users to define features of a specific wine and predict the quality of said wine based on models they have fit")
          ),
      ),
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
          titlePanel(h2("DATA EXPLORATION: BASIC DESCRIPTIVES", 
                        align="center")),
          strong("Use the inputs in the left-hand panel below to generate customized uni- and bi-variate data visualizations and corresponding summary statistics."),
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
          titlePanel(h2("DATA EXPLORATION: ASSOCIATIONS WITH WINE QUALITY", 
                        align="center")),
          strong("Use the inputs in the left-hand panel below to investigate the relationship between wine quality and other features of Vinho Verde wines."),
          sidebarLayout(
            sidebarPanel(
              selectInput("q_dropdown", "First, select the measure to investigate relative to wine quality:",
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
              strong("NOTE: Wine quality was rated on a scale of 0 to 10, where 0 indicates the lowest quality, and 10 indicates the highest quality.  See listing to follow for specific correlation coefficients associated with the plot above:"),
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
        
        tabPanel("Modeling Info", 
          titlePanel(h2("MODELING INFO", align = "center")),
          'The current tab provides basic modeling information, especially as it relates to the "Model Fitting" and "Predictions" sub-tabs to follow.  The former of these two sub-tabs allows users to specify models and fit them to the wine quality data, and the latter of these two tabs allows users to make predictions about a specific wine using a model they have fit.',
          br(),
          div(img(src='Minho_Vineyards_Moncao_credit_Alamy_rr.jpg', 
              align = "center",
              height = "65%", width = "65%"), 
              style="text-align: center;"),
          br(),
          'The "Model Fitting" sub-tab allows users to fit either a Multiple Linear Regression (MLR) model, and/or a Random Forest (RF) model; before proceeding, users of the Wine Quality Data Tool may benefit from noting the relative strengths and weaknesses of each of these types of models:',
          br(), br(),
          h4("Multiple Linear Regression"),
          "In a simple linear regression (SLR) model, a given response/dependent variable is defined as a linear function of a single explanatory variable; similarly, in a multiple linear regression (MLR) model, a given response/dependent variable is defined as a linear function of multiple explanatory variables. The basic form of an MLR model is:",
          withMathJax(),
          "$$Y_i = \\beta_0 + \\beta_1 x_{1i} + \\beta_2 x_{2i} + \\dots + E_i$$",
          "where",tags$i("B0"),"is the intercept,",tags$i("B1"),"is the slope associated with the first explanatory variable,",tags$i("x1i"),"is the value of the first explanatory variable for the ith observation,",tags$i("Yi"),"is the value of the response variable for the ith observation, and",tags$i("Ei"),"is the error term associated with the ith observation. The linear function of an MLR model is one which minimizes the sum of squared residuals; that is, the linear function minimizes the sum of squared differences between actual and predicted response values, as represented by the following formula:",
          div("$$\\sum_{i=1}^n(Y_i - \\widehat Y_i)^2$$"),
          'Strengths of MLR models include their relative ease of interpretation (e.g. a given change in a given explanatory variable results in a given change in the response variable), and their ability to quantify the influence of a given explanatory variable relative to that of other explanatory variables.  MLR models are less-than well-equipped, however, to handle situations where there is non-linear relationship between predictors and response (this is at least true of first-order MLR models), and/or when predictor variables are highly correlated.',
          br(), br(),
          h4("Random Forest"),
          'A Random Forest (RF) model is a particular type of tree-based ensemble model.  Tree-based models are ones in which the predictor space is strategically divided into different regions, and the predicted value for any given observation is the most common response value among all other observations in that region; ensemble modeling methods are ones which average predicted outcome values across multiple models in hopes of decreasing the variance of the model.',
          br(), br(),
          'More specifically, a Random Forest model uses bootstrap sampling to create multiple samples, and then fits a different model -- each model using a random subset of predictors (i.e. each model having different numbers and combinations of predictors) -- to each of those bootstrap samples.  After doing so, predicted values are averaged across the multiple models.',
           br(), br(),
          'More blah blah blah',
          br(), br(),
          h4("Other Considerations")
        ),

                        
        ###############################
        # *MODELING FITTING* (sub)TAB #
        ###############################
        
        tabPanel("Model Fitting",
          titlePanel(h2("MODELING WINE QUALITY", align="center")),
          strong('Use the inputs in the left-hand panel below to specify your model(s) of interest, then click the "Fit model(s)" button to fit your models and generate results.  The dependent variable in these models is wine quality, which was rated on a scale of 0 to 10, where 0 indicates the lowest quality and 10 indicates the highest quality.'),
          br(), br(),
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
                  numericInput("div", "RF tuning parameter divisor (i.e. tuning parameter is # of predictors divided by the value selected here):", 2, 
                               min = 1, max = 5, step = 0.25)),
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
              actionButton("run_model", "Click here to fit model(s)")
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
          strong('If you have already fit a model on the "Model Fitting" tab, you can then predict wine quality for a specific wine by selecting the feature values of said wine using the inputs in the left-hand panel below (each feature below is initialized to its mean value in the wine quality data); after selecting feature values, click on "Predict Wine Quality" to obtain wine quality rating(s) as predicted by your model(s). Predictions will be made per the most recent MLR model and/or the most recent RF model which you fit on the "Model Fitting" tab.'),
          br(), br(),
          sidebarLayout(
            sidebarPanel(
              useShinyjs(), #allow for jumping to the top of mainpanel output
              
              #--initialize predictor vars to mean value in our input data
              #--dont constrain to actual min/max, but constrain to values which
              #  are "just outside" the actual min/max
              #--adjust "steps" and "digits" based on values in the input data
              
              strong(h5("Select feature values:")),
              br(),
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
                strong(h3(textOutput("p1_title"))),
                tableOutput("p1"),
                strong(h3(textOutput("p2_title"))),
                tableOutput("p2"),
                strong(h3(textOutput("p3_title"))),
                tableOutput("p3"),
                strong(h3(textOutput("p4_title"))),
                tableOutput("p4"),
            )
          )
        )
      )
    )
  )
)
