source("helpers.R")
libraries()


shinyServer(function(input, output) {
   
  output$map <- renderPloty({
    
    selected.year <- input$year
    counties.data <- getCountiesData(selected.year)
    state.map <-  plot_state_map(counties.data)
    # print(state.map) 
    state.map
  })
  
})
