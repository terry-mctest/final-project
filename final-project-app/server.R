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

#results for *type* var (all other vars are continuous)
if(input$bd_dropdown=="type"){
  #output plot
  output$bd_plot <- renderPlot({
      ggplot(data=red_and_white, aes(x=type)) + geom_bar() + 
      labs(title = "Number of Wines, by Wine Type")
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
      labs(title = "Distribution Among Reds vs. Distribution Among Whites") +
      scale_fill_discrete(name = "Wine Type") 
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
      labs(title = "Distribution Among Red Wines Only")
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
      labs(title = "Distribution Among White Wines Only")
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
      labs(title = "Distribution Among All Red & White Wines")
    	})
    
  #output table
  #https://stackoverflow.com/questions/63484862/display-a-summary-of-a-variable-in-a-shiny-app-summary
  output$bd_table <- renderTable({
      tibble::tibble(!!!summary(red_and_white[,input$bd_dropdown]))
  })
}
  
})

})
