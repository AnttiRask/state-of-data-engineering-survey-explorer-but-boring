# Survey Explorer - 2026 Data Engineering Survey

Interactive Shiny dashboard visualizing the 2026 State of Data Engineering Survey results with 12 bar charts and dynamic filters.

**Live Demo:** https://surveyexplorerbutboring.youcanbeapirate.com
**Cloud Run URL:** https://survey-explorer-927657136414.us-central1.run.app
**Documentation:** https://youcanbeapirate.com/SurveyExplorerButBoring

## Features

- 🌙 **Dark Mode** - Toggle between light and dark themes
- 📊 **12 Interactive Bar Charts** - Covering roles, org size, industry, AI usage, technologies, and pain points
- 🔍 **5 Multi-Select Filters** - Role, Organization Size, Industry, Region, AI Usage Frequency
- 🎨 **Clean Single-Color Design** - Professional #2563eb blue theme
- ⚡ **Real-Time Filtering** - Instant updates with response counter
- ☁️ **Cloud Deployed** - Optimized for Google Cloud Run with auto-scaling

## Local Development

### Prerequisites
- R 4.5+ installed
- Required packages managed via renv

### Run Locally

```bash
# Restore R packages
Rscript -e "renv::restore()"

# Run the app
Rscript -e "shiny::runApp(port=3838)"
```

Visit http://localhost:3838

## Docker Testing

```bash
# Build image
docker build -t survey-explorer .

# Run container
docker run -p 8080:8080 -e PORT=8080 survey-explorer
```

Visit http://localhost:8080

## Deploy to Google Cloud Run

### Prerequisites
- gcloud CLI installed and authenticated
- GCP project with billing enabled
- Cloud Run API enabled

### One-Command Deployment

```bash
gcloud run deploy survey-explorer \
  --source . \
  --region us-central1 \
  --platform managed \
  --allow-unauthenticated \
  --memory 2Gi \
  --cpu 2 \
  --timeout 300 \
  --max-instances 10 \
  --min-instances 0
```

### Get Deployed URL

```bash
gcloud run services describe survey-explorer \
  --region us-central1 \
  --format="value(status.url)"
```

### View Logs

```bash
gcloud run services logs read survey-explorer \
  --region us-central1 \
  --limit 50
```

## Project Structure

```
survey-explorer/
├── app.R                              # Main Shiny application
├── R/
│   ├── data_processing.R              # Data loading and transformation
│   └── chart_functions.R              # Chart generation functions
├── data/
│   └── survey_2026_data_engineering.csv  # Survey dataset
├── www/                                # Static assets (CSS, images)
├── renv.lock                          # R package dependencies
├── .Rprofile                          # renv activation
├── Dockerfile                         # Container definition
└── .dockerignore                      # Build exclusions
```

## Charts Included

1. By Role (top 15)
2. By Organization Size
3. By Industry
4. AI Usage Frequency
5. Storage Environment (top 10)
6. Architecture Trend (top 10)
7. Team Growth Expectations
8. Biggest Bottleneck (top 10)
9. By Region
10. Data Modeling Approach (top 10)
11. Data Modeling Pain Points (top 10, multi-select)
12. Desired Training Topics (top 10)

## Technology Stack

- **R 4.5.2**
- **Shiny 1.12.1** - Web framework
- **shinyjs 2.1.1** - JavaScript interactions for dark mode
- **dplyr 1.2.0** - Data manipulation
- **tidyr 1.3.2** - Data tidying
- **ggplot2 4.0.2** - Data visualization
- **renv 1.1.5** - Dependency management
- **Docker** - Containerization
- **Google Cloud Run** - Serverless deployment

## License

Created for the 2026 State of Data Engineering Survey Hackathon
