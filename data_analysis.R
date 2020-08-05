# created on June 24, 2020
#--------------------------------------------------------------------------------
# load package
library(magrittr)

#--------------------------------------------------------------------------------
#3.	Data analysis exercise

# enter directory and name of input file
fdir = '/Users/michaeltang/Downloads/ds_project'
inputfname = 'Question2sample.csv'
inputfpath = file.path(fdir, inputfname)

# assign data frame with data from input file, skip the first two rows
inputdata <- read.csv(inputfpath, skip = 2)

# select data under topic of "family characteristics", 
# then use subset to get data in provinces in the Atlantic region,
# get columns interested (i.e. prov., charac., and total)
# assign trimmed data frame to lfamtable 
lfamtable <- inputdata %>% .[.$"Topic" == "Family characteristics", ] %>%
                subset(., .$"Prov_Name" %in% c("New Brunswick", "Nova Scotia", 
                        "Prince Edward Island", "Newfoundland and Labrador")) %>%
                          .[, names(.) %in% c("Prov_Name", "Characteristic", "Total")] 

# before transforming lfamtable to wide format, 
# get the number of rows for each province, call it len_ent
len_ent = length(lfamtable[lfamtable$"Prov_Name" == "Newfoundland and Labrador", 
                           "Prov_Name"])

# create a list that goes from 1 to the end of list len_ent
list_ent = 1:len_ent

# as there are 4 provinces interested, replicate the list 4 times
# to generate a set of Ids for rows in each province
id = rep(list_ent, times = 4)

# assign id to lfamtable (long format family table)
# with unique id assigned to each row in each prov.,
# specific data in each row can be obtained conveniently, 
# and duplicate rows under column "Characteristic" would not be omitted when 
# transforming data frame from long to wide format
lfamtable$"Id" <- id

# use reshape() to transform lfamtable to wide format
wfamtable <- reshape(lfamtable, idvar = c("Id", "Characteristic"), timevar = "Prov_Name", 
                    v.names = "Total", direction = "wide")

# task 1: get percentage of couple families (married + common-law) 
# having children at home in the Atlantic region, 

#and in diff. prov., with which percent of common-law couple

# using the unique id for each row, and the columns interested,
# get sum of number of married couples with children at home (id = 10)
# get sum of number of common-law couples with children at home (id = 16)
# get number of couple families having children at home 
numCouFamChildHome = sum(wfamtable[10, 3:6]) + sum(wfamtable[16, 3:6])

# get total number of couple families (id = 6)	
totalNumFCouFam = sum(wfamtable[7, 3:6])

# get percentage of couple families having children living at home
perCouFamChildHome = (numCouFamChildHome/totalNumFCouFam)*100

# print messages to console
msg1str = sprintf("Percentage of coup. fam. having child. at home. = %.2f", perCouFamChildHome)
print("Task 1:")
print(msg1str)

# task 2: dist. of size of census families in the Atlantic region
# get total number of 2-person census family (id = 2)
# do the same for 3-,4-, and 5 person census family (id = 3, 4, 5)
# get total nunber of census families (id =1)
cenFam2p = sum(wfamtable[2, 3:6])
cenFam3p = sum(wfamtable[3, 3:6])
cenFam4p = sum(wfamtable[4, 3:6])
cenFam5p = sum(wfamtable[5, 3:6])
totalNumCenFam = sum(wfamtable[1, 3:6])

# get percentage of families having 2 persons in their household, 
# do the same for families of other sizes
perCenFam2p = cenFam2p/totalNumCenFam*100
perCenFam3p = cenFam3p/totalNumCenFam*100
perCenFam4p = cenFam4p/totalNumCenFam*100
perCenFam5p = cenFam5p/totalNumCenFam*100

# print messages to console
msg2str1 = sprintf("Percentage of 2-person families. = %.2f", perCenFam2p)
msg2str2 = sprintf("Percentage of 3-person families. = %.2f", perCenFam3p)
msg2str3 = sprintf("Percentage of 4-person families. = %.2f", perCenFam4p)
msg2str4 = sprintf("Percentage of 5-person families. = %.2f", perCenFam5p)

