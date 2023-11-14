//1a) Set-up the do-file. 
capture log close                                           //closes any open log file.
log using "C:\Users\lfz00\Desktop\ICPSR\assignment2\LiuFengzhe-assignment2-logfile", replace text    //opens a log file that  
												            //records both commands
												            //and results.   

// program:   LiuFengzhe-assignment2-logfile.do
// task: do   CDA assignment2
// project:   ICPSR-CDA
// author:    Fengzhe LIU \ 2021.7.25

// program setup
version 17                  //version control
clear all                   //removes data, value labels, matrices, 
							//scalars, saved results, etc. from memory.
set linesize 80             //specifies screen size width & prevents wrapping
matrix drop _all
set more off

//1b) load the data
cd "C:\Users\lfz00\Desktop\ICPSR\assignment2"
usecda cda_hrs
save "cda_hrs-modified.dta", replace
use "cda_hrs-modified.dta", clear

//1c)
codebook, compact            
keep nursing race couple nagitot
codebook, compact            // we can find that sample sizes are same now

//1d) Drop cases with missing data and verify.  
misschk, 	gen(m) 
tab 		mnumber
keep if 	mnumber==0

//2) Describe the data
codebook nursing race couple nagitot, compact            
sum nursing race couple nagitot

//3) Binary logit model. 
logit nursing nagitot i.couple i.race

//4) Computing factor change coefficients. 
listcoef, std help

//7a) Compute predicted probabilities when couple = 1 & other vars at mean
. margins, at(couple = 1) atmeans

//7b) Compute predicted probabilities when couple = 0 & other vars at mean
. margins, at(couple = 0) atmeans

//7c) Calculate the factor change coefficient for B using these values
. display ((.0029453/(1-.0029453))/( .0122622/(1-.0122622)))

//7d) Repeat steps (a)-(c) holding the other variables at some value other //than their mean.
. margins, at(couple = 1  race = 2 nagitot = 10)  //B = 1
. margins, at(couple = 0  race = 2 nagitot = 10)  //B = 0
// display ((0.9597/(1-0.9597)) / (0.8703/(1-0.8703)))

//8) logit 
quietly logit nursing nagitot i.couple i.race // `quietly' = no output shown
estimates store estlogit
probit nursing nagitot i.couple i.race
listcoef, std help
estimates store estprobit
estimates table estlogit estprobit, b(%9.3f) se //abababababbabbabbab

//END) Close Log File and Exit Do File. 
log close
exit




