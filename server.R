source("helpers.R")
libraries()


shinyServer(function(input, output) {
   
  output$map <- renderPlotly({
    
    selected.year <- input$year
    counties.data <- getCountiesData(selected.year)
    plot_state_map(counties.data)
  })
  
  output$main <- renderPlotly({
    
    selected.year <- input$year
    state.data <- getStateData(selected.year)
    plot_main_graph(state.data)
    
  })
  
  output$donut1 <- renderPlotly({

    selected.year <- input$year
    state.data <- getStateData(selected.year)
    plot_donut_graphs(state.data)$violent

  })


  output$donut2 <- renderPlotly({

    selected.year <- input$year
    state.data <- getStateData(selected.year)
    plot_donut_graphs(state.data)$property

  })
  
  output$murder <- renderText({
    selected.year <- input$year
    state.data <- getStateData(selected.year)
    get_percent_changes(state.data)$violent$murder


  })

  output$rape <- renderText({
    selected.year <- input$year
    state.data <- getStateData(selected.year)
    get_percent_changes(state.data)$violent$rape


  })

  output$robbery <- renderText({
    selected.year <- input$year
    state.data <- getStateData(selected.year)
    get_percent_changes(state.data)$violent$robbery


  })


  output$assault <- renderText({
    selected.year <- input$year
    state.data <- getStateData(selected.year)
    get_percent_changes(state.data)$violent$assault


  })

  output$violent <- renderText({
    selected.year <- input$year
    state.data <- getStateData(selected.year)
    get_percent_changes(state.data)$violent$violent


  })


  output$breaking_entering <- renderText({
    selected.year <- input$year
    state.data <- getStateData(selected.year)
    get_percent_changes(state.data)$property$breaking_entering


  })


  output$larceny <- renderText({
    selected.year <- input$year
    state.data <- getStateData(selected.year)
    get_percent_changes(state.data)$property$larceny


  })


  output$vehicule_theft <- renderText({
    selected.year <- input$year
    state.data <- getStateData(selected.year)
    get_percent_changes(state.data)$property$vehicule_theft


  })

  output$property <- renderText({
    selected.year <- input$year
    state.data <- getStateData(selected.year)
    get_percent_changes(state.data)$property$property


  })
})
