library(tidyverse)

index_dat  <- read_csv("../subgroups/subgroup_relations.csv")
normal_dat <- read_csv("../subgroups/subgroup_normal.csv")

# sort out group names
group_names  <- str_to_upper(index_dat$group)
index_dat  <- index_dat[, -1]
normal_dat <- normal_dat[, -1]

# remove p1
group_names  <- group_names[-1]
index_dat  <- select(index_dat[-1,], -p1)
normal_dat <- select(normal_dat[-1,], -p1)

subgroups <- tibble(
    group = as.character(), 
    subgroup = as.character(), 
    index = as.numeric(),
    normal = as.logical())

for (ii in 1:nrow(index_dat)) {
    for (jj in 1:ncol(index_dat)) {

        subgroups <- add_row(subgroups, 
            group = group_names[jj], 
            subgroup = group_names[ii], 
            index = as.numeric(index_dat[ii,jj]),
            normal = normal_dat[ii,jj] == 1)
    }
} 

# list of comparisons to remove
to_remove <- list(
    "PM-CM", "CM-PM",
    "PMM-CMM", "CMM-PMM",
    "P3M1-P31M", "P31M-P3M1")

to_remove <- append(to_remove, unlist(paste(group_names, "-", group_names, sep = "")))

subgroups %>% 
    select(group, subgroup, index) %>%
    pivot_wider(
        names_from = subgroup, 
        values_from = index) %>%
    pivot_longer(
        -group, 
        values_to = "index", 
        names_to = "subgroup") %>%
    left_join(subgroups) %>%
    mutate(
        colour_code = if_else(paste(group, subgroup, sep="-") %in% to_remove, 2, 1), 
       index = as.character(index),
        index = if_else(is.na(index), "-", index),
        index = kableExtra::cell_spec(
             index, 
             italic = if_else(normal == TRUE, TRUE, FALSE),
             color = kableExtra::spec_color(colour_code, end = 0.95, na_color = "#FFFFFF")),
        ) %>%
    select(group, subgroup, index) %>% 
    pivot_wider(
        names_from = group, 
        values_from = index) -> index_table


# filter by index to remove all non-valid relations
# also remove all indentity relationships
subgroups %>% filter(
    is.finite(index),
    group != subgroup,
    !(paste(group, subgroup, sep="-") %in% to_remove)) %>%
    mutate(label = paste(group, "% -> %", subgroup)) -> subgroups
