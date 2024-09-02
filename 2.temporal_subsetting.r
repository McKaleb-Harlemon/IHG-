library(magrittr)
library(tidyverse)
library(lubridate)

options(width = 90, scipen = 999)

####################################################################################
####################################################################################
##### Folder/File Paths

fold_pth <- "~/personal_ds7900/"
##################################################################
subset_pth <- paste0(fold_pth, "temporal_subsets/")
email_subset_pth <- paste0(subset_pth, "email_history_subsets/")
stay_subset_pth <- paste0(subset_pth, "stay_history_subsets/")
paths_list_pth <- paste0(email_subset_pth, "path_list.csv")
##################################################################
email_hist_pth <- paste0(fold_pth, "original_data/", "email_hist", ".csv")
stay_hist_pth <- paste0(fold_pth, "original_data/", "stay_hist", ".csv")
members_pth <- paste0(fold_pth, "original_data/", "members", ".csv")
##################################################################
dir.create(subset_pth, showWarnings = FALSE)       # fold_pth -> temporal_subsets
dir.create(email_subset_pth, showWarnings = FALSE) # temporal_subsets -> email_history_subsets
dir.create(stay_subset_pth, showWarnings = FALSE)  # temporal_subsets -> stay_history_subsets

paths_list <- c()

####################################################################################
####################################################################################
##### Email History data

email_hist_df <- read_csv(email_hist_pth,
                          col_types = c(HASH_NBR = "c",
                                        CAMPAIGN_NBR = "c",
                                        CLICK = "c",
                                        SEND_DT = "D",
                                        MBR_TIER = "c",
                                        MBR_PRGM_ACTV = "c",
                                        CAMPAIGN_NM = "c",
                                        UNSUB_IND = "c"))

####################################################################################
####################################################################################
##### Year: 2020 - subset and removal from population

#    1. Create 'temp_file_name' using 'ALL_{year}.csv' format. 
#    2. Create 'temp_pth' by join 'email_subset_pth' & 'temp_file_name'.
#   2a. Append 'temp_pth' to the paths list for later use.
#    3. From the data population, filter in data where the year is 2020
#    4. Write the return of 3 to a csv at 'temp_pth'.
#    5. From the data population, filter in data where the year is not 2020 and assign to 'email_hist_df'

temp_file_name <- paste0("ALL", "_", "2020", ".csv") #  1.
temp_pth <- paste0(email_subset_pth, temp_file_name) #  2.
paths_list <- append(paths_list, temp_pth)           # 2a.

email_hist_df %>% filter(yr == 2020) %>%             #  3.
                  write_csv(temp_pth)                #  4.

email_hist_df %<>% filter(yr != 2020)                #  5.

print(nrow(email_hist_df %>% filter(yr == 2020))) # should be zero


#####################################
##### Year: 2022, Month: January - subset, save, and removal from population

#    1. Create 'temp_file_name' using '{month}_{year}.csv' format. 
#    2. Create 'temp_pth' by join 'email_subset_pth' & 'temp_file_name'.
#   2a. Append 'temp_pth' to the paths list for later use.
#    3. From the data population, filter in data where the year is 2022
#    4. Write the return of 3 to a csv at 'temp_pth'.
#    5. From the data population, filter in data where the year is not 2022 and assign to 'email_hist_df'

temp_file_name <- paste0("Jan", "_", "2022", ".csv")         #  1.
temp_pth <- paste0(email_subset_pth, temp_file_name)         #  2.
paths_list <- append(paths_list, temp_pth)                   # 2a.

email_hist_df %>% filter((yr == 2022) & (mnth == "Jan")) %>% #  3.
                  write_csv(temp_pth)                        #  4.

email_hist_df %<>% filter((yr != 2022) & (mnth != "Jan"))    #  5.

print(nrow(email_hist_df %>% filter(yr == 2022))) # should be zero


#####################################
##### Year: 2021 - Loop over the year and for each month
#                   subset save, and remove from the population

#       1. For i in the sequence from 1 to the number of months (12).
#       2.      IF i minus the number of months is greater than zero, THEN add one to the year.
#       3.      IF i is greater than the number of months, THEN subtract 12 from i.
#       4.      Create 'temp_file_name' using '{month}_{year}.csv' format.
#       5.      Create 'temp_pth' by join 'email_subset_pth' & 'temp_file_name'.
#      5a.      Append 'temp_pth' to the paths list for later use.
#       6.      From the data population, filter in data for that year, month combination.
#       7.      Write the return of 6 to a csv at 'temp_pth'.
#       8.      IF i is less than the number of months in a year, THEN add one to i and return to 1.

y <- 2021

for (i in seq(1, 12, 1)) {                                                                 #  1.
    if (i - 12 > 0) { y <- y + 1 }                                                         #  2.
    if (i > 12) { i <- i - 12 }                                                            #  3.
    temp_file_name <- paste0(lubridate::month(i, label = TRUE), "_", y, ".csv")            #  4.
    temp_pth <- paste0(email_subset_pth, temp_file_name)                                   #  5.
    paths_list <- append(paths_list, temp_pth)                                             # 5a.
    email_hist_df %>% filter((yr == y) & (mnth == lubridate::month(i, label = TRUE))) %>%  #  6.
        write_csv(temp_pth)                                                                #  7.
    }                                                                                      #  8.

tibble("email_paths" = paths_list) %>% write_csv(paths_list_pth)

####################################################################################
####################################################################################
