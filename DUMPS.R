
library(choroplethr)
library(choroplethrMaps)
library(choroplethrCaCensusTract)
data(df_ca_tract_demographics)
df_ca_tract_demographics$value = df_ca_tract_demographics$per_capita
ca_tract_choropleth(df_ca_tract_demographics,
                    title       = "2013 Los Angeles Census Tract\n Per Capita Income",
                    legend      = "Income",
                    num_colors  = 4,
                    county_zoom = 6037) -> plot

# foreach(i = 1:dim(df_ca_tract_demographics)[1],.combine = rbind ) %do% {
#   strsplit(df_ca_tract_demographics$region, split = "")[[i]][2:5]
#   # for( i in 1:1 ) {
#   #   region <- paste0(region[i],region[i+1],region[i+2],region[i+3])
#   #   }
#   } -> region ; rm(i)
# region <- data.frame(region)
# region$region <- paste0(region$X1,region$X2,region$X3,region$X4)
# df_ca_tract_demographics$region <- region$region ; rm(region)

# df <- data.table(df_ca_tract_demographics) %>%
#   select(which(names(df_ca_tract_demographics) %in% c("region","value")))%>%
#   filter(region = )
# county_choropleth(df,
#                   title       = "2013 Los Angeles Census Tract\n Per Capita Income",
#                   legend      = "Income",
#                   num_colors  = 4,
#                   county_zoom = 6037) -> plot


# print(plot)
# rm(df_ca_tract_demographics); rm(df); rm(region)