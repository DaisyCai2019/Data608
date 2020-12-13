library(tidyverse)
library(plyr)
library(ggplot2)
library(dplyr)
library(shiny)
library(rsconnect)
library(Amelia)
library(lubridate)
library(leaflet)



motor_c1<-read.csv('https://raw.githubusercontent.com/DaisyCai2019/NewData/master/Motor_Vehicle_Collisions_-_Crashes_processed1.csv')
motor_c2<-read.csv('https://raw.githubusercontent.com/DaisyCai2019/NewData/master/Motor_Vehicle_Collisions_-_Crashes_processed2.csv')
motor<-rbind(motor_c1,motor_c2)
motor2<-motor %>%
    filter(BOROUGH!="")

motor3<-motor2 %>%
    filter(LATITUDE!="" , LONGITUDE!="")




# Define UI for application that draws a histogram
ui <- fluidPage(
    
    headerPanel("Motor_Vehicle_Collision"),
    
    sidebarLayout(
    sidebarPanel(
        h4('Collision by Borough'),
        selectInput('BOROUGH', 'BOROUGH', unique(motor2$BOROUGH), selected='MANHATTAN')
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
        plotOutput("plot1")
       )
    
    ),
    
    sidebarLayout(
        sidebarPanel(
            h4('Map of Motor Vehicle Collisions'),
            selectInput('Year', 'Year', unique(motor2$Year), selected='2017')
        ),
        mainPanel(
            leafletOutput("plot2")
        )
    )
    
)


# Define server logic required to draw a histogram


server <- function(input, output) {
    
    output$plot1 <- renderPlot({
        
        dfSlice <- motor %>%
            group_by(BOROUGH) %>%
            select(Year, BOROUGH)%>%
            count %>%
            filter(BOROUGH==input$BOROUGH)
        
        
        
        ggplot(dfSlice , aes(x = Year, y = freq)) +
            labs(x = "Year", y = "Number")+  
            geom_bar(stat = "identity",fill = "#FF6666")+geom_text(aes(label = freq), vjust = 1.3, colour = "white")
        
    })
    
    
    output$plot2 <- renderLeaflet({
        
        dfSlice <- motor3 %>%
            filter(Year==input$Year)
        
        leaflet(motor3) %>%
            setView(-74.00, 40.71, zoom = 14) %>%
            addTiles %>%
            addMarkers(clusterOptions = markerClusterOptions())
        
    })
}


# Run the application 
shinyApp(ui = ui, server = server)
