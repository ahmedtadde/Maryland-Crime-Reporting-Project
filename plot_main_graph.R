plot_main_graph <- function(df){

  source("libraries.R")
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