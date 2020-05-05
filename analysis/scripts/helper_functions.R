get_model_samples <- function(my_model) {
  
  my_samples <- posterior_samples(my_model)
  
  names(my_samples)  %>% 
    gsub('[b_]*wallpaper_group', "", .) -> names(my_samples)
  
  return(my_samples)
}

get_model_predictions <- function(my_samples) {
  my_samples %>%
    as_tibble() %>% 
    mutate_all(exp) %>%
    select(P2, PM, PG, CM, PMM, PMG, PGG, CMM, P4, P4M, P4G, P3, P3M1, P31M, P6, P6M) %>%
    gather() -> my_model_predictions
  
  return(my_model_predictions)
}

plot_model_output <- function(mdat, edat, my_title, my_colour, x_label) {
  x_var <- names(edat)[3]
  # plot model fit (mdat) against empiricaly data (edat)
  plt <- ggplot(mdat, aes(x = value, y = key)) +
    stat_pointintervalh(.width = c(.66, .95), colour = my_colour) +
    geom_density_ridges(data = edat,aes_string(x = x_var, "wallpaper_group"),
                        fill = "grey",
                        alpha = 0.25,
                        scale = 2,
                        bandwidth = 0.05) +
    scale_x_log10(x_label) +
    scale_y_discrete("wallpaper group") +
    ggtitle(my_title) +
    theme_lucid()
  
  return(plt)
}