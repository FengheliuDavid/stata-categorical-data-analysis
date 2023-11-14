//1a) Set-up your do-file. 
capture log close
log using orm, replace text

//  program:    orm.do
//  task:       Assignment5 - Ordinal Regression
//  project:    ICPSR CDA
//  author:     Liu Fenghe \ 2021-08-05


*program setup
version 	17.0
clear 		all 
set 		linesize 80
*set scheme cleanplots, perm

//1b) Load the Data.
usecda 	cda_hsb4

//1c) Examine data, select variables, drop missing, and verify. 
codebook, 	compact
keep 		talkpar agehome female dadplans expenses
misschk, 	gen(m)
tab 		mnumber
keep if 	mnumber==0
codebook 	talkpar agehome female dadplans expenses, compact
sum 		talkpar agehome female dadplans expenses

//2) Produce table including distribution of output variable. 
tab1 		talkpar, mis

//3) Estimate the Ordered Logit. 
ologit 		talkpar agehome i.female dadplans expenses

//4-6) Odds Ratios. 
listcoef, 	help
listcoef, 	percent help

//7) Compute Discrete Change for C and B. 
mchange 	female agehome, atmeans centered 

//8) Get confidence interval 
mchange 	female agehome, atmeans centered stats(ci)


//12)
**Generate new variables to plot
mgen,		at(agehome=(1(1)31)) atmeans stub(mpr)

label var mprpr1 "Pr(rare)"
label var mprpr2 "Pr(less than once a week)"
label var mprpr3 "Pr(once or twice a week)"
label var mprpr4 "Pr(every)"
label var mprCpr1 "Pr(<=rare)"
label var mprCpr2 "Pr(<=less than once a week)"
label var mprCpr3 "Pr(<=once or twice a week)"
label var mprCpr4 "Pr(<=every)"

**Graph predicted probabilities
graph twoway (connected mprpr1 mprpr2 mprpr3 mprpr4 mpragehome, ///
		title("Frequency of Talking To Parents and Age To Move Out") ///
		subtitle("(Other Variables Held at Means)") ///
		ytitle("Predicted Pr(Frequancy)") ///
		xtitle("Age To Move Out") ///
		xlabel(1(5)31) ylabel(0(.25)1, grid) ///
		msymbol(none none none none))  
	
graph export icpsrcda04-ordinal-fig1.png , width(1200) replace

* Obtain specific number
margins, at(agehome=(1(10)31)) atmeans post
mlincom (3-1), clear rowname(atmeans) stats(est p ll ul)
mlincom (4-2), clear rowname(atmeans) stats(est p ll ul)
mlincom (3-2) - (1-2), clear rowname(atmeans) stats(est p ll ul)

**Graph cumulative probabilities
graph twoway (connected mprCpr1 mprCpr2 mprCpr3 mprCpr4 mpragehome, ///
		title("Frequency of Talking To Parents and Age To Move Out") ///
		subtitle("(Other Variables Held at Means)") ///
		ytitle("Predicted Pr(Frequancy)") ///
		xtitle("Age To Move Out") ///
		xlabel(1(5)31) ylabel(0(.25)1, grid) ///
		msymbol(none none none none) name(tmp2, replace) ///
		text(.22 5 "rare", place(e)) ///
		text(.50 6 "less than once a week", place(e)) ///
		text(.67 14 "once or twice a week", place(e)) ///
		text(.90 17 "every", place(e))), ///
		legend(off)

graph export icpsrcda04-ordinal-fig2.png , width(1200) replace

//14) Testing the Parallel Regression Assumption. 
ologit 		talkpar agehome i.female dadplans expenses
brant, 	detail

//END) Close the Log File and Exit Do File. 
log close
exit





