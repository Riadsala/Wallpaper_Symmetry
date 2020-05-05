library(tidyverse)
library(forcats)
library(rethinking)
library(ggthemes)
# library(lme4)
# library(car)
# library(scales)
# --------------------------------------------------
# read in data
# remember that person 1,2 & 3 used a normal monitor
# --------------------------------------------------

people <- dir('../results/')

wallpaper_groups <- c('P2', 'PM' ,'PG', 'CM', 'PMM', 'PMG', 'PGG', 'CMM', 'P3', 'P3M1', 'P31M', 'P4', 'P4M', 'P4G', 'P6', 'P6M')

dat <- tibble(
	person = factor(levels = people), 
	group  = factor(levels = wallpaper_groups),
	rep    = as.numeric(),
	n      = as.numeric(),
	t 	   = as.numeric(),
	t1     = as.numeric(),
	t2     = as.numeric(),
	correct = as.numeric())

thresholds <- tibble(
	person = factor(levels = people), 
	group  = factor(levels = wallpaper_groups),
	staircase = as.numeric(),
	threshold = as.numeric())

for (person in people) {
	
	files <- dir(paste("../results/", person, sep="" ) , '*.txt')

	for (group in files) {

		# read in individual trial data
		d <- read_csv(paste("../results/", person, "/", group, sep=""))
		grp = unique(d$group)
		dat <- rbind(dat, d)
	}
	
	files <- dir(paste("../results/", person, "/thresholds/", sep="" ) , '*.txt')
	
	for (group in files) {

		grp = strsplit(group, split = ".", fixed=T )[[1]][1]
		# read in quest output
		d <- read_csv(
			paste("../results/", person, "/thresholds/", group, sep=""), 
			col_names = FALSE)
		thresholds <- bind_rows(thresholds, 
			tibble(person = person, group = grp, staircase = 1:5, threshold = d$X1))

		rm(d, grp)
	}
}

rm(people, person, group)

thresholds$person[thresholds$person=="person26"] <- "person0"

# relabel staircase 5 to 0, - it is the 'joint staircase' containing data from all others
thresholds$staircase[thresholds$staircase == 5] = 0

# relevel so groups are in order of increasing complexity
dat$group = as.factor(dat$group)
dat$group <- fct_relevel(dat$group, wallpaper_groups)

thresholds$group = as.factor(thresholds$group)
thresholds$group <- fct_relevel(thresholds$group, wallpaper_groups)

thresholds$log_threshold <- log(thresholds$threshold)
write_csv(filter(thresholds, staircase == 0), "thresholds.csv")
