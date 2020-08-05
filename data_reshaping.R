#--------------------------------------------------------------------------------
# load package
library(magrittr)

#--------------------------------------------------------------------------------
#2. Data re-shaping exercise

# enter directory and name of input file
fdir = '/Users/michaeltang/Downloads/ds_project'
inputfname = 'Question2sample.csv'
inputfpath = file.path(fdir, inputfname)

# assign data frame with data from input file, skip the first two rows
inputdata <- read.csv(inputfpath, skip = 2)

# as we are interested in total population by age groups in different Canadian 
# provinces and territories, do the following to achieve the data frame with relevant
# entries of data 
# (i) select "Age characteristics" under the "topic" column,
# (ii) select the columns named "Prov_name", "Charcter.", "Total" only
# (iii) remove rows of 15, 16, 17, 18, and 19 years under the "Charac." column
#       because we already have age group of 15 - 19 years old
# (iv) assign resultant data frame to ltable
ltable <- inputdata %>% .[.$"Topic" == "Age characteristics", ] %>%
              .[, names(.) %in% c("Prov_Name", "Characteristic", "Total")] %>%
                  subset(., !(.$"Characteristic" %in% c("      15 years", "      16 years", 
                                              "      17 years", "      18 years", 
                                              "      19 years")))

# we have obtained a table listing all necessary info. in long format, 
# use reshape() function to transform the table to wide format
# assign result to wtable
wtable <- reshape(ltable, idvar = "Characteristic", timevar = "Prov_Name", 
                  v.names = "Total", direction = "wide")

# by inspecting column names of wtable, "Total." is found on the majority of
# the columns
# use grepl to search for the pattern ("Total."), if found, 
# use gsub to replace it with "", which gives us the proper names of the columns
for (i in 1:length(colnames(wtable))){
  if (grepl("Total.", colnames(wtable)[i])){
    colnames(wtable)[i] = gsub("Total.", "", colnames(wtable)[i])
  }
}

# change name of "Characteristic" column to "Age groups"
colnames(wtable)[colnames(wtable) == "Characteristic"] = "Age groups"


# write a csv named ‘census2011ageByProv’
filedir = '/Users/michaeltang/Downloads/ds_project'
filename = 'census2011ageByProv.csv'
filepath = file.path(filedir, filename)

write.csv(wtable, filepath)

#--------------------------------------------------------------------------------
#ref:
# more on reshape()
# http://www.datasciencemadesimple.com/reshape-in-r-from-wide-to-long-from-long-to-wide/
# https://stats.idre.ucla.edu/r/faq/how-can-i-reshape-my-data-in-r/
# https://www.rdocumentation.org/packages/stats/versions/3.6.2/topics/reshape
