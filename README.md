# R_exericse
This exercise uses R to scrape internet data and process them into tables that are convenient for further analysis. There are 4 sections presented, namely **(1) Data scraping and cleaning**, **(2) Data re-shaping**, **(3) Data analysis**, and **(4) Analysis report**. The last 2 sections look at the characteristics and composition of families and households in the Atlantic region using 2011 Census data provided by Statistics Canada. Details of each section is given below.

**(1) Data scraping and cleaning** is subdivided into (1a) and (1b),<br />

(*1a*): importing data,  <br />
- extract national polls' info from 2011 election to 2015 election from this url: https://en.wikipedia.org/wiki/Opinion_polling_in_the_Canadian_federal_election,_2015
- not all data are interested, the final resulting table should only include information under polling firm, last date of polling, margin of error, sample size, polling method, and the results of the five major federal parties for 364 polls <br />

(1b): cleaning data,  <br />
- remove unnecesssary rows (including empty and unwanted data),
- transform the last date of polling data to numeric date format of year-month-day
- only include polls from 2014 onwards
- transform data format of the margin of error to numeric characters
- transform the 5 major federal parties data from percentage to decimal scale
- remove unnecessary columns
- rename columns 
- order data by the last date of polling, from the oldest to the most recent
- store final table in .csv file named 'e2015polls'  <br />

Further details related to section **(1)** can be found in the file 'data_scraping.R'  <br/>

**(2) Data re-shaping**, <br/>
- download data published by Statistics Canada, 
- use magrittr syntax to trim the table downloaded to include only data interested
- transform data from long to wide format
- rename columns 
- save transformed table in .csv file named 'census2011ageByProv'<br/>

Further detials related to section **(2)** can be found in the file 'data-reshaping.R'<br/>

**(3) Data analysis**,<br/>
- as we are interested in family characteristics in the Atlantic region, 
- use the same url listed in section **(2)**, select relevant rows (i.e. "family charactertics" under column "topic", and each of the Atlantic provinces under "Prov_Name"
- then transfomed the table from long to wide format, with columns of "characteristic" and each Atlantic province
- a table in wide format is obtained, with each row showing a particular family characterisitc (e.g. size of census family: 2 persons, number of married couples with children at home, etc.), and columns showing the relevant counts in each of the Atlantic provinces
- assign a unique id to each row, so a specific characteristic across all provinces interested can be obtained conveniently
- do the following analyses with the wide-format table: 
- task 1: get percentage of couple families (married + common-law) having children at home in the Atlantic region,
- task 2: get percentage of families having 2 persons in their household, then repeat the steps for families of other sizes
- task 3: get percentage of lone-parent families in total and how many of them were female parent (mother-parent families)
- task 4: get percent of common-law couples in total census families and how many of them have children at home
- task 5: get percent of children under 18 in census families
- task 6: get avg. num. of persons per private household in the Atlantic region<br/>

Further detials related to section **(3)** can be found in the file 'data-analysis.R'<br/>

**(4) Data reporting**,<br/>
- use a R Markdown document and write a short summary of the results of analysis conducted in section **(3)**, highlighting key points that are important regarding the family characteristics in the Atlantic region. Also, share the code with others in the document.

