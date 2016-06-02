library(shinythemes)
source('helpers.R')


shinyUI(fluidPage(theme = shinytheme("united"),
                  titlePanel("Maryland Crime Reporting"),
                  sidebarLayout(
                    sidebarPanel(helpText("Create choropleth of crime level"),
                                  
                                  selectInput("year", 
                                              label = "Choose Year",
                                              choices = seq(1975, 2013, 1),
                                              selected = 1975)
                                  
                                  
                    ),
                    
                    mainPanel(
                      tabsetPanel(
                        tabPanel("Map", plotOutput("map")), 
                        tabPanel("Summary", verbatimTextOutput("summary")), 
                        tabPanel("Table", tableOutput("table")))
                    )
                  )
        ))

