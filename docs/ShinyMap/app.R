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
library(readr)
library(htmlwidgets)
library(plotly)

# Load data --------------------------------------------------------------------

plotTable <- read_csv(here::here("ShinyMap/plotTable.csv"))
plotTable

# Define UI --------------------------------------------------------------------

ui <- fluidPage(
    br(),
    
    sidebarLayout(
        sidebarPanel(
            dateRangeInput("daterange3", "Date range:",
                           start  = "2021-07-31",
                           end    = "2021-10-08",
                           min    = "2021-07-31",
                           max    = "2021-10-08",
                           format = "mm/dd/yy",
                           separator = " - ")
            
        ),
        
        mainPanel(
            plotlyOutput(outputId = "map")
           
        )
    )
)

# Define server ----------------------------------------------------------------

server <- function(input, output, session) {
    
    output$testTable <- renderTable({
        fullTable <- plotTable %>% 
            filter(sellDay >= input$daterange3[1] & sellDay<= input$daterange3[2]) %>%
            group_by(statesOver) %>% 
            summarise(sellDay, statesOver, items, newCumulative = cumsum(items))
    })
    
    
    output$map <- renderPlotly({
        fullTable <- plotTable %>% 
            filter(sellDay >= input$daterange3[1] & sellDay<= input$daterange3[2]) %>%
            group_by(statesOver) %>% 
            summarise(sellDay, statesOver, items, newCumulative = cumsum(items))
        
        fullTable <- fullTable %>% 
            mutate(logSold=ifelse(newCumulative>0, log(newCumulative+1), 0))
        
        USMAP <- fullTable %>% 
            filter(sellDay >= input$daterange3[1]) %>% 
            plot_ly(
                type = 'choropleth',
                locations= ~statesOver,
                locationmode = 'USA-states' , 
                colorscale='tempo', z=~logSold,
                zmin=0, zmax=6,
                text=~newCumulative,
                hoverinfo='text',
                showscale=FALSE,
                frame=~as.Date(sellDay)) %>% 
            layout(geo=list( scope = 'usa' )) 
        
       
    })
}

# Create the Shiny app object --------------------------------------------------

shinyApp(ui = ui, server = server)
