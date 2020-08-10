library(DT)
library(shiny)
library(shinydashboard)

demo<-read.csv(file='~/Desktop/NYCDSA/R/Shiny_Project/App/demo.csv',stringsAsFactors = FALSE)


shinyUI(dashboardPage(
  dashboardHeader(title="Seperate and Unequal"),
####Sidebar with two selection inputs for demo data and a checkbox to layer economic need index###
  dashboardSidebar(
    sidebarUserPanel("Yaniv Yaffe", image = "https://cdn0.iconfinder.com/data/icons/business-set-1-7/512/17-512.png"),
    sidebarMenu(
      menuItem("Visualizing Racial Segregation", tabName = "demographics", icon = icon("school")),
      #menuItem("Map", tabName = "map"),
      menuItem("School Quality Ratings", tabName = "school_performance", icon = icon("apple-alt"))
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem("demographics",
              h2("NYC Public Schools Demographic Breakout"),
              h3("In the scatterplot below, each point represents a public school in NYC. Each school's placement on the scatterplot represents what percentage of its students belong to each demographic that you select."),
              br(),
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
                radioButtons("EconData", label = "Overlay Economic Need Index:",
                             choices = list("On" = "Economic.Need.Index",
                                            "Off" = "dummy"), 
                             selected = "dummy")
                
                )),
              
              # Show a tabset 1) scatter plot of demographics where each point is a school in NYC
              #               2) density comparison of the two graphs
              fluidRow(
                tabsetPanel(
                  tabPanel("Scatter Plot Relationship",
                           plotOutput("scatterPlot",
                                     ),
                           br(),
                           h5("*A school’s Economic Need is defined by its Economic Need Index (ENI), which determines the likelihood that students at the school are in poverty. For more information, visit https://www.schools.nyc.gov/docs/default-source/default-document-library/diversity-in-new-york-city-public-schools-english")
                           ),
                  tabPanel("Density of Demographics", 
                           plotOutput("density"),
                           verbatimTextOutput("FTest")))
                )
              ),
      # tabItem("map",
      #         h2("Map of NYC Public Schools"),
      #         fluidRow(
      #           
      #         )),
      tabItem("school_performance",
              h2("Test for yourself if school performance varies by racial representation at school:"),
              br(),
              h4("     Select filters to create a subset of schools that recieved certain quality performance ratings in 2019."),
              h4("     Compare your subset (left) to the overall racial distribution displayed to the right side of your subset."),
              br(),
              fluidRow(
                column(7, 
                       selectizeInput(inputId = "sqr_category",
                               label = "Select an SQR Category",
                               choices = colnames(demo)[45:61],
                               selected = "Supportive.Environment.Rating"),
                       selectizeInput(inputId = "sqr_performance",
                               label = "Select a grade for this SQR Category",
                               choices = unique(demo[45]),
                               selected = "Not Meeting Target")
                )),
              fluidRow(
                column(6,plotOutput("boxPlot_dynamic")),
                column(6,plotOutput("boxPlot_standard"))
              ),
              fluidRow(
                br(),
                h5("**For information on how to read a boxplot: https://www.wellbeingatschool.org.nz/information-sheet/understanding-and-interpreting-box-plots")
              )
              )
    )
)
))
