plot_donut_graphs <- function(df){

  source("libraries.R")
  
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
                     hole = 0.7,
                     showlegend = T
                     ) %>%
    layout(title = "Violent Crimes Breakdown")

  property <- plot_ly(property.df,
                     labels = property_type,
                     values = total,
                     type = "pie",
                     colors = "Blues",
                     hole = 0.7, 
                     showlegend = T) %>%
    layout(title = "Property Theft Breakdown")

  return(list("property" = property, "violent" =violent))
}