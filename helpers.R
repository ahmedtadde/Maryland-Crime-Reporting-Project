

libraries <- function(){
  
  library(rsconnect)
  library(DT)
  library(shiny)
  library(XLConnect)
  library(DataCombine)
  library(psych)
  library(scales)
  library(data.table)
  library(plotly)
  library(choroplethr)
  library(choroplethrMaps)
  library(dplyr)
  library(foreach)

}



getStateData <- function(Year){
  
  foreach(j = 1:1)%do%{
    
    df <- readWorksheetFromFile("1975_2013_UCR_Rates_for_Website.xls",
                                sheet=j,
                                startRow = 3, endRow = 42)
    
    
    violent <- c("YEAR","MURDER","RAPE","ROBBERY","AGG..ASSAULT")
    violent.crimes <- select(df, which(names(df)%in%violent))
    violent <- c("year","murder","rape","robbery","aggravated_assault")
    setnames(violent.crimes, names(violent.crimes), violent)
    violent <- violent.crimes ; rm(violent.crimes)
    
    property <- c("YEAR","B...E","LARCENY.THEFT","M.V.THEFT")
    property.crimes <- select(df, which(names(df)%in%property))
    property <- c("year","breaking_entering","larceny_theft","motor_vehicule_theft")
    setnames(property.crimes, names(property.crimes), property)
    property <- property.crimes ; rm(property.crimes)
    
    general <- c("YEAR",
                 "GRAND.TOTAL","PERCENT.CHANGE",
                 "VIOLENT.CRIME.TOTAL",
                 "VIOLENT.CRIME.PERCENT",
                 "VIOLENT.CRIME.PERCENT.CHANGE",
                 "PROPERTY.CRIME.TOTALS",
                 "PROPERTY.CRIME.PERCENT",
                 "PROPERTY.CRIME.PERCENT.CHANGE")
    
    general.df <- select(df, which(names(df)%in%general))
    general <- c("year","grand_total","percent_change","violent_crime_total",
                 "violent_crime_percent","violent_crime_percent_change",
                 "property_crime_totals","property_crime_percent",
                 "property_crime_percent_change")
    
    setnames(general.df, names(general.df), general)
    general <- general.df ; rm(general.df)
    
    x <- change(violent, Var = 'murder',
                type = 'percent',
                NewVar = 'murder_percent_change',
                slideBy = -1)
    violent$murder_percent_change <- x$murder_percent_change
    
    x <- change(violent, Var = 'rape',
                type = 'percent',
                NewVar = 'rape_percent_change',
                slideBy = -1)
    violent$rape_percent_change <- x$rape_percent_change
    
    x <- change(violent, Var = 'robbery',
                type = 'percent',
                NewVar = 'robbery_percent_change',
                slideBy = -1)
    violent$robbery_percent_change <- x$robbery_percent_change
    
    x <- change(violent, Var = 'aggravated_assault',
                type = 'percent',
                NewVar = 'aggravated_assault_percent_change',
                slideBy = -1)
    violent$aggravated_assault_percent_change <- x$aggravated_assault_percent_change
    
    
    violent$violent_crime_total <- general$violent_crime_total
    violent$violent_crime_percent_change <- general$violent_crime_percent_change
    
    x <- change(property, Var = 'breaking_entering',
                type = 'percent',
                NewVar = 'breaking_entering_percent_change',
                slideBy = -1)
    
    property$breaking_entering_percent_change <- x$breaking_entering_percent_change
    
    x <- change(property, Var = 'larceny_theft',
                type = 'percent',
                NewVar = 'larceny_theft_percent_change',
                slideBy = -1)
    
    property$larceny_theft_percent_change <- x$larceny_theft_percent_change
    
    
    x <- change(property, Var = 'motor_vehicule_theft',
                type = 'percent',
                NewVar = 'motor_vehicule_theft_percent_change',
                slideBy = -1)
    
    property$motor_vehicule_theft_percent_change <- x$motor_vehicule_theft_percent_change
    property$property_crime_total <- general$property_crime_totals
    property$property_crime_percent_change <- general$property_crime_percent_change
    rm(x)
    
    
    scale.down <- function(vector){
      result <- weighted.mean(vector,c(1, 0.75, 0.5, 0.25), na.rm = T )
      result <- 2.5*(result/10000)
      return(result)
    }
    x <- apply(select(violent, c(2,3,4,5)), 1, scale.down)
    violent$weighted_average <- x
    
    scale.down <- function(vector){
      result <- weighted.mean(vector,c(1, 0.75, 0.5), na.rm = T )
      result <- 2.5*(result/10000)
      return(result)
    }
    x <- apply(select(property, c(2,3,4)), 1, scale.down )
    property$weighted_average <- x; rm(x)
    
    averages <-  data.table("property.avg"= property$weighted_average,
                            "violent.avg" = violent$weighted_average)
    
    
    crime.index <- data.table("year"= df$YEAR,
                              "index"= apply(averages, 1, geometric.mean, na.rm = T))
    
    rm(averages)
    
    data <- list("property" = filter(property, year == Year),
                 "violent" = filter(violent, year == Year),
                 "index" = filter(crime.index, year == Year))
    
  } -> results; rm(j)
  
  list("property" =results[[1]]$property,
       "violent" = results[[1]]$violent,
       "mapping" = results[[1]]$index
  ) -> results
  
  
  return(results)
}




