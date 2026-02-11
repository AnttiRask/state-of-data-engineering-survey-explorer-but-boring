# Survey Explorer Shiny App
# 2026 State of Data Engineering Survey Hackathon

library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)
library(shinyjs)

# Load helper functions
source("R/data_processing.R")
source("R/chart_functions.R")

# Load data once at startup
survey_data <- load_survey_data()

# Define UI
ui <- fluidPage(
  # Initialize shinyjs
  useShinyjs(),

  # Include custom CSS
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
  ),

  titlePanel("2026 Practical Data Community State of Data Engineering (but boring)"),

  # Filters section at top
  fluidRow(
    class = "filters-container",
    column(12,
      fluidRow(
        column(10, h4("Filters")),
        column(2,
          div(class = "dark-mode-toggle",
            checkboxInput("dark_mode", "🌙 Dark Mode", value = FALSE)
          )
        )
      ),
      fluidRow(
        column(2,
          selectizeInput(
            "filter_role",
            "Role:",
            choices = NULL,
            multiple = TRUE,
            options = list(placeholder = "All roles")
          )
        ),
        column(2,
          selectizeInput(
            "filter_org_size",
            "Organization Size:",
            choices = NULL,
            multiple = TRUE,
            options = list(placeholder = "All sizes")
          )
        ),
        column(2,
          selectizeInput(
            "filter_industry",
            "Industry:",
            choices = NULL,
            multiple = TRUE,
            options = list(placeholder = "All industries")
          )
        ),
        column(2,
          selectizeInput(
            "filter_region",
            "Region:",
            choices = NULL,
            multiple = TRUE,
            options = list(placeholder = "All regions")
          )
        ),
        column(2,
          selectizeInput(
            "filter_ai_usage",
            "AI Usage Frequency:",
            choices = NULL,
            multiple = TRUE,
            options = list(placeholder = "All frequencies")
          )
        ),
        column(2,
          tags$label(HTML("&nbsp;")),
          actionButton("reset_filters", "Reset All Filters", class = "btn-secondary"),
          br(), br(),
          textOutput("filter_summary")
        )
      )
    )
  ),

  # Charts section
  fluidRow(
    column(4, div(class = "chart-box", plotOutput("chart_role", height = "350px"))),
    column(4, div(class = "chart-box", plotOutput("chart_org_size", height = "350px"))),
    column(4, div(class = "chart-box", plotOutput("chart_industry", height = "350px")))
  ),

  fluidRow(
    column(4, div(class = "chart-box", plotOutput("chart_ai_usage", height = "350px"))),
    column(4, div(class = "chart-box", plotOutput("chart_storage", height = "350px"))),
    column(4, div(class = "chart-box", plotOutput("chart_architecture", height = "350px")))
  ),

  fluidRow(
    column(4, div(class = "chart-box", plotOutput("chart_team_growth", height = "350px"))),
    column(4, div(class = "chart-box", plotOutput("chart_bottleneck", height = "350px"))),
    column(4, div(class = "chart-box", plotOutput("chart_region", height = "350px")))
  ),

  fluidRow(
    column(4, div(class = "chart-box", plotOutput("chart_modeling_approach", height = "350px"))),
    column(4, div(class = "chart-box", plotOutput("chart_pain_points", height = "350px"))),
    column(4, div(class = "chart-box", plotOutput("chart_education", height = "350px")))
  )
)

