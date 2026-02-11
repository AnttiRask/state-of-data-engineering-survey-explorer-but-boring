# Data Processing Module
# Functions for loading and transforming survey data

#' Load survey data from CSV
#' @return data.frame with survey responses
load_survey_data <- function() {
  df <- read.csv("data/survey_2026_data_engineering.csv",
                 stringsAsFactors = FALSE,
                 encoding = "UTF-8")

  # Clean whitespace from all character columns
  df <- df %>%
    mutate(across(where(is.character), trimws))

  return(df)
}

#' Prepare data for multi-select field charts
#' @param df data.frame with survey data
#' @param column character, column name to parse
#' @return data.frame with multi-select values separated into rows
prepare_multiselect_data <- function(df, column) {
  df %>%
    select(all_of(c("timestamp", column))) %>%
    separate_rows(!!sym(column), sep = ",\\s*") %>%
    filter(!is.na(!!sym(column)), !!sym(column) != "")
}

#' Get top N values from a column
#' @param df data.frame with survey data
#' @param column character, column name
#' @param n integer, number of top values to return
#' @return character vector of top N values
get_top_values <- function(df, column, n = 10) {
  df %>%
    count(!!sym(column), sort = TRUE) %>%
    slice_head(n = n) %>%
    pull(!!sym(column))
}
