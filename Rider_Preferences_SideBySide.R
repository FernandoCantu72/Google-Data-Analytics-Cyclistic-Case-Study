# Rider_Preferences_SideBySide_TransparentBG.R
# Purpose: Build side-by-side pie charts for 'casual%' and 'member%' riders with a transparent background on the PNG output.
# Requires: DBI, odbc, dplyr, ggplot2, patchwork
# Output: Displays the combined chart and saves it with a transparent background as "rider_bike_preference_side_by_side.png"

# ---- Packages ----
required <- c("DBI","odbc","dplyr","ggplot2","patchwork")
to_install <- setdiff(required, rownames(installed.packages()))
if (length(to_install)) install.packages(to_install, repos = "https://cloud.r-project.org")
invisible(lapply(required, library, character.only = TRUE))

# ---- Connect to SQL Server ----
con <- DBI::dbConnect(
  odbc::odbc(),
  Driver   = "ODBC Driver 17 for SQL Server",
  Server   = "localhost\\SQLEXPRESS",
  Database = "Cycling",
  Trusted_Connection = "Yes"
)

stopifnot(DBI::dbIsValid(con))

# ---- Query both rider types ----
df <- DBI::dbGetQuery(con, "
SELECT 
    member_casual,
    rideable_type,
    COUNT(*) AS ride_count
FROM [Cycling].[dbo].[tripdata]
WHERE rideable_type IN ('electric_bike','classic_bike')
  AND (member_casual LIKE 'casual%' OR member_casual LIKE 'member%')
GROUP BY member_casual, rideable_type;
")

# ---- Prepare data ----
df <- df |>
  dplyr::mutate(
    rider_group = dplyr::case_when(
      grepl('^casual', tolower(member_casual)) ~ 'Casual Riders',
      grepl('^member', tolower(member_casual)) ~ 'Annual Members',
      TRUE ~ member_casual
    ),
    bike_type = dplyr::recode(tolower(rideable_type),
                              'electric_bike' = 'Electric Bike',
                              'classic_bike'  = 'Classic Bike',
                              .default = rideable_type)
  ) |>
  dplyr::group_by(rider_group) |>
  dplyr::mutate(percentage = ride_count / sum(ride_count) * 100) |>
  dplyr::ungroup()

# ---- Split into two data frames ----
casual_df <- dplyr::filter(df, rider_group == "Casual Riders")
member_df <- dplyr::filter(df, rider_group == "Annual Members")

# ---- Pie chart helper ----
make_pie <- function(dat, title_text) {
  ggplot(dat, aes(x = '', y = ride_count, fill = bike_type)) +
    geom_bar(stat = "identity", width = 1) +
    coord_polar(theta = "y") +
    labs(title = title_text, fill = "Rideable Type") +
    geom_text(
      aes(label = paste0(round(percentage, 1), "%")),
      position = position_stack(vjust = 0.5),
      color = "white",
      size = 5
    ) +
    theme_void() +
    theme(
      plot.title = element_text(hjust = 0.5, size = 18, face = "bold"),
      plot.background = element_rect(fill = NA, color = NA),
      panel.background = element_rect(fill = NA, color = NA)
    )
}

# ---- Create pie charts ----
p1 <- make_pie(casual_df, "Casual Riders Bike Preference")
p2 <- make_pie(member_df, "Annual Members Bike Preference")

# ---- Combine side by side with transparent background ----
combined <- p1 + p2 + patchwork::plot_annotation(
  title = "Cyclistic Riders Bike Preferences",
  theme = theme(plot.title = element_text(hjust = 0.5, size = 20, face = "bold"),
                plot.background = element_rect(fill = NA, color = NA))
)

print(combined)

# ---- Save with transparent background ----
ggsave(
  filename = "rider_bike_preference_side_by_side.png",
  plot = combined,
  width = 14,
  height = 6,
  dpi = 150,
  bg = "transparent"  # transparent background
)

# ---- Disconnect ----
DBI::dbDisconnect(con)

message("Saved with transparent background: rider_bike_preference_side_by_side.png")
