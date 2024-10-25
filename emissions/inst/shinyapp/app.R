# Load necessary packages
library(shiny)
library(ggplot2)
library(dplyr)
library(shinythemes)  # Optional: for applying themes

# Load the emissions dataset from the package
emissions <- read.csv(system.file("data", "cleaned_emissions.csv", package = "emissions"))

# Define UI for the app
ui <- fluidPage(
  theme = shinytheme("cerulean"),  # Optional: Use a theme to improve appearance
  titlePanel("Carbon Emissions Explorer"),

  sidebarLayout(
    sidebarPanel(
      h4("Filter the emissions data:"),  # Add title to sidebar
      selectInput("company", "Select Company", choices = unique(emissions$parent_entity)),
      helpText("Select the company whose emissions you would like to explore."),  # Help text for Company input

      sliderInput("year", "Select Year", min = min(emissions$year), max = max(emissions$year), value = c(2000, 2020)),
      helpText("Choose a year range to view emissions data.")  # Help text for Year input
    ),

    mainPanel(
      plotOutput("emissionPlot"),
      helpText("The plot shows total emissions (in MtCO2e) for the selected company and year range.")  # Help text to explain the plot
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

#' Launch Shiny App for Emissions Data
#'
#' This function launches the Shiny app that allows users to explore
#' carbon emissions data interactively by selecting different companies and years.
#' @export
run_shiny_app <- function() {
  app_dir <- system.file("shinyapp", package = "emissions")
  if (app_dir == "") {
    stop("Could not find Shiny app directory. Try re-installing `emissions`.", call. = FALSE)
  }
  shiny::runApp(app_dir, display.mode = "normal")
}

# Run the app
shinyApp(ui = ui, server = server)

# Part C:
  install.packages("pkgdown")
  usethis::use_pkgdown()
  pkgdown::build_site()
