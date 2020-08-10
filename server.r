library(shiny)
library(ggplot2)
library(dplyr)

demo<-read.csv(file='~/Desktop/NYCDSA/R/Shiny_Project/App/demo.csv',stringsAsFactors = FALSE)

function(input, output, session) {
  
  ##Update options for boxplot:
  
  observe({
    updateSelectizeInput(
    session, "sqr_performance",
    choices = unique(demo[,input$sqr_category])
  )
  })

  ##Reactives for plots
  
  demo_reactive <- reactive({
    demo %>%
      select(demo1 = input$demo1,
             demo2 = input$demo2,
             Economic.Need.Index,
             dummy)
  })
  
  box_reactive <- reactive({
    demo %>%
      filter(demo[,input$sqr_category] == input$sqr_performance) %>%
      select(DBN,White.,Black.,Hispanic.,Asian.) %>%
      gather(key=demographic, value=percentage, 2:5, na.rm = TRUE)
  })
  
  distribution_reactive <- reactive({
    demo %>%
      select(demo1 = input$demo1,
             demo2 = input$demo2) %>%
      gather(key=Demographic, value=Distribution, na.rm = TRUE)
  })

  
  ###Output Plots
  
  
  output$scatterPlot <- renderPlot(
    demo %>%
      select(demo1 = input$demo1,
             demo2 = input$demo2,
             Economic.Need.Index,
             dummy) %>%
      ggplot(aes(x=demo1, y=demo2)) +
      geom_point(aes(color= demo[,input$EconData])) +
      scale_color_gradient(low='yellow',high='red',name="Economic Need Index") +
      xlab(input$demo1) +
      ylab(input$demo2)
      
  )
  
  output$density <- renderPlot(
    demo %>%
      select(demo1 = input$demo1,
             demo2 = input$demo2) %>%
      gather(key=Demographic, value=Distribution, na.rm = TRUE) %>%
      mutate(Demographic = ifelse(Demographic=="demo1",
                                  input$demo1,
                                  input$demo2)) %>%
      ggplot(aes(x=Distribution, fill=Demographic)) +
      geom_density(alpha = .5)
  )
  
  output$FTest <- renderPrint (
    var.test(distribution_reactive()$Distribution ~ distribution_reactive()$Demographic, alternative="two.sided")
    #summary(aov(Distribution ~ Demographic, distribution_reactive()))
  )
  
  output$boxPlot_dynamic <- renderPlot(
   box_reactive() %>%
      ggplot(aes(x=demographic,y=percentage)) +
      geom_boxplot(aes(fill=demographic)) +
      ggtitle("Filtered Subset of Schools") +
      ylim(0,1) + 
      xlab("Demographic") +
      ylab("Percentage") + 
      theme(plot.title = element_text(hjust = 0.5))
  )
  
  output$boxPlot_standard <- renderPlot(
    demo %>%
      select(DBN,White.,Black.,Hispanic.,Asian.) %>%
      gather(key=demographic, value=percentage, 2:5, na.rm = TRUE) %>%
      ggplot(aes(x=demographic,y=percentage)) +
      geom_boxplot(aes(fill=demographic)) +
      ggtitle("Overall Representation of NYC Schools") + 
      xlab("Demographic") +
      ylab("Percentage") + 
      theme(plot.title = element_text(hjust = 0.5))
  )
  
}

# demo %>%
#   select(White.,
#          Black.,
#          Economic.Need.Index,
#          dummy) %>%
#   ggplot(aes(x=White.,y=Black.)) +
#   geom_point(color=demo$dummy)
