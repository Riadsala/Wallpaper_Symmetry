library(tidyverse)


index_dat  <- read_csv("../../subgroups/subgroup_relations.csv")
normal_dat <- read_csv("../../subgroups/subgroup_normal.csv")

# sort out group names
group_names  <- index_dat$group
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
            group = group_names[ii], 
            subgroup = group_names[jj], 
            index = as.numeric(index_dat[ii,jj]),
            normal = normal_dat[ii,jj] == 1)
    }
} 

# filter by index to remove all non-valid relations
# also remove all indentity relationships
subgroups %>% filter(
    is.finite(index),
    group != subgroup) -> subgroups
