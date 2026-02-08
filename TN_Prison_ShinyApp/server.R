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
        highlightOptions = highlightOptions(
          color = "red", weight = 3, bringToFront = TRUE
        ),
        label = ~LONGNAME
      ) |>
      addMarkers(
        data = prisons_sldu,
        lng = ~longitude,
        lat = ~latitude,
        popup = ~as.character(name), 
        label = ~as.character(name)
       ) 
  })
  
}