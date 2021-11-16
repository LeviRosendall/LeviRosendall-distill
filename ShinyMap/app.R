#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Load packages ----------------------------------------------------------------

library(shiny)
library(ggplot2)
library(dplyr)

# Load data --------------------------------------------------------------------

plotTable <- read_csv(here::here("ShinyMap/plotTable.csv"))
plotTable

# Define UI --------------------------------------------------------------------

ui <- fluidPage(
    br(),
    
    sidebarLayout(
        sidebarPanel(
            selectInput(
                inputId = "Date", label = "Y-axis:",
                choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"),
                selected = "audience_score"
            ),
            
            selectInput(
                inputId = "x", label = "X-axis:",
                choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"),
                selected = "critics_score"
            )
        ),
        
        mainPanel(
            plotOutput(outputId = "map", hover = "plot_hover")
           
        )
    )
)

# Define server ----------------------------------------------------------------

server <- function(input, output, session) {
    
    output$scatterplot <- renderPlot({
        ggplot(data = plotTable, aes_string(x = input$x, y = input$y)) +
            geom_point()
    })
    
    
    output$map <- renderPlot({
        USMAP <- plotTable %>% 
            plot_ly(
                type = 'choropleth',
                locations= ~statesOver,
                locationmode = 'USA-states' , 
                colorscale='tempo', z=~logSold,
                zmin=0, zmax=6,
                text=~cumulative,
                hoverinfo='text',
                showscale=FALSE,
                frame=~day) %>% 
            layout(geo=list( scope = 'usa' )) 
        
        #saves the above 
        library(htmlwidgets)
        saveWidget(USMAP, "USMAP.html", selfcontained = F, libdir = "lib")
        
        htmltools::tags$iframe(
            width = "1024",
            height = "768",
            src = "USMAP.html", 
            scrolling = "no", 
            seamless = "seamless",
            frameBorder = "0"#,
            #style="-webkit-transform:scale(0.5);-moz-transform-scale(0.5);"
        )
    })
}

# Create the Shiny app object --------------------------------------------------

shinyApp(ui = ui, server = server)
