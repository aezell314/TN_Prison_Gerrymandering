# TN Prison Gerrymandering Shiny App global.R file
# 
navbarPage("TN Prison Gerrymandering", id="nav",
           
           tabPanel("District Explorer",
                    div(class="outer",
                        
                        leafletOutput("map", width="95%", height="900"),
                        
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = TRUE, top = "10%", right = "5%", width = "25%", height = "auto",
                                      wellPanel(
                                        
                                        h2("District explorer"),
                                        
                                        selectInput("disttype", "District type", c(
                                          "TN State House" = "sldl",
                                          "TN State Senate" = "sldu"
                                        )
                                        ),
                                        
                                        h4("Selected District:"),
                                        
                                        textOutput("district_display"),
                                        
                                        uiOutput("popTable"),
                                        
                                        plotOutput("partisanBarPlot", height = 180),
                                        plotOutput("raceBarPlot", height = 180)
                                        
                                        
                                      )
                                      
                        ),
                        
                    )
           ), 
           tabPanel("Statewide Trends",
                    div(class="outer",
                        
                        leafletOutput("statemap", width="95%", height="900"),
                        
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = TRUE, top = "10%", right = "5%", width = "25%", height = "auto",
                                      wellPanel(
                                        
                                        h2("Explore statewide trends"),
                                        
                                        # Dropdown for district type
                                        selectInput("statewidedisttype", "District type", c(
                                          "TN State House" = "sldl_statewide",
                                          "TN State Senate" = "sldu_statewide"
                                        )
                                        ),
                                        
                                        # Dropdown for population type
                                        selectInput("demogr", "Demographic", c(
                                          "Partisan lean" = "party",
                                          "Race" = "race",
                                          "Political engagement" = "engag",
                                          "Gender" = "gender",
                                          "Age" = "age",
                                          "Vote Power" = "votepwr",
                                          "Population Deviation" = "popdev",
                                          "Population Deviation (adj)" = "popdevadj"
                                        )
                                        ),
                                        
                                        # Dropdown for options within each demographic type. 
                                        selectInput("group", "Select Group", 
                                                    choices = NULL) # Choices will be populated by the server once a demographic is selected
                                        
                                        
                                        
                                      )
                        )
                        
                    )
           )
)

