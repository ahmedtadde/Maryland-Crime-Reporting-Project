library(shinythemes)
source('helpers.R')


shinyUI(fluidPage(theme = shinytheme("united"),
                  titlePanel("Maryland Crime Reporting"),
                  sidebarLayout(
                    sidebarPanel(helpText("Create choropleth of crime level"),
                                  
                                  selectInput("year", 
                                              label = "Choose Year",
                                              choices = seq(1975, 2013, 1),
                                              selected = 2013)
                                 )
                    ,
                    
                    mainPanel(
                      tabsetPanel(
                        tabPanel("Map", plotlyOutput("map")), 
                        
                        tabPanel("Summary",
                                 
                                 fluidRow(
                                   column(12, align= "center",plotlyOutput("main"))),

                                 fluidRow(
                                   column(6, align= "center", plotlyOutput("donut1") ),
                                   column(6, align= "center", plotlyOutput("donut2") ))
                                 ),
                        tabPanel("Percent Changes from Last Year",
                                 h2("Percent change relative to previous year"),
                                 br(),
                                 br(),
                                 br(),
                                 br(),
                                 em("Murder:"),
                                 # textOutput("murder"),
                                 br(),
                                 em("Rape:"),
                                 # textOutput("rape"),
                                 br(),
                                 em("Robbery:"),
                                 # textOutput("robbery"),
                                 br(),
                                 em("Aggravated Assault:"),
                                 # textOutput("assault"),
                                 br(), 
                                 h4("Total Violent Crimes:",style = "color:red"),
                                 # textOutput("violent"),
                                 br(),
                                 br(),
                                 em("Breaking & Entering:"),
                                 # textOutput("breaking_entering"),
                                 br(),
                                 em("Larceny/Theft:"),
                                 br(),
                                 # textOutput("larceny"),
                                 em("Motor Vehicule Theft:"),
                                 # textOutput("vehicule_theft"),
                                 br(),
                                 # textOutput("property")),)
                                 h4("Total Property Crimes:",style = "color:red")
                                 )
                        )
                      )
                    )
                  )
        )

