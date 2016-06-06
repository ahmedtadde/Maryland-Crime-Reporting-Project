library(shinythemes)
source("helpers.R")
libraries()



shinyUI(fluidPage(theme = shinytheme("united"),
                  titlePanel("Maryland Crime Reporting"),
                  sidebarLayout(
                    sidebarPanel(helpText(""),
                                  
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
                                 em("Murder:  "), textOutput("murder", inline = TRUE),
                                 br(),
                                 em("Rape:  "), textOutput("rape", inline = TRUE),
                                 br(),
                                 em("Robbery:  "),textOutput("robbery", inline = TRUE),
                                 br(),
                                 em("Aggravated Assault:  "),textOutput("assault", inline = TRUE),
                                 br(),
                                 br(),
                                 strong("Total Violent Crimes:  ",style = "color:red"),textOutput("violent", inline = TRUE),
                                 br(),
                                 br(),
                                 br(),
                                 br(),
                                 em("Breaking & Entering:  "),textOutput("breaking_entering", inline = TRUE),
                                 br(),
                                 em("Larceny/Theft:  "),textOutput("larceny", inline = TRUE),
                                 br(),
                                 em("Motor Vehicule Theft:  "),textOutput("vehicule_theft", inline = TRUE),
                                 br(),
                                 br(),
                                 strong("Total Property Crimes:  ",style = "color:red"),textOutput("property", inline = TRUE)
                                 )
                        )
                      )
                    )
                  )
        )

