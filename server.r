library(shiny)
library(ggplot2)
library(dplyr)

demo<-read.csv(file='~/Desktop/NYCDSA/R/Shiny_Project/App/demo.csv',stringsAsFactors = FALSE)

function(input, output, session) {
  
  observe({
    updateSelectizeInput(
    session, "sqr_performance",
    choices = unique(demo[,input$sqr_category])
  )
  })

  demo_reactive <- reactive({
    demo %>%
      filter(Year=='2019') %>%
      group_by(DBN) %>%
      select(demo1 = input$demo1,
             demo2 = input$demo2,
             Economic.Need.Index)
  })
  
  box_reactive <- reactive({
    demo %>%
      filter(Year=='2019', demo[,input$sqr_category] == input$sqr_performance) %>%
      group_by(DBN) %>%
      select(DBN,White.,Black.,Hispanic.,Asian.) %>%
      gather(key=demographic, value=percentage, 2:5, na.rm = TRUE)
  })
  
  distribution_reactive <- reactive({
    demo %>%
      filter(Year=='2019') %>%
      select(demo1 = input$demo1,
             demo2 = input$demo2) %>%
      gather(key=Demographic, value=Distribution, na.rm = TRUE)
  })
  
  # optionone = function() {
  #   demo %>%
  #   filter(Year=='2019') %>%
  #   group_by(DBN) %>%
  #   select(demo1 = input$demo1,
  #          demo2 = input$demo2,
  #          Economic.Need.Index) %>%
  #       ggplot(aes(x=demo1, y=demo2)) +
  #       geom_point() +
  #       xlab(input$demo1) +
  #       ylab(input$demo2)
  # }
  # 
  # optiontwo = function() {
  #   demo %>%
  #   filter(Year=='2019') %>%
  #   group_by(DBN) %>%
  #   select(demo1 = input$demo1,
  #          demo2 = input$demo2,
  #          Economic.Need.Index) %>%
  #       ggplot(aes(x=demo1, y=demo2)) +
  #       geom_point(aes(color=Economic.Need.Index)) +
  #       scale_color_gradient(low='yellow',high='red') +
  #       xlab(input$demo1) +
  #       ylab(input$demo2)
  # }
  # 
  # output$scatterPlot <- renderPlot(
  #   ifelse(input$EconData,
  #          optiontwo(),
  #          optionone())
  #)
  output$scatterPlot <- renderPlot(
    demo_reactive() %>%
      ggplot(aes(x=demo1, y=demo2)) +
      geom_point() +
      xlab(input$demo1) +
      ylab(input$demo2)
  )
  output$ENI <- renderPlot(
    demo_reactive() %>%
      ggplot(aes(x=demo1, y=demo2)) +
      geom_point(aes(color=Economic.Need.Index)) +
      scale_color_gradient(low='yellow',high='red') +
      xlab(input$demo1) +
      ylab(input$demo2)
  )

  #   observeEvent(input$EconData, {
  #     proxy <- output$scatterPlot
  #   if(input$EconData) {
  #     proxy %>%
  #       geom_point(aes(color=Economic.Need.Index)) +
  #       scale_color_gradient(low='yellow',high='red') +
  #       xlab(input$demo1) +
  #       ylab(input$demo2)
  #   }
  #   else {
  #       proxy
  #   }
  # })
  
  output$density <- renderPlot(
    demo %>%
      filter(Year=='2019') %>%
      select(demo1 = input$demo1,
             demo2 = input$demo2) %>%
      gather(key=Demographic, value=Distribution, na.rm = TRUE) %>%
      mutate(Demographic = ifelse(Demographic=="demo1",
                                  input$demo1,
                                  input$demo2)) %>%
      ggplot(aes(x=Distribution, fill=Demographic)) +
      geom_density(alpha = .5)
  )
  
  output$anovaTest <- renderPrint (
    var.test(distribution_reactive()$Distribution ~ distribution_reactive()$Demographic, alternative="two.sided")
    #summary(aov(Distribution ~ Demographic, distribution_reactive()))
  )
  
  output$boxPlot_dynamic <- renderPlot(
   box_reactive() %>%
      ggplot(aes(x=demographic,y=percentage)) +
      geom_boxplot(aes(fill=demographic)) +
     ggtitle("Filtered Subset of Schools")
  )
  
  output$boxPlot_standard <- renderPlot(
    demo %>%
      filter(Year=='2019') %>%
      group_by(DBN) %>%
      select(DBN,White.,Black.,Hispanic.,Asian.) %>%
      gather(key=demographic, value=percentage, 2:5, na.rm = TRUE) %>%
      ggplot(aes(x=demographic,y=percentage)) +
      geom_boxplot(aes(fill=demographic)) +
      ggtitle("Overall Representation of NYC Schools")
    
  )
}
  
