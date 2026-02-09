# TN Prison Gerrymandering Shiny App global.R file
# 
navbarPage("TN Prison Gerrymandering", id="nav",
           
           tabPanel("Interactive map",
                    div(class="outer",
                        
                        leafletOutput("map", width="100%", height="900"),
                        
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = TRUE, top = 80, left = "auto", right = 30, bottom = "auto",
                                      width = 330, height = "auto",
                                      wellPanel(
                                      
                                        h2("District explorer"),
                                        
                                        selectInput("disttype", "District type", c(
                                          "TN State House" = "sldl",
                                          "TN State Senate" = "sldu"
                                        )
                                        ),
                                        
                                        h4("Selected District:"),
                                        textOutput("district_display"),
                                        
                                        textOutput("pop_display"),
                                        textOutput("prison_pop_display"),
                                        
                                        plotOutput("partisanBarPlot", height = 250)
                                        
                                        
                                        )
                                      
                        ),
                        
                    )
           ),
           
           tabPanel("Data explorer",
           )
           
)
