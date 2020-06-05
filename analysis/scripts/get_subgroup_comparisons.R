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

get_subgroup_comparisons <- function(m_samples, n_iter)
{
    m_samples %>%
      as_tibble() %>% 
      mutate_all(exp) %>%
      mutate(
        'P4M$\\rightarrow$ P4G' = P4M - P4G,
        'P4M$\\rightarrow$ P4'  = P4M - P4,
        'P4M$\\rightarrow$ CMM' = P4M - CMM,
        'P4M$\\rightarrow$ PMM' = P4M - PMM, 
        'P6M$\\rightarrow$ P6' = P6M - P6,
        'P6M$\\rightarrow$ P31M' = P6M - P31M,
        'P6M$\\rightarrow$ P3M1' = P6M - P3M1,
        'PMM$\\rightarrow$ PMG' = PMM - PMG,
        'PMM$\\rightarrow$ PM' = PMM - PM,
        'PMM$\\rightarrow$ P2' = PMM - P2,
        'P3M1$\\rightarrow$ P3'= P3M1- P3,
        'CMM$\\rightarrow$ PMG' = CMM - PMG,
        'CMM$\\rightarrow$ PGG' = CMM - PGG,
        'CMM$\\rightarrow$ CM' = CMM - CM,
        'CMM$\\rightarrow$ P2' = CMM - P2,
        'P4G$\\rightarrow$ P4' = P4G - P4,
        'P4G$\\rightarrow$ CMM' = P4G - CMM,
        'P4G$\\rightarrow$ PGG' = P4G - PGG,
        'PMG$\\rightarrow$ PGG' = PMG - PGG, 
        'PMG$\\rightarrow$ PM' = PMG - PM,
        'PMG$\\rightarrow$ PG' = PMG - PG,
        'PMG$\\rightarrow$ P2' = PMG - P2,
        'P31M$\\rightarrow$ P3'= P31M- P3,
        'P6$\\rightarrow$ P3'  = P6  - P3,
        'CM$\\rightarrow$ PG'  = CM  - PG,
        'P4$\\rightarrow$ P2'  = P4  - P2,
        'PM$\\rightarrow$ PG'  = PM  - PG, 
        'PGG$\\rightarrow$ PG' = PGG - PG, 
        'PGG$\\rightarrow$ P2' = PGG - P2, 
        # 'P2$\\rightarrow$ PG'  = P2 - PG,
        'P6M$\\rightarrow$ CMM' = P6M - CMM,
        'P3M1$\\rightarrow$ CM' = P3M1 - CM,
        'P31M$\\rightarrow$ CM' = P31M - CM,
        'P6$\\rightarrow$ P2' = P6 - P2,
        'P4M$\\rightarrow$ PMG' = P4M - PMG,
        'P4M$\\rightarrow$ PGG' = P4M - PGG,
        'P4M$\\rightarrow$ CM' = P4M - CM,
        'P4M$\\rightarrow$ PM' = P4M - PM,
        'P4M$\\rightarrow$ P2' = P4M - P2,
        'P6M$\\rightarrow$ P3' = P6M - P3,
        'PMM$\\rightarrow$ PGG' = PMM - PGG,
        'PMM$\\rightarrow$ CM' = PMM -CM, 
        'PMM$\\rightarrow$ PG' = PMM -PG,
        'CMM$\\rightarrow$ PM' = CMM - PM,
        'CMM$\\rightarrow$ PG' = CMM - PG,
        'P4G$\\rightarrow$ PMM' = P4G - PMM,
        'P4G$\\rightarrow$ PMG' = P4G - PMG,
        'P4G$\\rightarrow$ CM' = P4G - CM,
        'P4G$\\rightarrow$ PG' = P4G - PG,
        'P4G$\\rightarrow$ P2' = P4G - P2,
        'PMG$\\rightarrow$ CM' = PMG - CM,
        'P6M$\\rightarrow$ PMM' = P6M - PMM,
        'P6M$\\rightarrow$ PMG' = P6M - PMG,
        'P6M$\\rightarrow$ PGG' = P6M - PGG,
        'P6M$\\rightarrow$ CM' = P6M - CM,
        'P6M$\\rightarrow$ P2' = P6M - P2,
        'P3M1$\\rightarrow$ PM' = P3M1 - PM,
        'P3M1$\\rightarrow$ PG' = P3M1 - PG,
        'P31M$\\rightarrow$ PM' = P31M - PM,
        'P31M$\\rightarrow$ PG' = P31M - PG,
        'P4G$\\rightarrow$ PM' = P4G - PM,
        'P4M$\\rightarrow$ PG' = P4M - PG,
        'P6M$\\rightarrow$ PG' = P6M - PG,
        'P6M$\\rightarrow$ PM' = P6M - PM
      ) %>%
      select(
        'P4M$\\rightarrow$ P4G',
        'P4M$\\rightarrow$ P4',  
        'P4M$\\rightarrow$ CMM', 
        'P4M$\\rightarrow$ PMM',
        'P6M$\\rightarrow$ P6', 
        'P6M$\\rightarrow$ P31M', 
        'P6M$\\rightarrow$ P3M1',
        'PMM$\\rightarrow$ PMG', 
        'PMM$\\rightarrow$ PM', 
        'PMM$\\rightarrow$ P2', 
        'P3M1$\\rightarrow$ P3',
        'CMM$\\rightarrow$ PMG', 
        'CMM$\\rightarrow$ PGG', 
        'CMM$\\rightarrow$ CM', 
        'CMM$\\rightarrow$ P2',
        'P4G$\\rightarrow$ P4', 
        'P4G$\\rightarrow$ CMM', 
        'P4G$\\rightarrow$ PGG',
        'PMG$\\rightarrow$ PGG', 
        'PMG$\\rightarrow$ PM', 
        'PMG$\\rightarrow$ PG', 
        'PMG$\\rightarrow$ P2', 
        'P31M$\\rightarrow$ P3',
        'P6$\\rightarrow$ P3',  
        'CM$\\rightarrow$ PG',  
        'P4$\\rightarrow$ P2',  
        'PM$\\rightarrow$ PG',  
        'PGG$\\rightarrow$ PG', 
        'PGG$\\rightarrow$ P2', 
        # 'P2$\\rightarrow$ PG' ,
        'P6M$\\rightarrow$ CMM', 
        'P3M1$\\rightarrow$ CM' ,
        'P31M$\\rightarrow$ CM' ,
        'P6$\\rightarrow$ P2' ,
        'P4M$\\rightarrow$ PMG' ,
        'P4M$\\rightarrow$ PGG' ,
        'P4M$\\rightarrow$ CM' ,
        'P4M$\\rightarrow$ PM' ,
        'P4M$\\rightarrow$ P2' ,
        'P6M$\\rightarrow$ P3' ,
        'PMM$\\rightarrow$ PGG' ,
        'PMM$\\rightarrow$ CM' ,
        'PMM$\\rightarrow$ PG' ,
        'CMM$\\rightarrow$ PM' ,
        'CMM$\\rightarrow$ PG' ,
        'P4G$\\rightarrow$ PMM' ,
        'P4G$\\rightarrow$ PMG' ,
        'P4G$\\rightarrow$ CM' ,
        'P4G$\\rightarrow$ PG' ,
        'P4G$\\rightarrow$ P2' ,
        'PMG$\\rightarrow$ CM' ,
        'P6M$\\rightarrow$ PMM' ,
        'P6M$\\rightarrow$ PMG' ,
        'P6M$\\rightarrow$ PGG' ,
        'P6M$\\rightarrow$ CM' ,
        'P6M$\\rightarrow$ P2' ,
        'P3M1$\\rightarrow$ PM' ,
        'P3M1$\\rightarrow$ PG' ,
        'P31M$\\rightarrow$ PM' ,
        'P31M$\\rightarrow$ PG' ,
        'P4G$\\rightarrow$ PM',
        'P4M$\\rightarrow$ PG',
        'P6M$\\rightarrow$ PG',
        'P6M$\\rightarrow$ PM'
      ) %>%
      gather() %>%
      mutate(
        index = as.factor(c(
          rep(2, n_iter * 29), 
          rep(3, n_iter * 4), 
          rep(4, n_iter * 17), 
          rep(6, n_iter * 9),
          rep(8, n_iter * 2),
          rep(12,n_iter * 2))),
        normal = c(
          rep(1, n_iter * 29), 
          rep(c(0, 0, 0, 1), each = n_iter), 
          rep(c(0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0), each = n_iter),
          rep(c(0, 0, 0, 0, 1, 0, 0, 0, 0), each = n_iter),
          rep(c(0, 0, 0, 0), each = n_iter)),
        key = as_factor(key),
        key = fct_rev(key)) -> subgroup_comp

    return(subgroup_comp)

}

