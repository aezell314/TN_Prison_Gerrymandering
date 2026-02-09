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
        popup = ~paste0("<strong>Prison: </strong>", name, "<br><strong>Capacity: </strong>", prettyNum(capacity, big.mark = ",")), 
        label = ~as.character(name)
       ) 
  })
  
  plot_data <- reactiveVal(NULL) 
  
  # Observe click events on the map
  observeEvent(input$map_shape_click, {
    # Get Shape Input Click
    click <- input$map_shape_click
    
    # Extract the layerId, which is our district number
    clicked_district_num <- click$id
    
    # Update the textOutput in the absolute panel
    output$district_display <- renderText({
      if (is.null(clicked_district_num)) {
        "None selected"
      } else {
        paste0("District #", clicked_district_num)
      }
    })
    
    # Calculate plot data based on district and district type selected 
    if (input$disttype == "sldl") {
      base_data <- sldl_demogr
      district <- 'SLDL'
    } else {
      base_data <- sldu_demogr
      district <- 'SLDU'
    } 
    
    new_data <- if (is.null(clicked_district_num)) {
      base_data
    } else{
      base_data |>
        filter(.data[[district]] == clicked_district_num)
    }
    
    # Store the data
    plot_data(new_data) 
  })
  
  output$pop_display <- renderText({
    # Req ensures plot doesn't render until data exists
    req(plot_data()) 
    pop <- plot_data() |> dplyr::select(total_pop) |> pull()
    paste("Population:", prettyNum(pop, big.mark = ","))
  })
  
  output$prison_pop_display <- renderText({
    # Req ensures plot doesn't render until data exists
    req(plot_data()) 
    pop <- plot_data() |> dplyr::select(prison_pop) |> pull()
    paste("Prison population:", prettyNum(pop, big.mark = ","))
  })
  
  output$partisanBarPlot <- renderPlot({
    # Req ensures plot doesn't render until data exists
    req(plot_data()) 
    
    plot_data() |> 
    pivot_longer(cols=pct_party_democratic:pct_party_ind_npp, names_to = 'category', values_to = 'percent') |>
    mutate(category = factor(category, levels=c('pct_party_democratic','pct_party_republican','pct_party_ind_npp'), labels=c('Democratic', 'Republican', 'Independent'))) |>
    ggplot(aes(x=category, y=percent)) +
    geom_col() + 
    labs(x='Party Affiliation', y='Percent')
  })
  
}
