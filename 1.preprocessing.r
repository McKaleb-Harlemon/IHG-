library(magrittr)
library(tidyverse)
library(lubridate)

options(width = 120, scipen = 999)

####################################################################################

# Lubridate functions
##### https://rawgit.com/rstudio/cheatsheets/main/lubridate.pdf
#
## year(DATE_value)     : extracts the year from a date
## month(DATE_value)    : extracts the month from a date
## day(DATE_value)      : extracts the day from a date
#
## dyears(year_value)   :  year * 31,536,000 seconds -> number of years in seconds
## dmonths(month_value) : month *  2,629,800 seconds -> number of months in seconds
## ddays(day_value)     :   day *     86,400 seconds -> number of days in seconds

####################################################################################
####################################################################################
##### Folder/File Paths

fold_pth <- "~/personal_ds7900/"
##################################################################
email_hist_pth <- paste0("~/ds7900_spring23_team2/email_hist/email_hist.csv")
stay_hist_pth <- paste0("~/ds7900_spring23_team2/stay_hist/stay_hist.csv")
members_pth <- paste0("~/ds7900_spring23_team2/members/members.csv")
##################################################################
email_hist_outpth <- paste0(fold_pth, "original_data/", "email_hist", ".csv")
stay_hist_outpth <- paste0(fold_pth, "original_data/", "stay_hist", ".csv")
members_outpth <- paste0(fold_pth, "original_data/", "members", ".csv")
##################################################################
dir.create(paste0(fold_pth, "original_data/"), showWarnings = FALSE)       # fold_pth -> temporal_subsets

####################################################################################
####################################################################################

read_csv(stay_hist_pth,
         col_types = c(HASH_NBR = "c",
                       CONF_HASH_NBR = "c",
                       CONF_DT = "D",
                       CK_IN_DT = "D",
                       CK_OUT_DT = "D",
                       HTL_HASH_NBR = "c",
                       HTL_RGN = "c",
                       HTL_CTRY_NM = "c",
                       HTL_CITY_NM = "c",
                       HTL_CHAIN = "c",
                       HTL_CHAIN_CATEGORY = "c",
                       BUS_LEIS_IND = "c",
                       REWARD_NT = "c",
                       GUEST_QTY = "c",
                       NBR_OF_NIGHTS = "c",
                       ROOM_REVENUE_USD = "c")) %>%
                unique() %>%
                filter(HASH_NBR != "HASH_NBR") %>%
                mutate(
                       CONF_timepoint = as.numeric((lubridate::dyears(lubridate::year(CONF_DT)) + lubridate::dmonths(lubridate::month(CONF_DT)) + lubridate::ddays(lubridate::day(CONF_DT))) / lubridate::dyears(1)),
                       centered_CONF_timepoint = CONF_timepoint - max(CONF_timepoint, na.rm = T),

                       CK_IN_timepoint = as.numeric((lubridate::dyears(lubridate::year(CK_IN_DT)) + lubridate::dmonths(lubridate::month(CK_IN_DT)) + lubridate::ddays(lubridate::day(CK_IN_DT))) / lubridate::dyears(1)),
                       centered_CK_IN_timepoint = CK_IN_timepoint - max(CK_IN_timepoint, na.rm = T),

                       CK_OUT_timepoint = as.numeric((lubridate::dyears(lubridate::year(CK_OUT_DT)) + lubridate::dmonths(lubridate::month(CK_OUT_DT)) + lubridate::ddays(lubridate::day(CK_OUT_DT))) / lubridate::dyears(1)),
                       centered_CK_OUT_timepoint = CK_OUT_timepoint - max(CK_OUT_timepoint, na.rm = T),

                       CK_INOUT_timepoint_diff = CK_OUT_timepoint - CK_IN_timepoint
                      ) %>%
                write_csv(stay_hist_outpth)

####################################################################################
####################################################################################

read_csv(email_hist_pth,
         col_types = c(HASH_NBR = "c",
                       CAMPAIGN_NBR = "c",
                       CLICK = "c",
                       SEND_DT = "D",
                       MBR_TIER = "c",
                       MBR_PRGM_ACTV = "c",
                       CAMPAIGN_NM = "c",
                       UNSUB_IND = "c")) %>%
    unique() %>%
    filter(HASH_NBR != "HASH_NBR") %>%
    mutate(yr = lubridate::year(SEND_DT),
           mnth = lubridate::month(SEND_DT),
           dy = lubridate::day(SEND_DT),
           SEND_DT_timepoint = as.numeric((lubridate::dyears(yr) + lubridate::dmonths(mnth) + lubridate::ddays(lubridate::day(SEND_DT))) / lubridate::dyears(1)),
           centered_SEND_DT_timepoint = SEND_DT_timepoint - max(SEND_DT_timepoint, na.rm = T),
           gr_ind = case_when(yr == "2020" ~ 1, TRUE ~ mnth)) %>%
    write_csv(email_hist_outpth)

####################################################################################
####################################################################################

read_csv(members_pth,
         col_types = c(HASH_NBR = "c",
                       ENROLL_DT = "D",
                       ENROLL_CHANNEL = "c",
                       MBR_REGION = "c",
                       MBR_SUBREGION = "c",
                       STATE_NM = "c",
                       CITY_NM = "c",
                       AGE_CD = "c",
                       INCOME_CD = "c",
                       GENDER_CD = "c",
                       INCOME_GROUP = "c")) %>%
    unique() %>%
    filter(HASH_NBR != "HASH_NBR") %>%
    mutate(ENROLL_timepoint = as.numeric((lubridate::dyears(lubridate::year(ENROLL_DT)) + lubridate::dmonths(lubridate::month(ENROLL_DT)) + lubridate::ddays(lubridate::day(ENROLL_DT))) / lubridate::dyears(1)),
           centered_ENROLL_timepoint = ENROLL_timepoint - 1983) %>%
    write_csv(members_outpth)

####################################################################################
####################################################################################
