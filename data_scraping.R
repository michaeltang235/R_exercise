#--------------------------------------------------------------------------------
# load packages
library(XML)
library(RCurl)
library(magrittr)

#--------------------------------------------------------------------------------
# 1. Data scraping exercise
# a) import data

# enter URL given 
url <- "https://en.wikipedia.org/wiki/Opinion_polling_in_the_Canadian_federal_election,_2015"

# get data from url
urldata <- getURL(url)

# read data from campaign period polls, i.e. the first table on the website
# then do the same for pre-campiagn period polls
# set header = TRUE when table has the appropriate column names
data_camp <- readHTMLTable(urldata, header = TRUE, which = 1)
data_precamp <- readHTMLTable(urldata, header = TRUE, which = 2)

# since the two data frames have the same column names, use rbind to
# concatenate them vertically 
data_table <- rbind(data_precamp, data_camp)

# b) cleaning data

# (i) remove rows on elections 2011 and 2015
# (ii) remove empty rows
# direct resulted data frame to output table named optable
optable <- data_table %>% 
            subset(., .$"Polling firm" != "Election") %>%
            subset(., .$"Polling firm" != "") 

# (iii) transform the last date of polling data to a numeric date format 
# of year-month-day, as.Date default format is yyyy-mm-dd
optable$"Last dateof polling\n" <-
  as.Date(optable$"Last dateof polling\n", format = "%B %d, %Y")

# (iv) keep only polls from 2014 and after
optable <- subset(optable, optable$"Last dateof polling\n" >= "2014-01-01")

# (v) transform the margin of error data format to be simply numeric characters
# grepl("^[^0-9]+$", .) searches for strings containing numbers only, 
# ifelse(grepl("^[^0-9]+$", .), "", .), if not found, replace with ""
optable$"Marginof error[1]" <- 
  gsub(" pp", "", optable$"Marginof error[1]") %>%   # replace all " pp" strings with ""
  gsub("±", "", .) %>%   # replace all "±" with ""
  ifelse(grepl("^[^0-9]+$", .), "", .) %>%   # replace "n.a", "NA", or any non-numeric entries, with ""
  gsub("NA", "", .) %>% as.numeric(.)   # convert char strings to numeric type

# (vi) transform the 5 major federal parties data to be on a scale of 0-1, 
# meaning a 38.1% results should become a 0.381
optable[, c("Cons.\n", "NDP\n", "Liberal\n", "BQ\n", "Green\n")] <- 
  lapply(optable[ , c("Cons.\n", "NDP\n", "Liberal\n", "BQ\n", "Green\n")],
         function(x) {as.numeric(x)/100}) 

# (vii) remove the columns ‘Lead’ and ‘Link’
optable <- optable[, !(names(optable) %in% c("Lead\n", "Link\n"))]

# (viii) rename your columns to firm, lastDateOfPolling, lpc, cpc, ndp, bq, green, 
# MOE, sampleSize and method.
colnames(optable)[colnames(optable) == "Polling firm\n"] = "firm"
colnames(optable)[colnames(optable) == "Last dateof polling\n"] = "lastDateOfPolling"
colnames(optable)[colnames(optable) == "Liberal\n"] = "lpc"
colnames(optable)[colnames(optable) == "Cons.\n"] = "cpc"
colnames(optable)[colnames(optable) == "NDP\n"] = "ndp"
colnames(optable)[colnames(optable) == "BQ\n"] = "bq"
colnames(optable)[colnames(optable) == "Green\n"] = "green"
colnames(optable)[colnames(optable) == "Marginof error[1]"] = "MOE"
colnames(optable)[colnames(optable) == "Samplesize[2]"] = "sampleSize"
colnames(optable)[colnames(optable) == "Polling method[3]"] = "method"

# (ix) reorder your data by last date of polling, from the oldest to most recent polls.
# default option of order() is ascending, i.e. from the oldest to the most recent dates
optable <- optable[order(optable$"lastDateOfPolling"), ]

# (v) write a csv named ‘e2015polls’ 
filedir = '/Users/michaeltang/Downloads/ds_project'
filename = 'e2015polls.csv'
filepath = file.path(filedir, filename)

#write.csv(optable, filepath, row.names=FALSE)


#--------------------------------------------------------------------------------
# ref:
# using readHTMLTable
# https://www.rdocumentation.org/packages/XML/versions/3.99-0.3/topics/readHTMLTable

# using rbind
# https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/cbind
