*******************************************************************************
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Setup ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*******************************************************************************

*Set global directory
global directory "/Users/ziakinzy/Desktop/Application Materials/Turner 2004 Update"

* Load data
use "$directory/Data/turner2004-05", clear

*******************************************************************************
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Clean Data ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*******************************************************************************

*Restrict sample 
	* Keeping only ages needed
		keep if age == 19 | age == 23 | age == 25 | age == 28 | age == 30

*Generate variables
	* Create birth year variable
		gen birth_year = year - age

	* Rename weights for consistancy
		rename wtfinl wt

	* Creating dummy for some college
		gen some_college = .

		* 1976-1991: Has "some college" or is enrolled in college
			
			* 1. Highest grade of school attended includes college
				replace some_college = 0 if higrade > 0 & higrade <= 150 & ///
					year >= 1976 & year <= 1991 
					/* 12th grade or less, treat NIU (0) as missing */
				replace some_college = 1 if higrade >= 151 & higrade < 999 & ///
					year >= 1976 & year <= 1991
					/* Some 1st year college, didn't finish - Finished 6+ years college; 
						treat missing as missing */
	
			* 2. Enrolled in college+ now
				replace some_college = 1 if higrade >= 150 & edatt == 1 & year ///
					>= 1976 & year <= 2022 /* 1976-2022: finished 12th grade, attending 
						college, university, etc in the current term */
						
		* 1992 - 2023: Has "some college" or is enrolled in college
			* 1. "Some college"
				replace some_college = 0 if educ99 > 0 & educ99 <= 10 & year >= 1992
					// niu (0) as missing, has no more than High school graduate, or GED
				replace some_college = 1 if educ99 >= 11 & year >= 1992 
					// Has at least Some college, no degree 
					
			* 2. Enrolled in college+ now
				replace some_college = 1 if educ99 >= 10 & (schlcoll == 4 | schlcoll == 3)  ///
				& year > 1989 
					/* some college if attained greater that hs or ged and currently 
					enrolled full or part time */
		
		 *Check the summary statistics by age
			tabstat some_college if age==19 [aw=wt], s(mean) by(birth_year) 
			tabstat some_college if age==23 [aw=wt], s(mean) by(birth_year)
			tabstat some_college if age==25 [aw=wt], s(mean) by(birth_year)
			tabstat some_college if age==28 [aw=wt], s(mean) by(birth_year)
			tabstat some_college if age==30 [aw=wt], s(mean) by(birth_year)
			
	* Creating dummy for college
		gen college = .

		* 1962-1991: 
			replace college = 0 if higrade > 0 & higrade <= 181 & year >= 1962 & year ///
				<= 1991 
				// attending 4th year of college or less, n/a (0) as missing
			replace college = 1 if higrade >= 190 & higrade < 999 & ///
				year >= 1962 & year <= 1991
				// 4th year of college or more
				
		* 1992-2023: Has completed a BA or higher
			replace college = 0 if educ99> 0 & educ99 < 15 & year >= 1992
				// n/a as missing
			replace college = 1 if educ99 >= 15  & year >= 1992
		 
		 *Check
			tabstat college if age==23 [aw=wt], s(mean) by(birth_year)
			tabstat college if age==25 [aw=wt], s(mean) by(birth_year)
			tabstat college if age==28 [aw=wt], s(mean) by(birth_year)
			tabstat college if age==30 [aw=wt], s(mean) by(birth_year)
	*Save clean data
		save "$directory/Data/turner2004-05-clean", replace

*******************************************************************************
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Create Graphs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*******************************************************************************

*Open clean data
	use "$directory/Data/turner2004-05-clean", clear

