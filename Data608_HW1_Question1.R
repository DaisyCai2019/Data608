# Question 1:
# 
# As a researcher, you frequently compare mortality rates from particular causes across
# different States. You need a visualization that will let you see (for 2010 only) the crude
# mortality rate, across all States, from one cause (for example, Neoplasms, which are
# effectively cancers). Create a visualization that allows you to rank States by crude mortality
# for each cause of death.
#

library(ggplot2)
library(dplyr)
library(shiny)
library(rsconnect)


df <- read.csv('https://raw.githubusercontent.com/DaisyCai2019/NewData/master/cleaned-cdc-mortality-1999-2010-2.csv')
df<-df %>%
    filter(Year == '2010')
   

# Define UI for application that draws a histogram
ui <- fluidPage(

        headerPanel("Mortality Rate Across All States by Causes 1999-2010"),
        sidebarPanel(
            selectInput('cause', 'Cause', unique(df$ICD.Chapter), selected='Neoplasms')
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("plot1")
        )
    )


# Define server logic required to draw a histogram


server <- function(input, output) {
    
    output$plot1 <- renderPlot({
        
        ggplot(df[df$ICD.Chapter == input$cause,] , aes(x = reorder(State, Crude.Rate), y = Crude.Rate, fill=State)) +
            labs(x = "State", y = "Mortality Rate") +  
            geom_bar(stat = "identity",position=position_dodge(), colour="black", width = 0.7) +
            coord_flip() 
    })
    
}


# Run the application 
shinyApp(ui = ui, server = server)
