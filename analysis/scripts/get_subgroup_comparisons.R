get_subgroup_comparisons2 <- function(m_samples, n_iter) {
  
  subgroup_comp <- tibble(key = as.character(), value = as.numeric(), 
                          d_ref = as.numeric(), d_rot = as.numeric(), d_gli = as.numeric())
  
  for (ii in 1:nrow(subgroups)) {
   subgroup_comp <- bind_rows(
     subgroup_comp,
     tibble(
       key = subgroups$label[ii],
       index = subgroups$index[ii],
       normal = subgroups$normal[ii],
       value = (m_samples[subgroups$subgroup[ii]] - m_samples[subgroups$group[ii]])[[1]],
       d_ref = filter(sym_dat, group == subgroups$group[ii])$reflection -
         filter(sym_dat, group == subgroups$subgroup[ii])$reflection,
       d_rot = filter(sym_dat, group == subgroups$group[ii])$rotation -
         filter(sym_dat, group == subgroups$subgroup[ii])$rotation,
       d_gli = filter(sym_dat, group == subgroups$group[ii])$glide -
         filter(sym_dat, group == subgroups$subgroup[ii])$glide))
  }
  
  subgroup_comp$index <- as.factor(subgroup_comp$index)
  
  return(subgroup_comp)
}

plot_comparisons <- function(d, l, fig_n, is_thresholds = FALSE) 
{
    d$key <- fct_drop(d$key)
    l$key <- fct_drop(l$key)
    
    x_labels <- expression()

    prob_relation <- mean(d$value)

    if (is_thresholds) {
        plt <- ggplot(d, aes(x = value, y = key, fill = prob_cat, colour = index)) 
    } else {
        plt <- ggplot(d, aes(x = value, y = key, fill = prob_cat, colour = index)) 
    }
    
    plt <- plt + geom_vline(xintercept = 0, linetype = 2) + 
        geom_line() +       
        geom_density_ridges(colour = "black", alpha = 0.75, bandwidth = 0.05) +
        ggstance::geom_linerangeh(colour = "black", size = 0.5, aes(y = key, xmin= -5, xmax= 5)) + 
        scale_x_continuous('pdf for subgroup difference', expand = c(0,0), breaks = seq(-2, 1, 0.5)) +
        scale_y_discrete(labels = levels(d$key)) + #labels = lapply(levels(subgroup_comp$key), TeX)
        theme_minimal() +        
        ggthemes::scale_colour_ptol(drop = FALSE) 
       
     if (is_thresholds) {
        plt <- plt + coord_cartesian((xlim = c(-2.2, 0.7))) + 
            scale_fill_grey("p(difference < 0 | data)", start = 1, end = 0.1, drop = FALSE)  
    } else {
         plt <- plt + coord_cartesian((xlim = c(-0.5, 1.5))) + 
            scale_fill_grey("p(difference > 0 | data)", start = 1, end = 0.1, drop = FALSE) 
    }

    #if (fig_n == 1) {
        plt <- plt + guides(colour = FALSE, fill = guide_legend(title = element_blank(), nrow = 1)) +
          theme(
            legend.position = 'bottom',
            axis.text.y = element_text(face = "italic"),
            axis.title.y = element_blank(),
            plot.margin=unit(c(0,0.25,0,0.25),"cm"))  
   # } else {
    #    plt <- plt + guides(fill = FALSE, colour = guide_legend(title.postion = "top", nrow = 2))
   # }

    
    return(plt)
}

plot_model_fits <- function(m_samples, my_fct_level_order) {

  m_samples %>%
    as_tibble() %>% 
    mutate_all(exp) %>%
    select(P2, PM, PG, CM, PMM, PMG, PGG, CMM, P4, P4M, P4G, P3, P3M1, P31M, P6, P6M) %>%
    gather() -> rms_model
  
  rms_model$key <- as_factor(rms_model$key)
  rms_model$key <- fct_relevel(rms_model$key, my_fct_level_order)

  ggplot(rms_model, aes(x = value, y = key)) +
    stat_pointintervalh(.width = c(.66, .95)) +
    geom_density_ridges(data = d, 
        aes(x = rms, y = wallpaper_group), 
        fill = "blue", 
        alpha = 0.25,
        scale = 2, bandwidth = 0.08) +
    scale_x_log10("rms") 
  ggsave(paste('plots/model_fits', fl, ".pdf", sep = ""), width = 5, height = 8)
}