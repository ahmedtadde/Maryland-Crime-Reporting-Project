getStateData <- function(Year){
  source("libraries.R")
  
  
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
 
  list("property" =results[[1]]$property,
       "violent" = results[[1]]$violent,
       "mapping" = results[[1]]$index
       ) -> results

  
  return(results)
}