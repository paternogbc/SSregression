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
               value = 3, min = 0, max = 50)),

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
                plotOutput(outputId = "histogram"))

            )
            ),

   tabItem(tabName = "about",
           fluidPage(
               box(width = 10,status = "success",
                h2("About"),
                h6(tags$code("SSregression | v1.0.0")),
                h4("This interactive application allows you to explore how the",
                       "partition of",
                       tags$a("Sums of Squares", href = "https://en.wikipedia.org/wiki/Sum_of_squares"),
                       "are calculated in simple linear regressions. Change one of the parameters ",
                       "to see what happens."),
                br(),
                
                h2("Want to help?"),
                h4("Fork this",
                   tags$a("repo", href = "https://github.com/paternogbc/learnStats/tree/master/apps/SS_regression"),
                   "and create a pull request.",
                   "Please, report bugs",
                   tags$a("here", href = "https://github.com/paternogbc/learnStats/issues"),
                   "."),
                
                br(),
                
                h2("License"),
                h4("This software is under the public license",
                   tags$a("AGPL-3.0 license", href = "http://opensource.org/licenses/AGPL-3.0"),
                   "| The", tags$em("source code")," for this application is available",
                   tags$a("here", href = "https://github.com/paternogbc/learnStats/tree/master/apps/SS_regression"),
                   "."),
                tags$img(height = 80, width = 80,
                         src = "logo.png"),
                
                br(),
                
                h2("Author"),
                h4(tags$a("Gustavo Paterno", href = "https://github.com/paternogbc"),
                "| paternogc@gmail.com"))
           )
           )
           )
   )

ui <- dashboardPage(header, sidebar, body)