# Define server logic
server <- function(input, output, session) {

  # Dark mode toggle
  observeEvent(input$dark_mode, {
    if (input$dark_mode) {
      runjs("document.body.classList.add('dark-mode');")
    } else {
      runjs("document.body.classList.remove('dark-mode');")
    }
  })

  # Create reactive for dark mode state (for charts)
  dark_mode <- reactive({
    input$dark_mode
  })

  # Initialize filter choices
  observe({
    updateSelectizeInput(session, "filter_role",
                         choices = sort(unique(survey_data$role[!is.na(survey_data$role)])),
                         server = TRUE)

    updateSelectizeInput(session, "filter_org_size",
                         choices = sort(unique(survey_data$org_size[!is.na(survey_data$org_size)])))

    updateSelectizeInput(session, "filter_industry",
                         choices = sort(unique(survey_data$industry[!is.na(survey_data$industry)])))

    updateSelectizeInput(session, "filter_region",
                         choices = sort(unique(survey_data$region[!is.na(survey_data$region)])))

    updateSelectizeInput(session, "filter_ai_usage",
                         choices = sort(unique(survey_data$ai_usage_frequency[!is.na(survey_data$ai_usage_frequency)])))
  })

  # Reset filters button
  observeEvent(input$reset_filters, {
    updateSelectizeInput(session, "filter_role", selected = character(0))
    updateSelectizeInput(session, "filter_org_size", selected = character(0))
    updateSelectizeInput(session, "filter_industry", selected = character(0))
    updateSelectizeInput(session, "filter_region", selected = character(0))
    updateSelectizeInput(session, "filter_ai_usage", selected = character(0))
  })

  # Reactive filtered data
  filtered_data <- reactive({
    data <- survey_data

    if (!is.null(input$filter_role) && length(input$filter_role) > 0) {
      data <- data %>% filter(role %in% input$filter_role)
    }

    if (!is.null(input$filter_org_size) && length(input$filter_org_size) > 0) {
      data <- data %>% filter(org_size %in% input$filter_org_size)
    }

    if (!is.null(input$filter_industry) && length(input$filter_industry) > 0) {
      data <- data %>% filter(industry %in% input$filter_industry)
    }

    if (!is.null(input$filter_region) && length(input$filter_region) > 0) {
      data <- data %>% filter(region %in% input$filter_region)
    }

    if (!is.null(input$filter_ai_usage) && length(input$filter_ai_usage) > 0) {
      data <- data %>% filter(ai_usage_frequency %in% input$filter_ai_usage)
    }

    return(data)
  })

  # Filter summary
  output$filter_summary <- renderText({
    paste("Showing", nrow(filtered_data()), "of", nrow(survey_data), "responses")
  })

  # Chart outputs
  output$chart_role <- renderPlot({
    create_bar_chart(filtered_data(), "role", "By Role", top_n = 15, dark_mode = dark_mode())
  })

  output$chart_org_size <- renderPlot({
    create_bar_chart(filtered_data(), "org_size", "By Organization Size", dark_mode = dark_mode())
  })

  output$chart_industry <- renderPlot({
    create_bar_chart(filtered_data(), "industry", "By Industry", dark_mode = dark_mode())
  })

  output$chart_ai_usage <- renderPlot({
    create_bar_chart(filtered_data(), "ai_usage_frequency", "AI Usage Frequency", dark_mode = dark_mode())
  })

  output$chart_storage <- renderPlot({
    create_bar_chart(filtered_data(), "storage_environment", "Storage Environment", top_n = 10, dark_mode = dark_mode())
  })

  output$chart_architecture <- renderPlot({
    create_bar_chart(filtered_data(), "architecture_trend", "Architecture Trend", top_n = 10, dark_mode = dark_mode())
  })

  output$chart_team_growth <- renderPlot({
    create_bar_chart(filtered_data(), "team_growth_2026", "Team Growth Expectations", dark_mode = dark_mode())
  })

  output$chart_bottleneck <- renderPlot({
    create_bar_chart(filtered_data(), "biggest_bottleneck", "Biggest Bottleneck", top_n = 10, dark_mode = dark_mode())
  })

  output$chart_region <- renderPlot({
    create_bar_chart(filtered_data(), "region", "By Region", dark_mode = dark_mode())
  })

  output$chart_modeling_approach <- renderPlot({
    create_bar_chart(filtered_data(), "modeling_approach", "Data Modeling Approach", top_n = 10, dark_mode = dark_mode())
  })

  output$chart_pain_points <- renderPlot({
    create_multiselect_chart(filtered_data(), "modeling_pain_points", "Data Modeling Pain Points", top_n = 10, dark_mode = dark_mode())
  })

  output$chart_education <- renderPlot({
    create_bar_chart(filtered_data(), "education_topic", "Desired Training Topics", top_n = 10, dark_mode = dark_mode())
  })
}

# Run the app
shinyApp(ui = ui, server = server)
