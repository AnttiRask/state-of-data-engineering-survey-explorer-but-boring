FROM rocker/r-ver:4.5.2

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy renv configuration for layer caching
COPY renv.lock renv.lock
COPY .Rprofile .Rprofile
COPY renv/activate.R renv/activate.R
COPY renv/settings.json renv/settings.json

# Install renv and restore packages
RUN Rscript -e "install.packages('renv', repos='https://cloud.r-project.org')"
RUN Rscript -e "renv::restore()"

# Copy application files
COPY app.R app.R
COPY R/ R/
COPY data/ data/
COPY www/ www/

# Expose port (Cloud Run will override with PORT env variable)
EXPOSE 8080

# Run Shiny app on PORT provided by Cloud Run
CMD ["R", "-e", "shiny::runApp(host='0.0.0.0', port=as.numeric(Sys.getenv('PORT', '8080')))"]