getCountiesData <- function(Year){
  
  foreach(j = 2:25)%do%{
    
    df <- readWorksheetFromFile("1975_2013_UCR_Rates_for_Website.xls",
                                sheet=j,
                                startRow = 3, endRow = 42)
    
    
    violent <- c("YEAR","MURDER","RAPE","ROBBERY","AGG..ASSAULT")
    violent.crimes <- select(df, which(names(df)%in%violent))
    violent <- c("year","murder","rape","robbery","aggravated_assault")
    setnames(violent.crimes, names(violent.crimes), violent)
    violent <- violent.crimes ; rm(violent.crimes)
    
    property <- c("YEAR","B...E","LARCENY.THEFT","M.V.THEFT")
    property.crimes <- select(df, which(names(df)%in%property))
    property <- c("year","breaking_entering","larceny_theft","motor_vehicule_theft")
    setnames(property.crimes, names(property.crimes), property)
    property <- property.crimes ; rm(property.crimes)
    
    general <- c("YEAR",
                 "GRAND.TOTAL","PERCENT.CHANGE",
                 "VIOLENT.CRIME.TOTAL",
                 "VIOLENT.CRIME.PERCENT",
                 "VIOLENT.CRIME.PERCENT.CHANGE",
                 "PROPERTY.CRIME.TOTALS",
                 "PROPERTY.CRIME.PERCENT",
                 "PROPERTY.CRIME.PERCENT.CHANGE")
    
    general.df <- select(df, which(names(df)%in%general))
    general <- c("year","grand_total","percent_change","violent_crime_total",
                 "violent_crime_percent","violent_crime_percent_change",
                 "property_crime_totals","property_crime_percent",
                 "property_crime_percent_change")
    
    setnames(general.df, names(general.df), general)
    general <- general.df ; rm(general.df)
    
    x <- change(violent, Var = 'murder',
                type = 'percent',
                NewVar = 'murder_percent_change',
                slideBy = -1)
    violent$murder_percent_change <- x$murder_percent_change
    
    x <- change(violent, Var = 'rape',
                type = 'percent',
                NewVar = 'rape_percent_change',
                slideBy = -1)
    violent$rape_percent_change <- x$rape_percent_change
    
    x <- change(violent, Var = 'robbery',
                type = 'percent',
                NewVar = 'robbery_percent_change',
                slideBy = -1)
    violent$robbery_percent_change <- x$robbery_percent_change
    
    x <- change(violent, Var = 'aggravated_assault',
                type = 'percent',
                NewVar = 'aggravated_assault_percent_change',
                slideBy = -1)
    violent$aggravated_assault_percent_change <- x$aggravated_assault_percent_change
    
    
    violent$violent_crime_total <- general$violent_crime_total
    violent$violent_crime_percent_change <- general$violent_crime_percent_change
    
    x <- change(property, Var = 'breaking_entering',
                type = 'percent',
                NewVar = 'breaking_entering_percent_change',
                slideBy = -1)
    
    property$breaking_entering_percent_change <- x$breaking_entering_percent_change
    
    x <- change(property, Var = 'larceny_theft',
                type = 'percent',
                NewVar = 'larceny_theft_percent_change',
                slideBy = -1)
    
    property$larceny_theft_percent_change <- x$larceny_theft_percent_change
    
    
    x <- change(property, Var = 'motor_vehicule_theft',
                type = 'percent',
                NewVar = 'motor_vehicule_theft_percent_change',
                slideBy = -1)
    
    property$motor_vehicule_theft_percent_change <- x$motor_vehicule_theft_percent_change
    property$property_crime_total <- general$property_crime_totals
    property$property_crime_percent_change <- general$property_crime_percent_change
    rm(x)
    
    
    scale.down <- function(vector){
      result <- weighted.mean(vector,c(1, 0.75, 0.5, 0.25), na.rm = T )
      result <- result/10
      return(result)
    }
    x <- apply(select(violent, c(2,3,4,5)), 1, scale.down)
    violent$weighted_average <- x
    
    scale.down <- function(vector){
      result <- weighted.mean(vector,c(1, 0.75, 0.5), na.rm = T )
      result <- result/100
      return(result)
    }
    x <- apply(select(property, c(2,3,4)), 1, scale.down )
    property$average <- x; rm(x)
    
    averages <-  data.table("property.avg"= property$average,
                            "violent.avg" = violent$weighted_average)
    
    
    crime.index <- data.table("year"= df$YEAR,
                              "index"= apply(averages, 1, geometric.mean, na.rm = T))
    
    rm(averages)
    
    data <- list("property" = filter(property, year == Year),
                 "violent" = filter(violent, year == Year),
                 "index" = filter(crime.index, year == Year))
    
  } -> results; rm(j)
  
  
  data1 = data.frame()
  data2 = data.frame()
  data3 = data.frame()
  
  
  foreach(j = 1:length(results)) %do% {
    data1 = rbind(data1, results[[j]][[1]])
    data2 = rbind(data2, results[[j]][[2]])
    data3 = rbind(data3, results[[j]][[3]])
  }
  
  counties.name <- c("Allegany",
                     "Anne Arundel",
                     "Baltimore City",
                     "Baltimore County",
                     "Calvert",
                     "Caroline",
                     "Carroll",
                     "Cecil",
                     "Charles",
                     "Dorchester",
                     "Frederick",
                     "Garrett",
                     "Harford",
                     "Howard",
                     "Kent",
                     "Montgomery",
                     "Prince George's",
                     "Queen Anne's",
                     "Somerset",
                     "St. Mary's",
                     "Talbot",
                     "Washington",
                     "Wicomico",
                     "Worcester")
  
  
  counties.code <- c(24001,24003,
                     24510,24005,
                     24009,24011,
                     24013,24015,
                     24017,24019,
                     24021,24023,
                     24025,24027,
                     24029,24031,
                     24033,24035,
                     24039,24037,
                     24041,24043,
                     24045,24047)
  
  data1$region <- counties.code
  data2$region <- counties.code
  data3$region <- counties.code
  
  
  data1$county <- counties.name
  data2$county <- counties.name
  data3$county <- counties.name
  
  data1$year <- NULL
  data2$year <- NULL
  data3$year <- NULL
  
  library(arules)
  
  data3$value <- data3$index
  data3$value <- discretize(data3$value,
                            method="frequency",
                            categories = 5,
                            labels = c("Very Low",
                                       "Low",
                                       "Medium",
                                       "High",
                                       "Very High"),
                            ordered=TRUE)
  
  list("property" = data1,
       "violent" = data2,
       "mapping" = data3) -> results; rm(list=c("data1","data2","data3","j"))
  
  
  return(results)
}





