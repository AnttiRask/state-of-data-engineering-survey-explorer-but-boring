# Chart Functions Module
# Reusable functions for creating ggplot2 bar charts

# Define the single blue color
CHART_COLOR <- "#2563eb"

#' Truncate long labels with ellipsis
#' @param labels character vector of labels
#' @param max_length integer, maximum character length
#' @return character vector with truncated labels
truncate_labels <- function(labels, max_length = 35) {
  ifelse(nchar(labels) > max_length,
         paste0(substr(labels, 1, max_length - 3), "..."),
         labels)
}

#' Create a horizontal bar chart
#' @param data data.frame with survey data
#' @param column character, column name to visualize
#' @param title character, chart title
#' @param top_n integer, limit to top N items (NULL for no limit)
#' @param dark_mode logical, whether to use dark mode styling
#' @return ggplot object
create_bar_chart <- function(data, column, title, top_n = NULL, dark_mode = FALSE) {
  # Count and sort
  chart_data <- data %>%
    count(!!sym(column), sort = TRUE) %>%
    filter(!is.na(!!sym(column)), !!sym(column) != "")

  # Limit to top N if specified
  if (!is.null(top_n)) {
    chart_data <- chart_data %>% slice_head(n = top_n)
  }

  # Truncate long labels
  col_name <- rlang::sym(column)
  chart_data[[column]] <- truncate_labels(chart_data[[column]])

  # Set colors based on dark mode
  bg_color <- if (dark_mode) "#1f2937" else "#ffffff"
  text_color <- if (dark_mode) "#e5e7eb" else "#000000"
  grid_color <- if (dark_mode) "#374151" else "#e5e7eb"

  # Create chart
  ggplot(chart_data, aes(x = reorder(!!sym(column), n), y = n)) +
    geom_col(fill = CHART_COLOR) +
    coord_flip() +
    labs(title = title, x = NULL, y = "Count") +
    theme_minimal() +
    theme(
      plot.background = element_rect(fill = bg_color, color = NA),
      panel.background = element_rect(fill = bg_color, color = NA),
      plot.title = element_text(face = "bold", size = 14, color = text_color),
      axis.text = element_text(size = 10, color = text_color),
      axis.text.y = element_text(size = 9, color = text_color),
      axis.title.x = element_text(size = 11, color = text_color),
      panel.grid.major.x = element_line(color = grid_color),
      panel.grid.major.y = element_blank(),
      panel.grid.minor = element_blank(),
      plot.margin = unit(c(5, 5, 5, 5), "pt")
    )
}

#' Create a horizontal bar chart for multi-select fields
#' @param data data.frame with survey data
#' @param column character, column name with comma-separated values
#' @param title character, chart title
#' @param top_n integer, limit to top N items
#' @param dark_mode logical, whether to use dark mode styling
#' @return ggplot object
create_multiselect_chart <- function(data, column, title, top_n = 10, dark_mode = FALSE) {
  # Parse multi-select field and count
  chart_data <- data %>%
    select(all_of(column)) %>%
    separate_rows(!!sym(column), sep = ",\\s*") %>%
    filter(!is.na(!!sym(column)), !!sym(column) != "") %>%
    count(!!sym(column), sort = TRUE) %>%
    slice_head(n = top_n)

  # Truncate long labels
  chart_data[[column]] <- truncate_labels(chart_data[[column]])

  # Set colors based on dark mode
  bg_color <- if (dark_mode) "#1f2937" else "#ffffff"
  text_color <- if (dark_mode) "#e5e7eb" else "#000000"
  grid_color <- if (dark_mode) "#374151" else "#e5e7eb"

  # Create chart
  ggplot(chart_data, aes(x = reorder(!!sym(column), n), y = n)) +
    geom_col(fill = CHART_COLOR) +
    coord_flip() +
    labs(title = title, x = NULL, y = "Count") +
    theme_minimal() +
    theme(
      plot.background = element_rect(fill = bg_color, color = NA),
      panel.background = element_rect(fill = bg_color, color = NA),
      plot.title = element_text(face = "bold", size = 13, color = text_color),
      axis.text = element_text(size = 10, color = text_color),
      axis.text.y = element_text(size = 9, color = text_color),
      axis.title.x = element_text(size = 10, color = text_color),
      panel.grid.major.x = element_line(color = grid_color),
      panel.grid.major.y = element_blank(),
      panel.grid.minor = element_blank(),
      plot.margin = unit(c(5, 5, 5, 5), "pt")
    )
}
