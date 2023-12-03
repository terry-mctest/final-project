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

    
    	if(input$bd_radio=="Disaggregate (red vs. white)"){
    	  ggplot(data=red_and_white, aes(x=!!sym(input$bd_dropdown), fill=type)) + 
    	  geom_histogram(adjust = 0.5, alpha = 0.5)
    	} 
      else if(input$bd_radio=="Show red only"){
    	  ggplot(data=red_only, x=!!sym(input$bd_dropdown)) + 
    	  geom_histogram()
    	}
      else if(input$bd_radio=="Show white only"){
    	  ggplot(data=white_only, x=!!sym(input$bd_dropdown)) + 
    	  geom_histogram()
    	}
      else if(input$bd_radio=="No disaggregation/filtering"){
    	  ggplot(data=red_and_white, x=!!sym(input$bd_dropdown)) + 
    	  geom_histogram()
      }

  })
  
  

    output$distPlot <- renderPlot({

        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = 'Waiting time to next eruption (in mins)',
             main = 'Histogram of waiting times')

    })

})