*************** Create Graphs Whole Population ***************
	*preserve data, so can collapse by gender later
	preserve

	* Obtaining estimates by birth cohort
	collapse (mean) some_college (mean) college ///
		 [pw=wt], by(birth_year age)
		
	* Sort
	sort age birth_year

		*Making lables, if wanted; not used in final versions of graph
			/*
			drop some_college_str
			drop college_str
			drop some_college_str_25 

			* Creating marker labels (hiding all ACS labels but first and last)
			foreach v of varlist some_college college  {
				gen `v'_str =  string(`v', "%8.2f")
			}
			gen some_college_str_25 = some_college_str
			replace some_college_str = "" if age == 19 & birth_year > 1987 & birth_year < ///
				2003 
			replace college_str = "" if age == 25 & birth_year > 1981 & birth_year < 1997  ///  

			replace some_college_str_25 = "" if age == 25 & birth_year > 1981 & birth_year < 1997 ///

			*/
	*** Some College, or currently enrolled graphs ***
		*Some College, or Currently Enrolled at Age 23, 25, 28, and 30 Over Time 
			graph twoway ///
				(connected some_college birth_year if age == 23, ///
					lcolor(dkorange) msymbol(i)) ///
				(connected some_college birth_year if age == 25, ///
					lcolor(navy) ///
					msymbol(i) mcolor(navy) ) ///    
				(connected some_college birth_year if age == 28, ///
					lcolor(forest_green) msymbol(i) ) ///
				(connected some_college birth_year if age == 30, ///
					lcolor(ebg) msymbol(i) mcolor(ebg)), ///
				ti("Some College, or Currently Enrolled By Age" " ", pos(11) color(black) size(small)) ///
				legend(order( ///
					1 "Age 23" ///
					2 "Age 25" ///
					3 "Age 28" ///
					4 "Age 30")  pos(11) ring(0) col(1) ///
					region(lcolor(white)) size(small)) ///
				yti("Fraction of Birth Cohort with Some College or Currently Enrolled", size(small)) ///
				ysc(range(0.45 0.75)) ylab(0.45(0.10)0.75, angle(0) ///
					format(%9.2f) labsize(small)) ///
				xti(" " "Year of Birth", size(small)) xsc(range(1940 2005)) xlab(1940(5)2000, ///
					labsize(small)) ///
				graphregion(color(white)) name(SomeCollegeByAge, replace)

			graph export  "$directory\Outputs\SomeCollege-23-30.png", replace	

	*Some College, or Currently Enrolled at Age *19* 23, 25, 28, and 30 Over Time 
		graph twoway ///
			(connected some_college birth_year if age == 19, ///
				lcolor(pink) msymbol(i) ) ///
			(connected some_college birth_year if age == 23, ///
				lcolor(dkorange) msymbol(i)) ///
			(connected some_college birth_year if age == 25, ///
				lcolor(navy) ///
				msymbol(i) mcolor(navy) ) ///    
			(connected some_college birth_year if age == 28, ///
				lcolor(forest_green) msymbol(i) ) ///
			(connected some_college birth_year if age == 30, ///
				lcolor(ebg) msymbol(i) mcolor(ebg)), ///
			ti("Some College, or Currently Enrolled By Age" " ", pos(11) color(black) size(small)) ///
			legend(order(1 "Age 19" ///
				2 "Age 23" ///
				3 "Age 25" ///
				4 "Age 28" ///
				5 "Age 30")  pos(11) ring(0) col(1) ///
				region(lcolor(white)) size(small)) ///
			yti("Fraction of Birth Cohort with Some College or Currently Enrolled", ///
			size(small)) ysc(range(0.45 0.75)) ylab(0.45(0.10)0.75, angle(0) ///
				format(%9.2f) labsize(small)) ///
			xti(" " "Year of Birth", size(small)) xsc(range(1940 2005)) xlab(1940(5)2000, ///
				labsize(small)) ///
			graphregion(color(white)) name(SomeCollegeByAge, replace)

		graph export  "$directory\Outputs\SomeCollege-19-30.png", replace	
			
	
	*** BA Degree graphs ***
		*BA Degree at Age 23, 25, 28, and 30 over time
			graph twoway ///
				(connected college birth_year if age == 23, ///
					lcolor(dkorange) msymbol(i)) ///
				(connected college birth_year if age == 25, ///
					lcolor(navy) ///
					msymbol(i) mcolor(navy) ) ///    
				(connected college birth_year if age == 28, ///
					lcolor(forest_green) msymbol(i) ) ///
				(connected college birth_year if age == 30, ///
					lcolor(ebg) msymbol(i) mcolor(ebg)) ///
				, ///
				ti("College Completion by Age" " ", pos(11) color(black) size(small)) ///
				legend(order( ///
					1 "Age 23" ///
					2 "Age 25" ///
					3 "Age 28" ///
					4 "Age 30")  pos(11) ring(0) col(1) ///
					region(lcolor(white)) size(small)) ///
				yti("Fraction of Birth Cohort with a BA Degree", size(small)) ysc(range(0.15 0.45)) ylab(0.15(0.10)0.45, angle(0) ///
					format(%9.2f) labsize(small)) ///
				xti(" " "Year of Birth", size(small)) xsc(range(1940 2005)) xlab(1940(5)2000, ///
					labsize(small)) ///
				graphregion(color(white)) name(SomeCollegeByAge, replace)

			graph export  "$directory\Outputs\College-23-30.png", replace

	*restore data, so can collapse by gender next
		restore

*************** Create Graphs by Gender ***************

	* Obtaining estimates by birth cohort and gender
		collapse (mean) some_college (mean) college ///
			 [pw=wt], by(birth_year age sex)
			
	* Sort
	sort age birth_year sex

