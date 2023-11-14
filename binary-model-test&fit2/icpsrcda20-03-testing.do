capture log close
log using icpsrcda-03-testing, replace text

//  program:    icpsrcda-03-testing.do
//  task:       Review 3 - Testing & Fit
//  project:    ICPSR CDA
//  author:     Liu Fenghe \ 2021-08-01


*program setup
version 	17.0
clear 		all 
set 		linesize 80
matrix drop _all
set more off

//Load the Data.
usecda 		cda_science4
save "cda_science4-modified.dta", replace
use "cda_science4-modified.dta", clear

//Generate dummy variable
gen cit6_20= (cit6>20) 
label define cit6_20 0 "citations3 under 20" 1 "citations3 more than 20"


//3.1) Examine data, keep variables, drop missing, and verify.
codebook, 	compact
keep 		cit6_20 female fellow phd enroll mcit3 mnas

misschk, 	gen(m) 
tab 		mnumber
keep if 	mnumber==0

codebook,   compact   
sum 		cit6_20 female fellow phd enroll mcit3 mnas

//3.2) Computing a z-test. 
logit 		cit6_20 i.female phd mcit3, nolog

//3.3) Single Coefficient Wald Test. 
test 		1.female

//3.4) Single Coefficient LR Test. 
logit 		cit6_20 i.female phd mcit3, nolog
estimates 	store base
logit 		cit6_20 phd mcit3, nolog
estimates 	store nofemale
lrtest 		base nofemale

//3.5) Multiple Coefficients Wald Test.  
qui logit 	cit6_20 i.female phd mcit3, nolog
test 		1.female phd

//3.6) Multiple Coefficients LR Test. 
logit 		cit6_20 mcit3
estimates 	store nofemalephd
lrtest 		base nofemalephd

//3.7) Wald Test All Coefficients are Zero. 
logit 		cit6_20 i.female phd mcit3
test 		1.female phd mcit3

//3.8) LR Test All Coefficients are Zero. 
logit 		cit6_20
estimates 	store intercept
lrtest 		base intercept

//3.9) More Complicated Wald Tests. 
qui logit 	cit6_20 i.female phd mcit3
test 		1.female = 2*mcit3

//3.10) Compare BIC & AIC statistics across non-nested models. 
qui logit 	cit6_20 i.female phd mcit3
estimates 	store m1

qui logit 	cit6_20 i.female mcit3 
estimates 	store m2

qui logit 	cit6_20 i.female enroll mcit3 mnas
estimates 	store m3

qui logit 	cit6_20 i.female i.fellow i.mnas phd enroll mcit3 
estimates 	store m4

estimates 	table m1 m2 m3 m4, b(%9.3f) star stats(bic aic)

//3.11) Compute and list residuals. 
logit 		cit6_20 phd i.mnas i.female i.fellow
predict 	rstd, rs
sort 		rstd
list 		rstd cit6_20 phd mnas female fellow in 1/45, clean // Note: 1=#
list 		rstd cit6_20 phd mnas female fellow in -30/l, clean 
*												Note: l=letter; as in 'last'

//3.END) Close the Log File and exit Do File.
log close
exit
*/




