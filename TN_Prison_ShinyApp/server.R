# TN Prison Gerrymandering Shiny App global.R file
# 

function(input, output, session) {
  
  ## District Explorer ###########################################
  
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
  
  # Reactive expressions to store plot data based on district and district type selected 
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
  
  # Reactive expression to clear reactive variables when district type is changed
  observeEvent(input$disttype, {
    prev_clicked_district_num(NULL)
    clicked_district_num(NULL)
    plot_data(NULL)
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
    
    # Filter the data down to the selected district (if there is one)
    new_data <- if (is.null(clicked_district_num())) {
      base_data()
    } else{
      base_data() |>
        filter(.data[[district()]] == clicked_district_num())
    }
    
    # Update plot_data
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
  
  # Render the table of population values
  output$popTable <- renderUI({
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
    
    update_tibble_highlight <- combined_pop |>
      select(Population,Adjusted) |>
      filter(Population=='Deviation') |>
      mutate(Adjusted = as.numeric(Adjusted)) |>
      mutate(Adjusted = cell_spec(Adjusted, background = ifelse(abs(Adjusted) < 10, "#88E788", "#ee2400"))) |>
      mutate(Adjusted = paste0(Adjusted,'%')) 
    
    formatted_pop_interim <- rows_update(combined_pop, update_tibble, by=c('Population')) 
    
    formatted_pop_final <- rows_update(formatted_pop_interim, update_tibble_highlight, by=c('Population')) |> kbl(escape = F) |> kable_styling(full_width = F)
    
    HTML(formatted_pop_final)
    
  })
  
  # Render the partisan lean bar plot
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
  
  # Render the racial makeup bar plot
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
  
  ## Statewide Trends ###########################################
  
  # Reactive expression to store the type of district based on dropdown selection
  district_bounds_statewide <- reactive({
    req(input$statewidedisttype) # Ensures the input has a value before running
    if (input$statewidedisttype == "sldl_statewide") {
      full_join(TN_house_bounds, sldl_demogr |> rename(DISTRICT=SLDL), by='DISTRICT')
    } else {
      full_join(TN_senate_bounds, sldu_demogr |> rename(DISTRICT=SLDU), by='DISTRICT')
    }  
  })
  
  # Reactive expression to monitor changes in selected district type and reset demographic dropdowns when district type is changed
  observeEvent(input$statewidedisttype, {
    
    updateSelectInput(
      session = session,
      inputId = 'demogr',
      selected = character(0) # Resets the selection to empty
    )
    
    updateSelectInput(
      session = session,
      inputId = 'group',
      selected = character(0) # Resets the selection to empty
    )
    
  }) 
  
  # Reactive expression to monitor changes in selected demographic (second dropdown). Reset group options based on demographic selection.
  observeEvent(input$demogr, {
    
    demogr_groups <- switch(input$demogr,
                            "party" = c('Democratic','Republican'),
                            "race" = c('White', 'African American', 'Hispanic'),
                            "gender" = c('Male', 'Female'),
                            "age" = c('Under 30', '30 to 44', '45 to 64', '65 or over'),
                            "engag" = c('Voter turnout in 2024 election'),
                            "votepwr" = c('Vote power'),
                            "popdev" = c('Population deviation'),
                            "popdevadj" = c('Population deviation (adjusted)'),
                            NULL
    )
    
    # Use updateSelectInput to change the choices and reset the selected value
    updateSelectInput(
      session = session,
      inputId = 'group',
      choices =  demogr_groups
    )
    
  }, 
  ignoreInit = TRUE) # ignoreInit = TRUE prevents this from running when the app first loads

  
  
  # Define dataframe column reactively based on demographic group selection
  selected_column <- reactive({
    req(input$group) # Ensures the input has a value before running
    
    switch(input$group,
           "Democratic" = "pct_party_democratic",
           "Republican" = "pct_party_republican",
           "White" = "pct_eur",
           "African American" = "pct_aa",
           "Hispanic" = "pct_hisp",
           "Male" = "pct_gender_male",
           "Female" = "pct_gender_female",
           "Under 30" = "pct_under_30",
           "30 to 44" = "pct_30_to_44",
           "45 to 64" = "pct_45_to_64",
           "65 or over" = "pct_65_plus",
           "Voter turnout in 2024 election" = "voter_turnout",
           "Vote power" = "vote_strength",
           "Population deviation" = "pct_pop_dev",
           "Population deviation (adjusted)" = "pct_pop_dev_adj",
           NULL
    )

  })
  
  # Create the map palette based on the column
  palette_function <- reactive({
    req(input$group)
    req(district_bounds_statewide())
    colorNumeric(
      palette = "plasma",
      domain = district_bounds_statewide()[[selected_column()]],
      reverse = TRUE
    )
  })
  
  # Plot base map
  output$statemap <- renderLeaflet({
    
      leaflet(data = district_bounds_statewide()) |>
        addTiles() |>
        addPolygons(
          color = ~ifelse(has_prison, "#0F52BA", "#444444"),
          fillOpacity = 0.5,
          fillColor = ~ifelse(has_prison, "#fe9929", "#fec44f"),
          weight = ~ifelse(has_prison, 3, 1),
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
  
  
  # When a demographic group is selected, clear existing layers and plot a chloropleth map of that data
  observeEvent(input$group, {
    proxy <- leafletProxy("statemap", data = district_bounds_statewide()) |>
      clearShapes() |>
      clearControls()
    
    proxy |>
      addPolygons(
        color = ~ifelse(has_prison, "#0F52BA", "#444444"),
        fillOpacity = 0.5,
        fillColor = ~palette_function()(district_bounds_statewide()[[selected_column()]]),
        weight = ~ifelse(has_prison, 3, 1),
        highlightOptions = highlightOptions(
          color = "red", weight = 3
        ),
        label = ~LONGNAME
      ) |>
      addLegend(
        position = "bottomleft",
        pal = palette_function(),
        values = ~district_bounds_statewide()[[selected_column()]],
        title = paste("Percent",input$group),
        labFormat = labelFormat()
      ) 
  })
  
}