plot_main_graph <- function(df){
  
  df$property -> property.df
  df$violent -> violent.df
  property.total <- sum(property.df$property_crime_total, na.rm = T)
  violent.total <- sum(violent.df$violent_crime_total, na.rm = T)
  crime.type <- factor(c("Property Crimes","Violent Crimes"))
  
  
  p <- plot_ly(
    x = crime.type,
    y = c(property.total, violent.total),
    color = crime.type,
    colors = c("#8B0000","#20B2AA"),
    name = "Crime Totals",
    type = "bar")
  
  p <- layout(p,
              autosize = F, width = 800, height = 300,
              # title = "Crime Summary",
              xaxis = list(title = "", showgrid = F),
              yaxis = list(title = "Total", showgrid = F)
  )
  
  return(p)
}





plot_donut_graphs <- function(df){
  
  property.df <- df$property
  violent.df <- df$violent
  
  property.df <- select(property.df, c(2:4))
  setnames(property.df,
           names(property.df),
           c("Breaking and Entering",
             "Larceny Theft",
             "Motor Vehicule Theft"))
  
  property.df <- data.table("property_type" = as.factor(names(property.df)),
                            "total" = transpose(property.df[1,])$V1)
  
  violent.df <- select(violent.df, c(2:5))
  setnames(violent.df,
           names(violent.df),
           c("Murder",
             "Rape",
             "Rubbery",
             "Aggravated Assault"))
  
  violent.df <- data.table("violent_type" =  as.factor(names(violent.df)),
                           "total" = transpose(violent.df[1,])$V1)
  #
  violent <- plot_ly(violent.df,
                     labels = violent_type,
                     values = total,
                     type = "pie",
                     colors = "Reds",
                     hole = 0.6,
                     showlegend = T
  ) %>%
    layout(title = "Violent Crimes Breakdown",
           autosize = F, width = 500, height = 300)
  
  property <- plot_ly(property.df,
                      labels = property_type,
                      values = total,
                      type = "pie",
                      colors = "Blues",
                      hole = 0.6,
                      showlegend = T) %>%
    layout(title = "Property Theft Breakdown",
           autosize = F, width = 500, height = 300)
  
  return(list("property" = property, "violent" =violent))
}