print("Task 2:")
print(msg2str1)
print(msg2str2)
print(msg2str3)
print(msg2str4)

# task 3: get percentage of lone-parent families in total and 
# then with female parent (mother-child family)
# get sum of total lone-parent families (id = 20)
# get sum of total number of census families (id = 6)
# get percentage by using the two mentioned sums
numLoneParFam = sum(wfamtable[20, 3:6])
totalNumCenFam = sum(wfamtable[6, 3:6])
perLoneParFam = numLoneParFam/totalNumCenFam*100

# get sum of number of lone-mother families (id = 21),
# then use it to get percentage by lone-mother families among lone-parent families
numLoneMomFam = sum(wfamtable[21, 3:6])
perLoneMomFam = numLoneMomFam/numLoneParFam*100

# print messages to console
msg3str1 = sprintf("Percentage of lone-parent fam. = %.2f", perLoneParFam)
msg3str2 = sprintf("Percentage of mother-parent fam. among them = %.2f", perLoneMomFam)

print("Task 3:")
print(msg3str1)
print(msg3str2)

# task 4: get percent of common-law couples in total census families, how many of 
# have children at home

# get total number of common-law couples (id = 14)
# get percentage of common-law couple among total num. of couple families
totalNumComLawCou = sum(wfamtable[14, 3:6])
perComLawCou = totalNumComLawCou/totalNumFCouFam*100

# get sum of num. of common-law couple having children at home (id = 16)
# get percentage of common-law couple having children at home
totalNumConLawCouChildHome = sum(wfamtable[16, 3:6])
perComLawCouChildHome = totalNumConLawCouChildHome/totalNumComLawCou*100

# print messages to console
msg4str1 = sprintf("Percentage of common-law couple families. = %.2f", perComLawCou)
msg4str2 = sprintf("Percentage of common-law couple fam. having children at home = %.2f", perComLawCouChildHome)

print("Task 4:")
print(msg4str1)
print(msg4str2)

# task 5: get percent of children under 18 in census families
# get total number of children under 18 (id = 30, 31, 32)
# get total number of children (id = 29)
# get the required percentage
totalNumChildUnder18 = sum(wfamtable[30:32, 3:6])
totalNumChild = sum(wfamtable[29, 3:6])
perNumChildUnder18 = totalNumChildUnder18/totalNumChild*100

# print messages to console
msg5str = sprintf("Percentage of children under 18. = %.2f", perNumChildUnder18)

print("Task 5:")
print(msg5str)
  
# task 6: get avg. num. of persons per census family and private household 
# in the Atlantic region

# repeat the above steps to get a table showing household characteristics
lhousetable <- inputdata %>% .[.$"Topic" == "Household and dwelling characteristics", ] %>%
  subset(., .$"Prov_Name" %in% c("New Brunswick", "Nova Scotia", 
                                 "Prince Edward Island", "Newfoundland and Labrador")) %>%
  .[, names(.) %in% c("Prov_Name", "Characteristic", "Total")] 


# get number of rows for each province under house categ.,  call it len_ent_house
# create a list that goes from 1 to the end of list len_ent_house
# replicate the id 4 times for 4 different provinces
# assign unique id to lhousetable
len_ent_house = length(lhousetable[lhousetable$"Prov_Name" == "Newfoundland and Labrador", 
                           "Prov_Name"])
list_ent_house = 1:len_ent_house
id_house = rep(list_ent_house, times = 4)
lhousetable$"Id" <- id_house

# use reshape() to transform lhousetable to wide format
whousetable <- reshape(lhousetable, idvar = c("Id", "Characteristic"), timevar = "Prov_Name", 
                       v.names = "Total", direction = "wide")

# get total number of persons in households (id = 48)
# get total number of households (id = 41)
totalNumPerHouse = sum(whousetable[48, 3:6])
totalNumHouse = sum(whousetable[41, 3:6])

# get average number of persons per household
avgNumPerHouse = totalNumPerHouse/totalNumHouse

# print messages to console
msg6str = sprintf("Avg. num. of persons per household = %.2f", avgNumPerHouse)

print("Task 6:")
print(msg6str)

