# This is a Documentation of the cleaning process of the dataset that we 
# are gonna use later on for our analysis. It is set up in 5 parts:

# 1.1 Setting up the work-environment:
# Let's start by installing first and then loading the necessary libraries,
# that will aid our analysis.


install.packages("tidyverse")
install.packages("lubridate")
install.packages("dplyr")
install.packages("ggplot2")
install.packages("tidyr")
install.packages("here")
install.packages("skimr")
install.packages("janitor")

# 1.2 Loading the packages:

library(tidyverse)
library(lubridate)
library(dplyr)
library(ggplot2)
library(tidyr)
library(here)
library(skimr)
library(janitor)

# 2. Importing the Dataset
# Now, I am going to import the .csv files that I 'll work with:

daily_activity <- read.csv("Bellabeat/mturkfitbit_export_4.12.16-5.12.16/Fitabase Data 4.12.16-5.12.16/dailyActivity_merged.csv")
daily_steps <- read.csv("Bellabeat/mturkfitbit_export_4.12.16-5.12.16/Fitabase Data 4.12.16-5.12.16/dailySteps_merged.csv")
daily_calories <- read.csv("Bellabeat/mturkfitbit_export_4.12.16-5.12.16/Fitabase Data 4.12.16-5.12.16/dailyCalories_merged.csv")
daily_sleep <- read.csv("Bellabeat/mturkfitbit_export_4.12.16-5.12.16/Fitabase Data 4.12.16-5.12.16/sleepDay_merged.csv")
hourly_steps <- read.csv("Bellabeat/mturkfitbit_export_4.12.16-5.12.16/Fitabase Data 4.12.16-5.12.16/hourlySteps_merged.csv")
hourly_calories <- read.csv("Bellabeat/mturkfitbit_export_4.12.16-5.12.16/Fitabase Data 4.12.16-5.12.16/hourlyCalories_merged.csv")
hourly_intensities <- read.csv("Bellabeat/mturkfitbit_export_4.12.16-5.12.16/Fitabase Data 4.12.16-5.12.16/hourlyIntensities_merged.csv")
weight <- read.csv("Bellabeat/mturkfitbit_export_4.12.16-5.12.16/Fitabase Data 4.12.16-5.12.16/weightLogInfo_merged.csv")

# 3. Previewing and Checking
# 3.1 Previewing the Data

head(daily_activity)
head(daily_calories)
head(daily_sleep)
head(daily_steps)
head(hourly_calories)
head(hourly_intensities)
head(hourly_steps)
head(weight)

# 3.2 Checking the structure

str(daily_activity)
str(daily_calories)
str(daily_sleep)
str(daily_steps)
str(hourly_calories)
str(hourly_intensities)
str(hourly_steps)
str(weight)

# 3.3 Checking for repeated data
# I noticed that there are already Calories- and Steps-data in the dataset
# daily_activity contained. To check if it's so, I am going to use the 
# “which”-function. 

which(daily_activity$TotalSteps!=daily_steps$StepTotal)
which(daily_activity$Calories!=daily_steps$Calories)

# It turned out, that they are already contained, so I will drop the daily_steps
# and daily_calories from my analysis to avoid double and repeated data.


# 3.4 Checking the number of participants for each data set

n_unique(daily_activity$Id)
n_unique(daily_calories$Id)
n_unique(daily_sleep$Id)
n_unique(daily_steps$Id)
n_unique(hourly_calories$Id)
n_unique(hourly_intensities$Id)
n_unique(hourly_steps$Id)
n_unique(weight$Id)

# All data sets have 33 except for sleep data (24) and weight data (8). I will
# exclude the weight data frame from the analysis since it has too little
# participants, compared to the other data frames and to avoid biases.  

# 4.1 Checking for duplicates

sum(duplicated(daily_activity))
sum(duplicated(daily_calories))
sum(duplicated(daily_sleep))
sum(duplicated(daily_steps))
sum(duplicated(hourly_calories))
sum(duplicated(hourly_intensities))
sum(duplicated(hourly_steps))

# There were 3 duplicates in daily_sleep found.

# 4.2 Checking for missing values

sum(is.na(daily_activity))
sum(is.na(daily_calories))
sum(is.na(daily_sleep))
sum(is.na(daily_steps))
sum(is.na(hourly_calories))
sum(is.na(hourly_intensities))
sum(is.na(hourly_steps))

# There are no missing values

# 4.3 Removing duplicates:
# I am going to remove the 3 duplicates that I found before in daily_sleep 

daily_sleep <- daily_sleep %>% distinct()

# 4.4 Clean and rename columns
# Let´s standardize the column names in each data frame to ensure consistency 
# (right syntax and same format) and ease of analysis. This will help us to 
# merge the datasets later on. The “clean_names” function will convert all
# column names to lowercase and will replace spaces, dots, or special 
# characters with underscores (_). 

daily_activity <- clean_names(daily_activity)
daily_calories <- clean_names(daily_calories)
daily_sleep <- clean_names(daily_sleep)
daily_steps <- clean_names(daily_steps)
hourly_calories <- clean_names(hourly_calories)
hourly_intensities <- clean_names(hourly_intensities)
hourly_steps <- clean_names(hourly_steps)

# 4.5 Format date and time columns
# It’s also necessary to clean the date-time format in the datasets before we
# merge them. The date-columns of the daily_activity, daily_calories and
# daily_steps datasets are in text format (chr) and have to be convert to date.
# I am also going to rename the columns from activitydate and activityday to 
# date. For the daily_sleep, hourly_calories, hourly_steps and 
# hourly_intensities datasets, since the contain also time-data, we have to 
# convert the date-column (activityhour) from chr to dttm (date-time) and we 
# will rename it to date_time. 

daily_activity <- daily_activity %>%
  rename(date=activitydate) %>%
  mutate(date=as_date(date, format="%m/%d/%Y"))
daily_calories <- daily_calories %>%
  rename(date=activityday) %>%
  mutate(date=as_date(date, format="%m/%d/%Y"))
daily_steps <- daily_steps %>%
  rename(date=activityday) %>%
  mutate(date=as_date(date, format="%m/%d/%Y"))
daily_sleep <- daily_sleep %>%
  rename(date=sleepday) %>%
  mutate(date=as_date(date, format="%m/%d/%Y %I:%M:%S %p", tz=Sys.timezone()))
hourly_calories <- hourly_calories %>%
  rename(date_time=activityhour) %>%
  mutate(date_time=as.POSIXct(date_time, format="%m/%d/%Y %I:%M:%S %p", tz=Sys.timezone()))
hourly_intensities <- hourly_intensities %>%
  rename(date_time=activityhour) %>%
  mutate(date_time=as.POSIXct(date_time, format="%m/%d/%Y %I:%M:%S %p", tz=Sys.timezone()))
hourly_steps <- hourly_steps %>%
  rename(date_time=activityhour) %>%
  mutate(date_time=as.POSIXct(date_time, format="%m/%d/%Y %I:%M:%S %p", tz=Sys.timezone()))

# 5. Merging datasets
# Finaly, we are putting all the daily_data and hourly_data together.

daily_data <- merge(daily_activity,daily_sleep, by=c("id","date"))

hourly_data <- merge(hourly_intensities,hourly_calories, by=c("id", "date_time")) %>%
  merge(hourly_steps, by=c("id","date_time"))
