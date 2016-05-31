plot_map_graph <- function(df){
  
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
                           color = 'black',size = 2.35,
                           vjust=0.5, hjust=0, angle = 40)
    # geom_point(
    #            x = text.locations$avg.long[1],
    #            y = text.locations$avg.lat[1],
    #            aes(text="TESTING"),
    #            alpha = 0)
  
  
  plot <- plotly_build(plot)
  foreach( i = 1:length(plot$data)) %do% {
    # plot$data[[i]]$text <- paste(text.locations$label, "<br>")
    plot$data[[i]]$hoverinfo <- "none"

  };rm(text.locations)
 
  # foreach(i = 1:length(plot$data)) %do%{
  #   plot$data[[i]]$text <- paste("County:", df$mapping$NAME[i], "<br>",
  #                             "Value:", df$mapping$value[i], "<br>")
  #   plot$data[[i]]$hoverinfo <- "text"}
  
  # plot$NAME[which(plot$LSAD == "city")] <- "Baltimore City"
  # plot$NAME[which(plot$NAME == "Baltimore")] <- "Baltimore County"
  # counties <- sort(unique(plot$NAME))
  # 
  # foreach( i = 1:length(counties), .combine = rbind) %do% {
  #   
  #   data <- filter(data.table(plot), NAME == counties[i])%>% select(c(1,2,11))
  #   coordinates <- data.table(paste(data$long, data$lat,sep = ":"))
  #   data <- data.table(data, "geo" = coordinates)
  #   setnames(data, "geo.V1", "geo")
  #   setnames(data, "NAME","county")
  #   data[,long:= NULL]; data[,lat:= NULL]
  #   
  #   index <- filter(df$mapping, county == counties[i])$value
  #   index <- rep(index,dim(data)[1])
  #   data <- data.table(data, "value" = index)
  #   
  # } -> data; rm(i)
  
  # # give state boundaries a white border
  # l <- list(color = toRGB("white"), width = 2)
  # # specify some map projection/options
  # g <- list(
  #   scope = 'usa',
  #   projection = list(type = 'albers usa'),
  #   showlakes = TRUE,
  #   lakecolor = toRGB('white')
  # )
  # 
  # plot <- plot_ly(data, z = value, locations = geo, type = 'choropleth',
  #         locationmode = 'ISO-3', color = value, colors = 'Purples',
  #         marker = list(line = l), colorbar = list(title = "Millions USD")) %>%
  #   layout(title = '2011 US Agriculture Exports by State<br>(Hover for breakdown)', geo = g)
  
  # library(googleVis)
  # plot <- gvisGeoChart(data, locationvar ="geo", colorvar = 'value',
  #                   options= list(region="US", displayMode="Markers", 
  #                                 resolution="provinces"))
  #                                 
  #                                 
  
  return(plot)
}