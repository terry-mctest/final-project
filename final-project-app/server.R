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

  

shinyServer(function(input, output, session) {

 
  output$bd_plot <- renderPlot({
    
    #data for red+white wines
    red_and_white <- data.frame(read_csv("winequality-full.csv"))
    red_and_white$quality <- as.factor(red_and_white$quality)	
    red_and_white$quality <- as.factor(red_and_white$type)
    
    #data for red only
    red_only <- subset(red_and_white, type == "Red")
     
    #data for white only
    white_only <- subset(red_and_white, type == "White")

    
      var_num <- input$bd_dropdown
    
    	if(input$bd_radio==1){
    	  ggplot(data=red_and_white, aes(x=(red_and_white[ ,var_num]),
    	                                 fill=type)) + 
    	  geom_density(adjust = 0.5, alpha = 0.5)
    	} 
      else if(input$bd_radio==2){
    	  ggplot(data=red_only, x=(red_only[ ,var_num])) + geom_density()
    	}
      else if(input$bd_radio==3){
    	  ggplot(data=white_only, x=(white_only[ ,var_num])) +
        geom_density()
    	}
      else if(input$bd_radio==4){
    	  ggplot(data=red_and_white, x=(red_and_white[ ,var_num])) +
        geom_density()
      }

  })
  
})
