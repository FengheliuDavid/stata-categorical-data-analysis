//1.1a) Set-up your do-file. 
capture log close       			  			//closes any open log file.
log using 	icpsrcda-01-brm-p1, replace text   	//opens a log file that  
												//records both commands
												//and results.

//  Program:    icpsrcda-01-brm-p1.do
//  Task:       Review 1 - Binary Part 1
//  Project:    ICPSR CDA
//  Author:     Trent Mize \ 2014-06-24
//	updated:	Muna Adem 	\ 2020-07-15

**program setup
version 14.0             	//this command is for version control, 
							//ensuring that results can be replicated.
clear 	all               	//this command removes data, value labels, matrices, 
							//scalars, saved results, etc. from memory.
set 	linesize 80       	//specifies screen size width & prevents wrapping

* only run this line once if you dont have cleanplots already 
*net install cleanplots, from("https://tdmize.github.io/data/cleanplots")
set scheme cleanplots, perm 

//1.1b) Load the Data. 
usecda 		cda_scireview3

 
//1.1c) Examine the Data and Select Variables. 
codebook, 	compact
keep 		faculty fellow phd mcit3 mnas
codebook, 	compact

//1.1d) Drop cases with missing data and verify.  
misschk, 	gen(m) 
tab 		mnumber
keep if 	mnumber==0

//1.2) Describe your data.  
codebook 	faculty fellow phd mcit3 mnas, compact
sum 		faculty fellow phd mcit3 mnas

//1.3) Binary logit model. 
logit 		faculty fellow phd mcit3 mnas

//1.4) Computing factor change coefficients. 
listcoef , 	help

* Y-standardized coefficents 
listcoef , 	std help


//1.7a) Compute predicted probabilities when fellow = 1 and when fellow = 0 
mtable, 	at(fellow=(0 1)) atmeans

//1.7b) Use predicted probabilities to compute factor change coefficient I.  
display ((0.7159/(1-0.7159)) / (0.4192/(1-0.4192)))


//1.8-1.9) Compare the coefficients from logit and probit. 
quietly logit 	faculty fellow phd mcit3 mnas // ‘quietly’ = no output shown
estimates 		store estlogit
probit 			faculty fellow phd mcit3 mnas
listcoef, help
listcoef, std help
estimates 		store estprobit
estimates table estlogit estprobit , b(%9.3f) se

//1.END) Close Log File and Exit Do File. 
log close
exit

