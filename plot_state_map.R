plot_state_map <- function(df){
  
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
  
  plot <- county_choropleth(select(df$mapping, c(2,4)),
                            state_zoom = c("maryland"),
                            title = "2013 Crime Choropleth Map",
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
  
  
  text.locations$label[which(text.locations$region == 24510)] <- "Baltimore City"
  
  rm(i); rm(state.map); rm(state.codes) ; rm(state.names)
  

  plot <- plot + geom_text(data = text.locations,
                           aes(avg.long, avg.lat, label = label, group = NULL),
                           color = 'black',size = 2.8,
                           vjust=0.5, hjust=0.5, angle = 40)
  
  
  plot <- plotly_build(plot)
  foreach( i = 1:length(plot$data)) %do% {
    # plot$data[[i]]$text <- paste(text.locations$label, "<br>")
    plot$data[[i]]$hoverinfo <- "none"

  };rm(text.locations)
  
  return(plot)
}