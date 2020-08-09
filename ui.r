library(DT)
library(shiny)
library(shinydashboard)

demo<-read.csv(file='~/Desktop/NYCDSA/R/Shiny_Project/App/demo.csv',stringsAsFactors = FALSE)

shinyUI(dashboardPage(
  dashboardHeader(title="Seperate and Unequal"),
####Sidebar with two selection inputs for demo data and a checkbox to layer economic need index###
  dashboardSidebar(
    sidebarUserPanel("Yaniv Yaffe"),
    sidebarMenu(
      menuItem("Demographics", tabName = "demographics"),
      menuItem("Map", tabName = "map"),
      menuItem("T-Test", tabName = "t_test")
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem("demographics",
              h2("NYC Public Schools Demographic Breakout"),
              fluidRow(
                column(7,
                selectizeInput(inputId = "demo1",
                               label = "Select Two Student Demographics to Compare:",
                               choices = colnames(demo)[seq(25,39,2)],
                               selected = 'White.'),
                selectizeInput(inputId = "demo2",
                               label="",
                               choices = colnames(demo)[seq(25,39,2)],
                               selected = 'Black.'),
                checkboxInput("EconData", 
                              label = "Overlay Economic Need Index", 
                              value = FALSE)
                )),
              
              # Show a tabset 1) scatter plot of demographics where each point is a school in NYC
              #               2) density comparison of the two graphs
              fluidRow(
                tabsetPanel(
                  tabPanel("Scatter Plot Relationship",
                           plotOutput("scatterPlot"),
                           plotOutput("ENI")
                           ),
                  tabPanel("Density of Demographics", 
                           plotOutput("density")))
                )
              ),
      tabItem("map",
              h2("Map of NYC Public Schools")),
      tabItem("t_test",
              h2("Test for yourself if school performance varies by racial representation at school:"),
              fluidRow(
                column(7, 
                       selectizeInput(inputId = "sqr_category",
                               label = "Select an SQR Category",
                               choices = colnames(demo)[45:61]),
                selectizeInput(inputId = "sqr_performance",
                               label = "Select a grade for this SQR Category",
                               choices = unique(demo[45]))
                )),
              fluidRow(
                plotOutput("boxPlot")
              )
              )
    )
)
))
