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
# library(car)



    #data for red+white wines
    red_and_white <- data.frame(read_csv("winequality-full.csv"))
    red_and_white <- clean_names(red_and_white)
    red_and_white$type <- as.factor(red_and_white$type)

    #data for red only
    red_only <- subset(red_and_white, type == "Red")
     
    #data for white only
    white_only <- subset(red_and_white, type == "White")

    



shinyServer(function(input, output, session) {

observe({

    
#################################  
# *BASIC DESCRIPTIVES* (sub)TAB #
#################################

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

  
  
  
#############################################  
# *ASSOCIATIONS WITH WINE QUALITY* (sub)TAB #
#############################################

#scatter/jitterplot w/disaggegation by type
if(input$plot_type_radio==1 && input$wine_type_radio==1){
  output$q_plot <- renderPlot({
      ggplot(data=red_and_white, aes(x=!!sym(input$q_dropdown), y=quality, 
                                     color=type, position="jitter")) + 
    	geom_jitter() + geom_smooth(method = "lm") + 
      labs(y = "Wine Quality Rating",
           title = paste0("WINE QUALITY RATING, by WINE TYPE and ",
                          (str_to_upper(aes_string(input$q_dropdown))))) +
      theme(plot.title = element_text(face="bold", size=16))
    	})
}

#scatter/jitterplot w/o disaggegation by type
else if(input$plot_type_radio==1 && input$wine_type_radio != 1){
  output$q_plot <- renderPlot({
      ggplot(data=red_and_white, aes(x=!!sym(input$q_dropdown), y=quality)) + 
    	geom_jitter() + geom_smooth(method = "lm") + 
      labs(y = "Wine Quality Rating",
           title = 
             paste0("ALL WINES (both red & white): WINE QUALITY RATING by ",
                          (str_to_upper(aes_string(input$q_dropdown))))) +
      theme(plot.title = element_text(face="bold", size=16))
    	})
}
  
#boxplot w/disaggregation by type
else if(input$plot_type_radio==2 && input$wine_type_radio==1){
  output$q_plot <- renderPlot({
      ggplot(data=red_and_white, aes(x=!!sym(input$q_dropdown), 
                                     y = as.factor(quality))) + 
    	geom_boxplot() + 
      facet_wrap(~type) +
      labs(y = "Wine Quality Rating",
           title = paste0("WINE QUALITY RATING, by WINE TYPE and ",
                          (str_to_upper(aes_string(input$q_dropdown))))) +
      theme(plot.title = element_text(face="bold", size=16))
    	})
}

#boxplot w/o disaggregation by type
else if(input$plot_type_radio==2 && input$wine_type_radio != 1){
  output$q_plot <- renderPlot({
      ggplot(data=red_and_white, aes(x=!!sym(input$q_dropdown), 
                                     y = as.factor(quality))) + 
    	geom_boxplot() + 
      labs(y = "Wine Quality Rating", 
           title = 
             paste0("ALL WINES (both red & white): WINE QUALITY RATING by ",
                          (str_to_upper(aes_string(input$q_dropdown))))) +
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


  
############################
# *MODEL FITTING* (sub)TAB #
############################  
 
observeEvent(input$run_model, {

  
#data prep
if(is.null(input$predictors)==0){

  #subset data to selected variables
  model_dat <- red_and_white %>% select(quality, input$predictors)
  
  # split into train vs test data
  set.seed(433)
  indextrain <- createDataPartition(1:nrow(model_dat), p=(input$slider/100), 
                                    list=FALSE)
  train_dat <- model_dat[indextrain,]
  test_dat <- model_dat[-indextrain,]
  }
  
  
#multiple linear regression
if(input$model_radio==1 && is.null(input$predictors)==0){

  train_results <- train(quality ~ ., data = train_dat,
      method="lm", 
      preProcess=c("center","scale"),
      trControl=trainControl(method = "cv", number = 5)
      )

  output$train1_title <- renderText("Results from Training Data:")
  output$train1 <- renderPrint({
      summary(train_results)
      })

  output$train2_title <- renderText("Cross-Validation:")
  output$train2 <- renderPrint({
      train_results
      })
    
  output$train_plot_title <- NULL
  output$train_plot <- NULL
}  


#random forest
else if(input$model_radio==2 && is.null(input$predictors)==0){

  train_results <- train(quality ~ ., data = train_dat,
      method="rf", 
      preProcess=c("center","scale"),
      trControl=trainControl(method = "cv", number = 5),
      tuneGrid=data.frame(mtry=c(ncol(train_dat)/3))
      )
  
  output$train1_title <- renderText("Results from Training Data:")
  output$train1 <- renderPrint({
      train_results
      })

  output$train2_title <- NULL
  output$train2 <- NULL

  output$train_plot_title <- renderText("Variable Importance:")
  output$train_plot <- renderPlot({
      plot(varImp(train_results))
    	})  
  }  
  
  
})
  
  
  
#########################
# *PREDICTION* (sub)TAB #
#########################  
  
   
})

})
