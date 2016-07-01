library(shinythemes)
source("helpers.R")
libraries()

shinyUI(navbarPage(theme = shinytheme("united"),
                   "Maryland Crime Reporting",
                   
                   tabPanel("choropleth Visulaization",
                            
                            fluidRow(
                              column(4, selectizeInput(
                                'year', 'Choose Year',
                                choices = seq(1975,2013,1)))
                            ),
                            fluidRow(
                              column(9, align= "center",plotlyOutput("map"))
                            ),
                            fluidRow(
                              column(12,DT::dataTableOutput("counties.table"))
                            )
                   ),
                   
                   tabPanel("Summary",
                            

                            fluidRow(
                              column(12, align= "center",plotlyOutput("main"))),
                            fluidRow(column(4),column(4),column(4)),
                            fluidRow(column(4),column(4),column(4)),
                            fluidRow(column(4),column(4),column(4)),

                            fluidRow(
                              column(6, align= "center", plotlyOutput("donut1") ),
                              column(6, align= "center", plotlyOutput("donut2") ))
                   )
                   
                   # tabPanel("Percent Changes from Last Year",
                   #          h2("Percent change relative to previous year"),
                   #          br(),
                   #          br(),
                   #          em("Murder:  "), textOutput("murder", inline = TRUE),
                   #          br(),
                   #          em("Rape:  "), textOutput("rape", inline = TRUE),
                   #          br(),
                   #          em("Robbery:  "),textOutput("robbery", inline = TRUE),
                   #          br(),
                   #          em("Aggravated Assault:  "),textOutput("assault", inline = TRUE),
                   #          br(),
                   #          br(),
                   #          strong("Total Violent Crimes:  ",style = "color:red"),textOutput("violent", inline = TRUE),
                   #          br(),
                   #          br(),
                   #          br(),
                   #          br(),
                   #          em("Breaking & Entering:  "),textOutput("breaking_entering", inline = TRUE),
                   #          br(),
                   #          em("Larceny/Theft:  "),textOutput("larceny", inline = TRUE),
                   #          br(),
                   #          em("Motor Vehicule Theft:  "),textOutput("vehicule_theft", inline = TRUE),
                   #          br(),
                   #          br(),
                   #          strong("Total Property Crimes:  ",style = "color:red"),textOutput("property", inline = TRUE)
                   # )
                  )
        )



# tabPanel("Map",
#          # DT::dataTableOutput("counties.table")
#          # dataTableOutput("counties.table")
#          
#          fluidRow(
#            column(12, align= "center",plotlyOutput("map"))
#          ),
#          
#          fluidRow(
#            column(12,
#                   DT::dataTableOutput("counties.table"
#                   ))
#          )
# ), 
# 
# tabPanel("Summary",
#          
#          fluidRow(
#            column(12, align= "center",plotlyOutput("main"))),
#          
#          fluidRow(
#            column(6, align= "center", plotlyOutput("donut1") ),
#            column(6, align= "center", plotlyOutput("donut2") ))
# ),
# tabPanel("Percent Changes from Last Year",
#          h2("Percent change relative to previous year"),
#          br(),
#          br(),
#          em("Murder:  "), textOutput("murder", inline = TRUE),
#          br(),
#          em("Rape:  "), textOutput("rape", inline = TRUE),
#          br(),
#          em("Robbery:  "),textOutput("robbery", inline = TRUE),
#          br(),
#          em("Aggravated Assault:  "),textOutput("assault", inline = TRUE),
#          br(),
#          br(),
#          strong("Total Violent Crimes:  ",style = "color:red"),textOutput("violent", inline = TRUE),
#          br(),
#          br(),
#          br(),
#          br(),
#          em("Breaking & Entering:  "),textOutput("breaking_entering", inline = TRUE),
#          br(),
#          em("Larceny/Theft:  "),textOutput("larceny", inline = TRUE),
#          br(),
#          em("Motor Vehicule Theft:  "),textOutput("vehicule_theft", inline = TRUE),
#          br(),
#          br(),
#          strong("Total Property Crimes:  ",style = "color:red"),textOutput("property", inline = TRUE)
# )