plot_comparisons <- function(d, l, fig_n, is_thresholds = FALSE) 
{
    d$key <- fct_drop(d$key)
    l$key <- fct_drop(l$key)

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
        scale_x_continuous('pdf for difference between subgroups', expand = c(0,0), breaks = seq(-2, 1, 0.5)) +
        scale_y_discrete(labels = function(x) TeX(levels(d$key))) + #labels = lapply(levels(subgroup_comp$key), TeX)
        theme_minimal() +        
        ggthemes::scale_colour_ptol(drop = FALSE) +
        theme(
            legend.position = 'bottom',
            axis.text.y = element_text(
            face = if_else(l$normal==0, "bold", "plain"),
            colour = l$lab_cols),
            axis.title.y = element_blank(),
            plot.margin=unit(c(1,1,1.5,1.2),"cm"))  
       
     if (is_thresholds) {
        plt <- plt + coord_cartesian((xlim = c(-2.2, 0.7))) + 
            scale_fill_viridis_d("p(difference < 0 | data)", option = "plasma", drop = FALSE)  
    } else {
         plt <- plt + coord_cartesian((xlim = c(-0.5, 1.5))) + 
            scale_fill_viridis_d("p(difference > 0 | data)", option = "plasma", drop = FALSE) 
    }

    if (fig_n == 1) {
        plt <- plt + guides(colour = FALSE, fill = guide_legend(title = element_blank()))
    } else {
        plt <- plt + guides(fill = FALSE, colour = guide_legend(title.postion = "top"))
    }

    
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