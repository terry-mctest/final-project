#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(readr)
library(ggplot2)
library(janitor)
library(tidyr)
library(dplyr)
library(stringr)
library(caret)
library(randomForest)
library(shinyjs)



    #data for red+white wines
    red_and_white <- data.frame(read_csv("winequality-full.csv"))
    red_and_white <- clean_names(red_and_white)
    red_and_white$type <- as.factor(red_and_white$type)

    #data for red only
    red_only <- subset(red_and_white, type == "Red")
     
    #data for white only
    white_only <- subset(red_and_white, type == "White")

    



shinyServer(function(input, output, session) {



    
#################################  
# *BASIC DESCRIPTIVES* (sub)TAB #
#################################

observe({
  
#results for *type* var (all other vars are continuous)
if(input$bd_dropdown=="type"){
  #output plot
  output$bd_plot <- renderPlot({
      ggplot(data=red_and_white, aes(x=type)) + geom_bar() + 
      labs(title = "Number of Wines, by Wine Type") +
      theme(plot.title = element_text(face="bold", size=16))
    	})
  
  #output table
  output$bd_table <- renderTable({
      t <- data.frame(table(red_and_white$type))
      t <- rename(t, Type=Var1)
  })
  }

    
#when disaggregation is requested
else if(input$bd_radio==1){
  #output plot
  output$bd_plot <- renderPlot({
      var_num <- input$bd_dropdown
      ggplot(data=red_and_white, aes(x=!!sym(input$bd_dropdown), fill=type)) + 
    	geom_density(adjust = 0.5, alpha = 0.5) + 
      labs(title = 
          "DISTRIBUTION AMONG RED WINES vs. DISTRIBUTION AMONG WHITE WINES") +
      scale_fill_discrete(name = "Wine Type") +
      theme(plot.title = element_text(face="bold", size=16)) 
    	})
  
  #output table
  #https://stackoverflow.com/questions/63484862/display-a-summary-of-a-variable-in-a-shiny-app-summary
  output$bd_table <- renderTable({
      r <- tibble::tibble(!!!summary(red_only[,input$bd_dropdown]))
      w <- tibble::tibble(!!!summary(white_only[,input$bd_dropdown]))
      b <- bind_rows(r,w)
      t <- data.frame(Type = c("Red","White"))
      f <- bind_cols(t, b)
  })
  }

  
#when red only is requested
else if(input$bd_radio==2){
  output$bd_plot <- renderPlot({
      var_num <- input$bd_dropdown
      ggplot(data=red_only, aes(x=!!sym(input$bd_dropdown))) + 
    	geom_density(adjust = 0.5, alpha = 0.5) + 
      labs(title = "DISTRIBUTION AMONG RED WINES ONLY") +
      theme(plot.title = element_text(face="bold", size=16))
    	})
  
  #output table
  #https://stackoverflow.com/questions/63484862/display-a-summary-of-a-variable-in-a-shiny-app-summary
  output$bd_table <- renderTable({
      tibble::tibble(!!!summary(red_only[,input$bd_dropdown]))
  })
  }

  
#when white only is requested
else if(input$bd_radio==3){
  output$bd_plot <- renderPlot({
      var_num <- input$bd_dropdown
      ggplot(data=white_only, aes(x=!!sym(input$bd_dropdown))) + 
    	geom_density(adjust = 0.5, alpha = 0.5) + 
      labs(title = "DISTRIBUTION AMONG WHITE WINES ONLY") +
      theme(plot.title = element_text(face="bold", size=16))
    	})
    
  #output table
  #https://stackoverflow.com/questions/63484862/display-a-summary-of-a-variable-in-a-shiny-app-summary
  output$bd_table <- renderTable({
      tibble::tibble(!!!summary(white_only[,input$bd_dropdown]))
  })
}
  
  
#when red + white, but no disaggregation is requested   
else if(input$bd_radio==4){
  output$bd_plot <- renderPlot({
      var_num <- input$bd_dropdown
      ggplot(data=red_and_white, aes(x=!!sym(input$bd_dropdown))) + 
    	geom_density(adjust = 0.5, alpha = 0.5) + 
      labs(title = "DISTRIBUTION AMONG ALL WINES (both red and white)") +
      theme(plot.title = element_text(face="bold", size=16))
    	})
    
  #output table
  #https://stackoverflow.com/questions/63484862/display-a-summary-of-a-variable-in-a-shiny-app-summary
  output$bd_table <- renderTable({
      tibble::tibble(!!!summary(red_and_white[,input$bd_dropdown]))
  })
}
  
})
  
  
  
#############################################  
# *ASSOCIATIONS WITH WINE QUALITY* (sub)TAB #
#############################################

observe({
  
#scatter/jitterplot w/disaggegation by type
if(input$plot_type_radio==1 & input$wine_type_radio==1){
  output$q_plot <- renderPlot({
      ggplot(data=red_and_white, aes(x=!!sym(input$q_dropdown), y=quality, 
                                     color=type, position="jitter")) + 
    	geom_jitter() + geom_smooth(method = "lm") + 
      labs(y = "Wine Quality Rating",
           title = paste0("WINE QUALITY RATING, by WINE TYPE and ",
                          #(str_to_upper(aes_string(input$q_dropdown))))) +
                          (aes_string(input$q_dropdown)))) +
      theme(plot.title = element_text(face="bold", size=16))
    	})
}

#scatter/jitterplot w/o disaggegation by type
else if(input$plot_type_radio==1 & input$wine_type_radio != 1){
  output$q_plot <- renderPlot({
      ggplot(data=red_and_white, aes(x=!!sym(input$q_dropdown), y=quality)) + 
    	geom_jitter() + geom_smooth(method = "lm") + 
      labs(y = "Wine Quality Rating",
           title = 
             paste0("ALL WINES (both red & white): WINE QUALITY RATING by ",
                          #(str_to_upper(aes_string(input$q_dropdown))))) +
                          (aes_string(input$q_dropdown)))) +
      theme(plot.title = element_text(face="bold", size=16))
    	})
}
  
#boxplot w/disaggregation by type
else if(input$plot_type_radio==2 & input$wine_type_radio==1){
  output$q_plot <- renderPlot({
      ggplot(data=red_and_white, aes(x=!!sym(input$q_dropdown), 
                                     y = as.factor(quality))) + 
    	geom_boxplot() + 
      facet_wrap(~type) +
      labs(y = "Wine Quality Rating",
           title = paste0("WINE QUALITY RATING, by WINE TYPE and ",
                          #(str_to_upper(aes_string(input$q_dropdown))))) +
                          (aes_string(input$q_dropdown)))) +
      theme(plot.title = element_text(face="bold", size=16))
    	})
}

#boxplot w/o disaggregation by type
else if(input$plot_type_radio==2 & input$wine_type_radio != 1){
  output$q_plot <- renderPlot({
      ggplot(data=red_and_white, aes(x=!!sym(input$q_dropdown), 
                                     y = as.factor(quality))) + 
    	geom_boxplot() + 
      labs(y = "Wine Quality Rating", 
           title = 
             paste0("ALL WINES (both red & white): WINE QUALITY RATING by ",
                          #(str_to_upper(aes_string(input$q_dropdown))))) +
                          (aes_string(input$q_dropdown)))) +
      theme(plot.title = element_text(face="bold", size=16))
    	})
  
}

#generate correlation coefficients to accompany the jitter/box plots above
if(input$wine_type_radio == 1){ 
  temp <- red_and_white %>% 
  select(type, quality, !!sym(input$q_dropdown)) %>%
  group_by(type) %>%
  summarize(r = cor(quality, (!!sym(input$q_dropdown))))

  output$q_table <- renderTable({
      as_tibble(temp)
      })
} 
else if(input$wine_type_radio != 1){
  temp <- red_and_white %>% 
  select(quality, !!sym(input$q_dropdown)) %>%
  summarize(r = cor(quality, (!!sym(input$q_dropdown))))
  
  output$q_table <- renderTable({
      #as_tibble(cor(temp))
      as_tibble(temp)
      })
}  

})
  

  
############################
# *MODEL FITTING* (sub)TAB #
############################  
 
observeEvent(input$run_model, {

  
#jump to top of output screen
shinyjs::runjs("window.scrollTo(0, 0)")
  
#grey out results of previous model run (if any)
output$m1_title <- NULL
output$m1 <- NULL
output$m2_title <- NULL
output$m2 <- NULL
output$m3_title <- NULL
output$m3 <- NULL
output$m4_title <- NULL
output$m4 <- NULL

mlr_train_results <- NULL
rf_train_results <- NULL

  
  
  
#PREP DATA and RUN MODELS
#(allow for different predictors being selected for MLR vs. RF)
  
#multiple linear regression
if(input$model_radio %in% c(1,3) & is.null(input$mlr_preds)==0){

  #subset data to selected variables
  mlr_dat <- red_and_white %>% select(quality, input$mlr_preds)
  
  #split into train vs test data
  set.seed(433)
  mlr_index <- createDataPartition(mlr_dat$quality, p=(input$slider/100), 
                                    list=FALSE)
  mlr_train_dat <- mlr_dat[mlr_index,]
  mlr_test_dat <- mlr_dat[-mlr_index,]

    #train on training data
    mlr_train_results <- train(quality ~ ., data = mlr_train_dat,
        method="lm", 
        preProcess=c("center","scale"),
        trControl=trainControl(method = "cv", number = input$cv)
        )
    
    #test on testing data
    mlr_test_results <- predict(mlr_train_results, newdata = mlr_test_dat)
}
  
  
#random forest
if(input$model_radio %in% c(2,3) & is.null(input$rf_preds)==0){
  
  #subset data to selected variables
  rf_dat <- red_and_white %>% select(quality, input$rf_preds)
  
  #split into train vs test data
  set.seed(433)
  rf_index <- createDataPartition(rf_dat$quality, p=(input$slider/100), 
                                    list=FALSE)
  rf_train_dat <- rf_dat[rf_index,]
  rf_test_dat <- rf_dat[-rf_index,]

  #tuning parameter divisor
  #setting up tuning parameter in this way so as to avoid complications 
  #re: tuning parameter that is greater than the number of predictor
  #variables selected
  if(ncol(rf_train_dat)==2){mtry_value <- 1}
  else if(ncol(rf_train_dat) > 2){
    mtry_value <- (round((ncol(rf_train_dat)/input$div),digits=0))}

    
  withProgress(message = "Fitting model, thanks for your patience...",{  
    rf_train_results <- train(quality ~ ., data = rf_train_dat,
        method="rf", 
        preProcess=c("center","scale"),
        trControl=trainControl(method = "cv", number = input$cv),
        tuneGrid=data.frame(mtry = mtry_value)
        )
    
    rf_test_results <- predict(rf_train_results, newdata = rf_test_dat)
    
    #facilitate display of progress bar    
    for (i in 1:15) {
    incProgress(1/15)
    Sys.sleep(0.25)
    }
  })
}

    
  

#OUTPUT
  
#output assuming MLR only is selected
if(input$model_radio==1 & is.null(input$mlr_preds)==0){
    output$m1_title <- renderText("MLR Model Summary (Training Data):")
    output$m1 <- renderPrint({summary(mlr_train_results)})
  
    output$m2_title <- renderText("MLR Fit Statistics (Training Data):")
    output$m2 <- renderPrint({mlr_train_results})

    output$m3_title <- renderText("MLR Fit Statistics (Test Data):")
    output$m3 <- renderPrint({
      postResample(mlr_test_results, obs = mlr_test_dat$quality)
      })  
    
    output$m4_title <- NULL
    output$m4 <- NULL
}
  
  
#output assuming RF only is selected
else if(input$model_radio==2 & is.null(input$rf_preds)==0){
    output$m1_title <- renderText("RF Fit Statistics (Training Data):")
    output$m1 <- renderPrint({rf_train_results})
 
    output$m2_title <- renderText("RF Variable Importance (Training Data):")
    output$m2 <- renderPrint({varImp(rf_train_results)})  

    output$m3_title <- renderText("RF Fit Statistics (Test Data):")
    output$m3 <- renderPrint({
      postResample(rf_test_results, obs = rf_test_dat$quality)     
      })
    
    output$m4_title <- NULL
    output$m4 <- NULL
}
  
  
#output assuming MLR+RF only is selected
else if(input$model_radio==3 & is.null(input$mlr_preds)==0 & is.null(input$rf_preds)==0){
    
    output$m1_title <- renderText("MLR Model Summary (Training Data):")
    output$m1 <- renderPrint({summary(mlr_train_results)})
  
    output$m2_title <- renderText("RF Variable Importance (Training Data):")
    output$m2 <- renderPrint({varImp(rf_train_results)})  


    #df w/ training-data fit statistics for both MLR + RF    
    train_compare <-
      data.frame(t(mlr_train_results$results[,2:6]),
                 t(rf_train_results$results[,2:6]))
    colnames(train_compare)[1] <- 'MLR'
    colnames(train_compare)[2] <- 'RF'

    output$m3_title <- renderText("MLR vs. RF Fit Statistics (Training Data):")
    output$m3 <- renderPrint({train_compare})  

    
    #df w/ test-data fit statistics for both MLR + RF    
    mlr <- postResample(mlr_test_results, obs = mlr_test_dat$quality)       
    rf <- postResample(rf_test_results, obs = rf_test_dat$quality)
    
    test_compare <- bind_rows(mlr, rf)
    rownames(test_compare)[1] <- 'MLR'
    rownames(test_compare)[2] <- 'RF'

    output$m4_title <- renderText("MLR vs. RF Fit Statistics (Test Data):")
    output$m4 <- renderPrint({t(test_compare)})  
}
  

#if "run model" has been clicked, but no predictors are selected
else if((input$model_radio==1 & is.null(input$mlr_preds)==1) |
   (input$model_radio==2 & is.null(input$rf_preds)==1)){
    output$m1_title <- renderText("Sorry, please select right-side variables for your model!")
    output$m1 <- NULL
    output$m2_title <- NULL
    output$m2 <- NULL
    output$m3_title <- NULL
    output$m3 <- NULL
    output$m4_title <- NULL
    output$m4 <- NULL
  }  
else if(input$model_radio==3 & 
        (is.null(input$mlr_preds)==1 | is.null(input$rf_preds)==1)){
    output$m1_title <- renderText("Sorry, please select right-side variables for your model!")
    output$m1 <- NULL
    output$m2_title <- NULL
    output$m2 <- NULL
    output$m3_title <- NULL
    output$m3 <- NULL
    output$m4_title <- NULL
    output$m4 <- NULL
}   


  
  
#########################
# *PREDICTION* (sub)TAB #
#########################  

if(input$model_radio %in% c(1,3) & is.null(mlr_train_results)==0){
  mlr_pred <- predict(mlr_train_results, new_data=
                        data.frame(
                          fixed_acidity = input$fixed_acidity_p,
                          volatile_acidity = input$volatile_acidity_p,
                          citric_acid = input$citric_acid_p,
                          residual_sugar = input$residual_sugar_p,
                          chlorides = input$chlorides_p,
                          free_sulfur_dioxide = input$free_sulfur_dioxide_p,
                          total_sulfur_dioxide = input$total_sulfur_dioxide_p,
                          density = input$density_p,
                          p_h = input$p_h_p,
                          sulphates = input$sulphates_p,
                          alcohol = input$alcohol_p,
                          type = input$type_p),
                     se.fit = TRUE, interval = "confidence")
  }

  
if(input$model_radio %in% c(2,3) & is.null(rf_train_results)==0){
  rf_pred <- predict(rf_train_results, new_data=
                        data.frame(
                          fixed_acidity = input$fixed_acidity_p,
                          volatile_acidity = input$volatile_acidity_p,
                          citric_acid = input$citric_acid_p,
                          residual_sugar = input$residual_sugar_p,
                          chlorides = input$chlorides_p,
                          free_sulfur_dioxide = input$free_sulfur_dioxide_p,
                          total_sulfur_dioxide = input$total_sulfur_dioxide_p,
                          density = input$density_p,
                          p_h = input$p_h_p,
                          sulphates = input$sulphates_p,
                          alcohol = input$alcohol_p,
                          type = input$type_p),
                     se.fit = TRUE, interval = "confidence")
  }


observeEvent(input$predict, {

  if(input$model_radio %in% c(1,3) & is.null(mlr_train_results)==0){
    output$p1_title <- renderText("Predicted Wine Quality per MLR Model")
    output$p1 <- renderPrint({mlr_pred})
    }

  
  if(input$model_radio %in% c(2,3) & is.null(rf_train_results)==0){
    output$p2_title <- renderText("Predicted Wine Quality per RF Model")
    output$p2 <- renderPrint({rf_pred})
    }    
  
})

})




})
