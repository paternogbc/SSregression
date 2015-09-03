library(shiny);library(shinydashboard)

### Title:

header <- dashboardHeader(title = "Sums of Squares")

### SideBar:
sidebar <- dashboardSidebar(
  sidebarMenu(
   menuItem("Graphs", tabName = "graphs", icon = icon("fa fa-circle")),
   menuItem("Raw Data", tabName = "data", icon = icon("fa fa-circle")),
   menuItem("About", tabName = "about", icon = icon("fa fa-info-circle"))
  )
 )


### Dashboard:
body <- dashboardBody(



  ### Tabintes:

  tabItems(

   ### TAB 1 = dashboard:
   tabItem(tabName = "graphs",

   fluidRow(

    # Sample size slider
    box(width = 4, title = "Parameters",
        solidHeader = TRUE, status = "primary",

    sliderInput(inputId = "sample",
                    label = "Sample size",
                    value = 50, min = 10, max = 100),
    sliderInput(inputId = "slope",
               label = "Regression slope",
               value = .25, min = -2, max = 2,step = .25),
    # Sd slider:
    sliderInput(inputId = "SD",
               label = "Standard deviation",
               value = 3, min = 0, max = 50),
    actionButton(inputId = "refresh", label = "Simulate New Data" , 
                 icon = icon("fa fa-refresh"))
    ),

    mainPanel(

     box(width = 6,
         title = "Regression",
         solidHeader = TRUE, status = "primary",
         plotOutput(outputId = "reg")),


     box(width = 6,title = "Sums of Squares Graphs",
         solidHeader = F, status = "primary",
     tabsetPanel(type = "tabs",
                 tabPanel("Total", plotOutput("total")),
                 tabPanel("Regression", plotOutput("regression")),
                 tabPanel("Error", plotOutput("error")),
                 tabPanel("Variance Partition", plotOutput(("variance")))

     )
     )
    ),
    fluidRow(
    box(width = 6,title = "Anova Table",
        solidHeader = FALSE, status = "warning",
        tableOutput(outputId = "anova")),

    box(width = 6,title = "Summary",
        solidHeader = FALSE, status = "warning",
        tableOutput(outputId = "summary")))
   )),

   # TAB 2 = dashboard:

   tabItem(tabName = "data",
           fluidRow(
            box(width = 4, solidHeader = TRUE, status = "primary",
                               title = "Raw Data",
                               dataTableOutput(outputId = "data")),
            box(width = 6, solidHeader = TRUE, status = "primary",
                title = "Data distribution",
                plotOutput(outputId = "histogram"),
                actionButton(inputId = "refresh2", label = "Simulate New Data" , 
                             icon = icon("fa fa-refresh")))

            )
            ),

   # TAB 3 = About
   tabItem(tabName = "about",
           fluidPage(
               box(width = 10,status = "success",
                   shiny::includeMarkdown("README.md"))
           )
           )
           )
   )

ui <- dashboardPage(header, sidebar, body)


