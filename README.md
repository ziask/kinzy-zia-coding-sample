 # Update of Figure 1.5: College completion and enrollment by age (Turner 2004)

The Stata file, [`Turner2004-Update.do`](Turner2004-Update.do), creates graphs displaying enrollment and completion by age. It is an updated version of Fig. 1.5 in [Turner (2004)](https://www.nber.org/system/files/chapters/c10097/c10097.pdf). It uses data from the October CPS. Two levels of educational attainment are distinguished: Some college or currently enrolled, and Bachelors degree, or four years of college. The do-file creates graphs that track the fraction of the birth cohort with some college, or a BA degree, by age over birth cohorts. The following graphs are produced: 
- Some College or Currently Enrolled age 23, 25, 28, and 30
- Some College or Currently Enrolled age *19* 23, 25, 28, and 30 
- BA Degree, or four years of college by 23, 25, 28, and 30 
- Women: Some College or Currently Enrolled age 23, 25, 28, and 30
- Men: Some College or Currently Enrolled age 23, 25, 28, and 30
- Women: BA Degree, or four years of college by 23, 25, 28, and 30
- Men: BA Degree, or four years of college by 23, 25, 28, and 30

Note: The do-file is set up to run from a main folder (in this case labeled as my home directiory /Descriptive Project/Turner 2004 Update), and has three subfolders: Data, Do-Files, and Outputs. The file uses Data from the data folder, and outputs in the Outputs folder. 

## Detailed Information about the Graphs
Data Source: Community Population Survey (CPS) downleded from [IPUMS CPS.](https://cps.ipums.org/cps/index.shtml) The October sample is used for all years (1976-2023).

*Some college, or currently enrolled*: Defined as a having attended some college, or being enrolled in school at the time of the sample. For some college in the 1976-91 samples, we used the highest grade attended (higraded). They are coded as having some college if they didn't finish first year of college. In the 1992-2023 samples, we used educational attainment (educ99). They are coded as having some college if they have at least some college, no degree. For currently enrolled in the 1976-2022 samples, we used the highest grade attempted and whether they were currently enrolled in school (edatt). For the 2023 samples, educational attainment, and school or college attendance (schlcoll); however, **this is only avaiable for persons 16-24** .

*College/Bachelor's Degree*: Defined as a person having a college degree (i.e., a bachelor’s degree) at age 25. For 1976-1991, we used a person’s highest grade (higraded). A person is coded as having a college degree if their highest grade is greater than or equal to their 4th year of college. For 1992-2023, we use a person’s educational attainment (educ99). A person is coded as having a college degree if they have completed a bachelor’s degree or more.

*Gender*: Used the CPS measure of gender, unchanged.

*Weights*: Estimates of the proportion of each birth cohort with some college, college, or graduate degrees use Census weights. Final basic weight weights were used for all years.
