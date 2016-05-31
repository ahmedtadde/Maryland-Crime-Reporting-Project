plot_main_graph <- function(df){
  
  library(scales)
  library(data.table)
  library(plotly)
  library(choroplethr)
  library(choroplethrMaps)
  library(dplyr)
  library(foreach)
  library(doMC)
  library(snow) 
  library(doSNOW)
  registerDoMC(cores=8)
  registerDoSNOW(makeCluster(8, type="SOCK")) 
  library(doParallel)
  registerDoParallel(makeCluster(8))
  
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
              title = "Crime Summary",
              xaxis = list(title = "", showgrid = F),
              yaxis = list(title = "Total", showgrid = F)
              )
  
  return(p)
}