plot_state_map <- function(df){
  
  plot <- county_choropleth(select(df$mapping, c(2,4)),
                            state_zoom = c("maryland"),
                            # title = "2013 Crime Choropleth Map",
                            legend = "Crime level")+
    scale_fill_brewer(palette = "OrRd",
                      type = "seq",
                      # direction = -1,
                      name = "Crime Level",
                      labels = c("Very Low","Low","Medium","High","Very High"))
  
  
  state.map <- plot$data
  state.codes <- sort(unique(state.map$region))
  
  foreach(i = 1:length(state.codes), .combine = rbind) %do% {
    
    filter(state.map, region == state.codes[i])%>%
      summarize(
        avg.long = mean(long),
        avg.lat  = mean(lat))
    
  } -> text.locations
  
  state.names = c()
  for (code in state.codes) {
    
    df <- filter(state.map, region == code)
    state.names <- c(state.names, unique(df$NAME))
  }; rm(df)
  rm(code)
  
  text.locations <- data.table(text.locations,
                               "region" = state.codes,
                               "label" = state.names)
  
  
  text.locations$label[which(text.locations$region == 24510)] <- ""
  
  rm(i); rm(state.map); rm(state.codes) ; rm(state.names)
  
  
  plot <- plot + geom_text(data = text.locations,
                           aes(avg.long, avg.lat, label = label, group = NULL),
                           color = 'black',size = 2.8,
                           vjust=0.5, hjust=0.5, angle = 40)
  
  
  plot <- plotly_build(plot)
  foreach( i = 1:length(plot$data)) %do% {
    # plot$data[[i]]$text <- paste("Total Violent Crime", "<br>",
    #                              "Total Property Crime", "<br>")
    plot$data[[i]]$hoverinfo <- "none"
    
  };rm(text.locations)
  
  return(plot)
}





get_percent_changes <- function(df){

  data <- data.table(df$violent)
  data <- select(data, c(6:9,11))
  changes_violent <- list("murder" = round(as.numeric(data$murder_percent_change),2),
                          "rape" = round(as.numeric(data$rape_percent_change),2),
                          "robbery"= round(as.numeric(data$robbery_percent_change),2),
                          "assault" = round(as.numeric(data$aggravated_assault_percent_change),2),
                          "violent" = round(as.numeric(data$violent_crime_percent_change),2)
                          )

  foreach(i = 1:length(changes_violent)) %do% {
    changes_violent[[i]] <- paste0(as.character(changes_violent[[i]]),"%")
  }


  data <- data.table(df$property)
  data <- select(data, c(5:7,9))
  changes_property <- list("breaking_entering" = round(as.numeric(data$breaking_entering_percent_change),2),
                           "larceny" = round(as.numeric(data$larceny_theft_percent_change), 2),
                           "vehicule_theft" = round(as.numeric(data$motor_vehicule_theft_percent_change), 2),
                           "property" = round(as.numeric(data$property_crime_percent_change),2)
                           )
  
  foreach(i = 1:length(changes_property)) %do% {
    changes_property[[i]] <- paste0(as.character(changes_property[[i]]),"%")
  }; rm(i)

  return(list("violent" = changes_violent, "property" = changes_property))

}




counties_DT <- function(df){
  data1 <- df$violent %>% select(c(13,1:4,9)) 
  setnames(data1, names(data1), c("County",
                                  "Murder", "Rape",
                                  "Robbery", "Aggravated Assault",
                                  "Total Violent Crimes"))
  
  
  data2 <- df$property %>% select(c(1:3,7))
  setnames(data2, names(data2), c( 
                                  "Breaking and Entering",
                                  "Larceny Theft", 
                                  "Motor Vehicule",
                                  "Total Property Crimes"))
  
  data3 <- df$mapping %>% select(c(1,4))
  setnames(data3, names(data3), c("Crime Index", "Crime Level"))
  
  data <- data.table(data1, data2,data3)
  
  return(data)
}


 
  

