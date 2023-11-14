//1.1a) Set-up the do-file. 
capture log close                                           //closes any open log file.
log using "C:\Users\lfh\Desktop\umich summer\categorical data\homework\assig2\lfh-assig2log", replace text    

// Program:   lfh-assig2.do
// Task:      Categorical Data Analysis assignment2
// Project:   ICPSR-CDA
// Author:    Liu Fenghe
// Date:      27th July 2021

// program setup:
version 17                  //version control
clear all                   //removes data, value, matrices, results, etc. from memory
set linesize 80             //specifies screen size width & prevents wrapping
matrix drop _all
set more off

//1.1b) Load the data.
usecda cda_addhealth4
save "cda_addhealth4-change.dta", replace
use "cda_addhealth4-change.dta", clear

//1.1c) Examine the Data and Select Variables. 
codebook, compact            
keep havesex age dadcoll depress
codebook, compact         

//1.1d) Drop cases with missing data and verify.  
misschk, 	gen(m) 
tab 		mnumber
keep if 	mnumber==0

//1.2) Describe the data
codebook havesex age dadcoll depress, compact            
sum havesex age dadcoll depress

//1.3) Binary logit model. 
logit havesex age i.dadcoll depress

//1.4) Computing factor change coefficients. 
listcoef, help

//1.7a) Compute predicted probabilities when dadcoll = 1 and others at mean
margins, at(dadcoll = 1) atmeans

//1.7b) Compute predicted probabilities when dadcoll = 0 and others at mean
margins, at(dadcoll = 0) atmeans

//1.7c) Calculate the factor change coefficient for B using these values
display ((.2288492/(1-.2288492))/(.3527835 /(1-.3527835))) 

//1.7d) Repeat steps (a)-(c) holding other variables at other values.
margins, at(dadcoll = 1 depress = 47 age = 20.66)  // when B = 1
margins, at(dadcoll = 0 depress = 47 age = 20.66)  // when B = 0
display ((0.9340784/(1-0.9340784)) / (0.9629983/(1-0.9629983))) 

//1.8) logit 
quietly logit havesex age i.dadcoll depress
estimates store estlogit
listcoef, std help
probit havesex age i.dadcoll depress
listcoef, std help
estimates store estprobit
estimates table estlogit estprobit, b(%9.3f) se 

//END) Close Log File and Exit Do File. 
log close
exit
