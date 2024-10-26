# Load necessary packages
library(shiny)
library(ggplot2)
library(dplyr)

# Load the emissions dataset from the package
emissions <- read.csv(system.file("data", "cleaned_emissions.csv", package = "emissions"))

# Define UI for the app
ui <- fluidPage(
  titlePanel("Carbon Emissions Explorer"),
  sidebarLayout(
    sidebarPanel(
      selectInput("company", "Select Company", choices = unique(emissions$parent_entity)),
      sliderInput("year", "Select Year", min = min(emissions$year), max = max(emissions$year), value = c(2000, 2020))
    ),
    mainPanel(
      plotOutput("emissionPlot")
    )
  )
)

# Define server logic for the app
server <- function(input, output) {
  output$emissionPlot <- renderPlot({
    filtered_data <- emissions %>%
      filter(parent_entity == input$company, year >= input$year[1], year <= input$year[2])

    ggplot(filtered_data, aes(x = year, y = total_emissions_MtCO2e)) +
      geom_line() +
      labs(title = paste("Emissions for", input$company))
  })
}

# Return the Shiny app object
shinyApp(ui = ui, server = server)
