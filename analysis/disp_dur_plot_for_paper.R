library(tidyverse)


fl <- "thresholds"

my_cols_threshold <- cols(
  person = col_character(),
  group = col_character(),
  staircase = col_double(),
  threshold = col_double(),
  log_threshold = col_double()
)

read_csv("../Experiment/process_results/thresholds.csv", col_types = my_cols_threshold) %>%
  select(subject = "person", wg = "group", threshold) %>%
  mutate(
  	wg = as_factor(wg),
  	wg = fct_relevel(wg, 
  		"P2", "PG", "P3", "PGG", "PM", "P4", "CM", "P6", "P31M", "PMG", "P4G", "CMM", "P3M1", "PMM", "P6M", "P4M"),
  	wg = fct_rev(wg)) %>%
  glimpse() -> d_dispthresh 

rm(my_cols_threshold)

d_dispthresh %>% ggplot(aes(y = threshold * 1000, x = wg)) +
	geom_boxplot(width = 0.25, fill = "grey") + coord_flip() +
	theme_minimal() +
	scale_y_log10("display duration threshold (ms)") +
	theme(
		panel.grid.minor = element_blank(),  
		axis.title.y = element_blank(),
		panel.grid.major = element_line(colour = "#E9E9E9"))
	ggsave("disp_dur_boxplots.pdf", width = 2, height = 12)