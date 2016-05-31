getCountiesData <- function(Year){
  
  library(XLConnect)
  library(data.table)
  library(dplyr)
  library(DataCombine)
  library(psych)
  library(foreach)
  library(doMC)
  library(snow) 
  library(doSNOW)
  registerDoMC(cores=8)
  registerDoSNOW(makeCluster(8, type="SOCK")) 
  library(doParallel)
  registerDoParallel(makeCluster(8))
  
  
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
    
    # gm_mean = function(x, na.rm=TRUE){
    #   exp(sum(log(x[x > 0]), na.rm=na.rm) / length(x))
    # }
    
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
                            # onlycuts = TRUE)
                            # labels = paste0("level", seq(1,5,1), sep = " "),
                            # ordered=TRUE)
  
  list("property" = data1,
       "violent" = data2,
       "mapping" = data3) -> results; rm(list=c("data1","data2","data3","j"))
  
  
  return(results)
}