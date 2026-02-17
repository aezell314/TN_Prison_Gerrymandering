# TN Prison Gerrymandering Shiny App global.R file
# 

function(input, output, session) {
  
  ## Interactive Map ###########################################
  
  # Reactive value to store the demographic data filtered down to the selected district
  plot_data <- reactiveVal(NULL) 
  # Reactive value to store the ID of the currently clicked district
  clicked_district_num <- reactiveVal(NULL)
  # Reactive value to store the ID of the previously clicked district
  prev_clicked_district_num <- reactiveVal(NULL)
  
  # Reactive expression to store the type of district based on dropdown selection
  district_bounds <- reactive({
    req(input$disttype) # Ensures the input has a value before running
    if (input$disttype == "sldl") {
      TN_house_bounds |> mutate(DISTRICT = as.character(DISTRICT)) # layer id must be numeric
    } else {
      TN_senate_bounds |> mutate(DISTRICT = as.character(DISTRICT)) # layer id must be numeric
    }  
  })
  
  # Reactive expression to store plot data based on district and district type selected 
  base_data <- reactive({
    req(input$disttype) # Ensures the input has a value before running
    if (input$disttype == "sldl") {
      sldl_demogr
    } else {
      sldu_demogr
    } 
  })

 district <- reactive({
   req(input$disttype) # Ensures the input has a value before running
    if (input$disttype == "sldl") {
      'SLDL'
    } else {
      'SLDU'
    } 
 })
 
 observeEvent(input$disttype, {
   # Reactive expression to clear prev_clicked_district_num when district type is changed
   prev_clicked_district_num(NULL)
 })
 
  # Create the map
  output$map <- renderLeaflet({
    
    leaflet() |>
      addTiles() |> 
      addPolygons(
        data = district_bounds(),
        color = ~ifelse(has_prison, "#0F52BA", "#444444"),
        fillOpacity = 0.5,
        fillColor = ~ifelse(has_prison, "#fe9929", "#fec44f"),
        weight = ~ifelse(has_prison, 3, 1),
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
  
  # Observe click events on the map
  observeEvent(input$map_shape_click, {
    # Get user click
    click <- input$map_shape_click
    
    # Get leaflet map
    proxy <- leafletProxy('map', session)
    
    # Extract the layerId, which is our district number
    clicked_district_num(click$id)
    
    new_data <- if (is.null(clicked_district_num())) {
      base_data()
    } else{
      base_data() |>
        filter(.data[[district()]] == clicked_district_num())
    }
    
    # Store the data
    plot_data(new_data) 
    
    # Revert the style of the previously clicked district, if any
    if (!is.null(prev_clicked_district_num())) {
      # Filter district boundaries based on previously clicked id
      prev_poly <- district_bounds() |> filter(DISTRICT == prev_clicked_district_num())
      proxy |>
        addPolygons(
          data = prev_poly,
          color = ~ifelse(has_prison, "#0F52BA", "#444444"),
          fillOpacity = 0.5,
          fillColor = ~ifelse(has_prison, "#fe9929", "#fec44f"),
          weight = ~ifelse(has_prison, 3, 1),
          layerId = ~DISTRICT,
          highlightOptions = highlightOptions(
            color = "red", weight = 3
          ),
          label = ~LONGNAME
        )}

    # Outline the newly clicked district in thick red 
    if (!is.null(clicked_district_num())) {
      # Filter district boundaries based on current clicked id
      selected_poly <- district_bounds() |> filter(DISTRICT == clicked_district_num())
      proxy |>
        addPolygons(
          data = selected_poly,
          color = "red",
          fillOpacity = 0.5,
          fillColor = ~ifelse(has_prison, "#fe9929", "#fec44f"),
          weight = 4,
          layerId = ~DISTRICT,
          highlightOptions = highlightOptions(
            color = "red", weight = 3
          ),
          label = ~LONGNAME
        )}
    
    # Update the previously clicked district number 
    prev_clicked_district_num(clicked_district_num())
  })

  
  # Update the textOutput in the absolute panel
  output$district_display <- renderText({
    if (is.null(clicked_district_num())) {
      "None selected"
    } else {
      paste0("District #", clicked_district_num())
    }
  })
  
  output$popTable <- renderTable({
    req(plot_data())
    current_pop <- plot_data() |>
      select(total_pop, prison_pop, pct_incarc, pct_pop_dev) |>
      pivot_longer(cols = everything(), names_to = 'Population', values_to = 'Current')
    
    adj_pop <- plot_data() |>
      select(pop_adj, prison_pop_adj, pct_incarc_adj, pct_pop_dev_adj) |>
      pivot_longer(cols = everything(), names_to = 'Population', values_to = 'Adjusted') |>
      select('Adjusted')
    
    combined_pop <- cbind(current_pop, adj_pop) |> 
      mutate(Change = ifelse(Current < Adjusted, "↑", "↓")) |>
      mutate(across(where(is.numeric), round, digits = 2)) |>
      mutate(Current = prettyNum(Current, big.mark = ","),
             Adjusted = prettyNum(Adjusted, big.mark = ","))
    
    combined_pop$Population <- c('Total', 'Incarcerated', 'Pct Incarcerated', 'Deviation')
    
    update_tibble <- combined_pop |>
      select(Population,Current,Adjusted) |>
      mutate(across(Current:Adjusted, \(x) paste0(x,'%'))) |>
      filter(Population=='Pct Incarcerated' | Population=='Deviation')
    
    formatted_pop <- rows_update(combined_pop, update_tibble, by=c('Population'))
    
    formatted_pop
    
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
