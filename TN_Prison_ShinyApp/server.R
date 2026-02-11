# TN Prison Gerrymandering Shiny App global.R file
# 

function(input, output, session) {
  
  ## Interactive Map ###########################################

  # Create the map
  output$map <- renderLeaflet({
    
    plot_data <- if (input$disttype == "sldl") {
      TN_house_bounds
    } else {
      TN_senate_bounds
    }  
    
    leaflet() |>
      addTiles() |> 
      addPolygons(
        data = plot_data,
        color = "#444444",
        weight = 1,
        fillOpacity = 0.5,
        fillColor = "#fec44f",
        layerId = ~DISTRICT,
        highlightOptions = highlightOptions(
          color = "red", weight = 3
        ),
        label = ~LONGNAME
      ) |>
      addMarkers(
        data = prison_info,
        lng = ~longitude,
        lat = ~latitude,
        popup = ~paste0("<strong>Prison: </strong>", name, "<br><strong>Capacity: </strong>", prettyNum(capacity, big.mark = ","), "<br><strong>Location: </strong>", city, "<br><strong>Year Opened: </strong>", year_opened), 
        label = ~as.character(name)
       ) 
  })
  
  plot_data <- reactiveVal(NULL) 
  clicked_district_num <- reactiveVal(NULL)
  
  # Observe click events on the map
  observeEvent(input$map_shape_click, {
    # Get Shape Input Click
    click <- input$map_shape_click
    
    # Extract the layerId, which is our district number
    clicked_district_num(click$id)
    
    # Calculate plot data based on district and district type selected 
    if (input$disttype == "sldl") {
      base_data <- sldl_demogr
      district <- 'SLDL'
    } else {
      base_data <- sldu_demogr
      district <- 'SLDU'
    } 
    
    new_data <- if (is.null(clicked_district_num())) {
      base_data
    } else{
      base_data |>
        filter(.data[[district]] == clicked_district_num())
    }
    
    # Store the data
    plot_data(new_data) 
  })
    
  # Update the textOutput in the absolute panel
  output$district_display <- renderText({
    if (is.null(clicked_district_num())) {
      "None selected"
    } else {
      paste0("District #", clicked_district_num())
    }
  })
  
  output$popTable <- renderDataTable({
    req(plot_data()) 
    current_pop <- plot_data() |>
      select(total_pop, pct_pop_dev, prison_pop) |>
      mutate(across(where(is.numeric), round, digits = 2)) |>
      mutate(across(where(is.numeric), as.character)) |>
      mutate(pct_pop_dev = paste0(pct_pop_dev,'%')) |>
      rename('Total'=total_pop, 'Deviation'=pct_pop_dev, 'Incarcerated'=prison_pop) |>
      pivot_longer(cols = everything(), names_to = 'Population', values_to = 'Current')
    
    adj_pop <- plot_data() |>
      select(pop_adj, pct_pop_dev_adj, prison_pop_adj) |>
      mutate(across(where(is.numeric), round, digits = 2)) |>
      mutate(across(where(is.numeric), as.character)) |>
      mutate(pct_pop_dev_adj = paste0(pct_pop_dev_adj,'%')) |>
      pivot_longer(cols = everything(), names_to = 'Population', values_to = 'Adjusted') |>
      select('Adjusted')
    
    combined_pop <- cbind(current_pop, adj_pop)
    
    combined_pop
    
  })
  
  output$partisanBarPlot <- renderPlot({
    req(plot_data()) 
    plot_data() |> 
    pivot_longer(cols=pct_dem:pct_rep, names_to = 'category', values_to = 'percent') |>
    mutate(category = factor(category, levels=c('pct_dem','pct_rep'), labels=c('Democratic', 'Republican'))) |>
    ggplot(aes(x=category, y=percent)) +
    geom_col(colour = "black", fill = "#669933") + 
    labs(x='Party Affiliation', y='Percent') +
    theme_minimal()
  })
  
  output$raceBarPlot <- renderPlot({
    req(plot_data()) 
    plot_data() |> 
      pivot_longer(cols=pct_eur:pct_aa, names_to = 'category', values_to = 'percent') |>
      mutate(category = factor(category, levels=c('pct_eur','pct_hisp','pct_aa'), labels=c('White', 'Hispanic', 'African-American'))) |>
      ggplot(aes(x=category, y=percent)) +
      geom_col(colour = "black", fill = "#FFCC66") + 
      labs(x='Race', y='Percent') +
      theme_minimal()
  })
  
}