*** Some College, or currently enrolled graphs ***
	*Some College: Men 
		graph twoway ///
			(connected some_college birth_year if age == 23 & sex == 1, ///
				lcolor(dkorange) msymbol(i)) ///
			(connected some_college birth_year if age == 25 & sex == 1, ///
				lcolor(navy) ///
				msymbol(i) mcolor(navy) ) ///    
			(connected some_college birth_year if age == 28 & sex == 1, ///
				lcolor(forest_green) msymbol(i) ) ///
			(connected some_college birth_year if age == 30 & sex == 1, ///
				lcolor(ebg) msymbol(i) mcolor(ebg)), ///
			ti("Men: Some College, or Currently Enrolled By Age" " ", pos(11) color(black) size(small)) ///
			legend(order( ///
				1 "Age 23" ///
				2 "Age 25" ///
				3 "Age 28" ///
				4 "Age 30")  pos(11) ring(0) col(1) ///
				region(lcolor(white)) size(small)) ///
			yti("Fraction of Birth Cohort with Some College or Currently Enrolled", ///
			size(small)) ysc(range(0.45 0.75)) ylab(0.45(0.10)0.75, angle(0) ///
				format(%9.2f) labsize(small)) ///
			xti(" " "Year of Birth", size(small)) xsc(range(1940 2005)) xlab(1940(5)2000, ///
				labsize(small)) ///
			graphregion(color(white)) name(SomeCollegeByAge, replace)

		graph export  "$directory\Outputs\Men-SomeCollege-23-30.png", replace

	*Some College: Women 
		graph twoway ///
			(connected some_college birth_year if age == 23 & sex == 2, ///
				lcolor(dkorange) msymbol(i)) ///
			(connected some_college birth_year if age == 25 & sex == 2, ///
				lcolor(navy) ///
				msymbol(i) mcolor(navy) ) ///    
			(connected some_college birth_year if age == 28 & sex == 2, ///
				lcolor(forest_green) msymbol(i) ) ///
			(connected some_college birth_year if age == 30 & sex == 2, ///
				lcolor(ebg) msymbol(i) mcolor(ebg)), ///
			ti("Women: Some College, or Currently Enrolled By Age" " ", pos(11) color(black) size(small)) ///
			legend(order( ///
				1 "Age 23" ///
				2 "Age 25" ///
				3 "Age 28" ///
				4 "Age 30")  pos(11) ring(0) col(1) ///
				region(lcolor(white)) size(small)) ///
			yti("Fraction of Birth Cohort with Some College or Currently Enrolled", size(small)) ///
			ysc(range(0.45 0.75)) ylab(0.45(0.10)0.75, angle(0) ///
				format(%9.2f) labsize(small)) ///
			xti(" " "Year of Birth", size(small)) xsc(range(1940 2005)) xlab(1940(5)2000, ///
				labsize(small)) ///
			graphregion(color(white)) name(SomeCollegeByAge, replace)

		graph export  "$directory\Outputs\Women-SomeCollege-23-30.png", replace

*** BA Degree graphs ***
	*BA Degree: Men
		graph twoway ///
			(connected college birth_year if age == 23 & sex == 1, ///
				lcolor(dkorange) msymbol(i)) ///
			(connected college birth_year if age == 25 & sex == 1, ///
				lcolor(navy) ///
				msymbol(i) mcolor(navy) ) ///    
			(connected college birth_year if age == 28 & sex == 1, ///
				lcolor(forest_green) msymbol(i) ) ///
			(connected college birth_year if age == 30 & sex == 1, ///
				lcolor(ebg) msymbol(i) mcolor(ebg)) ///
			, ///
			ti("Men: College Completion by Age" " ", pos(11) color(black) size(small)) ///
			legend(order( ///
				1 "Age 23" ///
				2 "Age 25" ///
				3 "Age 28" ///
				4 "Age 30")  pos(11) ring(0) col(1) ///
				region(lcolor(white)) size(small)) ///
			yti("Fraction of Birth Cohort with a BA Degree", size(small)) ysc(range(0.15 0.55)) ylab(0.15(0.10)0.55, angle(0) ///
				format(%9.2f) labsize(small)) ///
			xti(" " "Year of Birth", size(small)) xsc(range(1940 2005)) xlab(1940(5)2000, ///
				labsize(small)) ///
			graphregion(color(white)) name(SomeCollegeByAge, replace)

		graph export  "$directory\Outputs\Men-College-23-30.png", replace


	*BA Degree: Women
		graph twoway ///
			(connected college birth_year if age == 23 & sex == 2, ///
				lcolor(dkorange) msymbol(i)) ///
			(connected college birth_year if age == 25 & sex == 2, ///
				lcolor(navy) ///
				msymbol(i) mcolor(navy) ) ///    
			(connected college birth_year if age == 28 & sex == 2, ///
				lcolor(forest_green) msymbol(i) ) ///
			(connected college birth_year if age == 30 & sex == 2, ///
				lcolor(ebg) msymbol(i) mcolor(ebg)) ///
			, ///
			ti("Women: College Completion by Age" " ", pos(11) color(black) size(small)) ///
			legend(order( ///
				1 "Age 23" ///
				2 "Age 25" ///
				3 "Age 28" ///
				4 "Age 30")  pos(11) ring(0) col(1) ///
				region(lcolor(white)) size(small)) ///
			yti("Fraction of Birth Cohort with a BA Degree", size(small)) ysc(range(0.15 0.55)) ylab(0.15(0.10)0.55, angle(0) ///
				format(%9.2f) labsize(small)) ///
			xti(" " "Year of Birth", size(small)) xsc(range(1940 2005)) xlab(1940(5)2000, ///
				labsize(small)) ///
			graphregion(color(white)) name(SomeCollegeByAge, replace)

		graph export  "$directory\Outputs\Women-College-23-30.png", replace

