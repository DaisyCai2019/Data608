#Question 2:
# 
# Often you are asked whether particular States are improving their mortality rates (per cause)
# faster than, or slower than, the national average. Create a visualization that lets your clients
# see this for themselves for one cause of death at the time. Keep in mind that the national
# average should be weighted by the national population.
#    



library(ggplot2)
library(dplyr)
library(plotly)
library(shiny)
library(rsconnect)

df <- read.csv('https://raw.githubusercontent.com/DaisyCai2019/NewData/master/cleaned-cdc-mortality-1999-2010-2.csv')


# Define UI for application that draws a histogram
ui <- fluidPage(
    
    headerPanel("National Mortality Rate VS States Mortality Rate by Causes 1999-2010"),
    sidebarPanel(
        selectInput('cause', 'Cause', unique(df$ICD.Chapter), selected='Neoplasms'),
        selectInput('state', 'State', unique(df$State), selected='NY')
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
        plotOutput("plot2")
    )
)


# Define server logic required to draw a histogram


server <- function(input, output) {
    
    output$plot2 <- renderPlot({
        
        dfSlice <- df %>%
            group_by(Year,ICD.Chapter) %>%
            mutate(sumPopulation=sum(Population),sumDeath=sum(Deaths),National_rate=(sumDeath/sumPopulation)*10^5) %>%
            select(ICD.Chapter, State, Year,Crude.Rate, National_rate)%>%
            filter(ICD.Chapter == input$cause, State==input$state)
        
        ggplot(dfSlice , aes(x = Year, y = Crude.Rate)) +
            labs(x = "Year", y = "Mortality Rate")+  
            geom_bar(stat = "identity") +
            geom_line(aes(x = Year, y = National_rate, linetype = "National Average"), col = "red", lwd = 1)
        
    })
    
}


# Run the application 
shinyApp(ui = ui, server = server)
