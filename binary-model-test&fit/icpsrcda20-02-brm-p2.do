capture log close       			  
log using cda_addhealth4-change, replace text   

//  program:    icpsrcda-02-brm-p2.do
//  task:       Review 2 - Binary-part 2
//  project:    ICPSR CDA
//  author:     Liu Fenghe \ 2021-07-29

*program setup
version 	17.0 
clear 		all                 
set 		linesize 80  
         

//2.1b) Load the Data. 
use "cda_addhealth4-change.dta", clear

//2.1c) Re-estimate your binary logit model. 
logit havesex age i.dadcoll depress
 
//2.2) Predicted Probabilities using predict. 
predict 	prlogit
label var 	prlogit "Logit: Predicted Probability"
sum 		prlogit
dotplot 	prlogit, ylabel(0(0.2)1) ///
title("Predicted probability from logit") ytitle("Pr(Have sex probability)")
graph export icpsrcda02-binary-fig1.png , width(1200) replace

//2.3) Discrete change. Marginal Effects at the Mean
mchange, atmeans centered

//2.4) Discrete change for B + confidence interval. 
mchange	dadcoll, atmeans stats(ci)  

//2.5) Discrete change for C + confidence interval. 
mchange age, atmeans stats(ci) centered

//2.6) Plot predicted probabilities.  
**For people whose dad goes to college, across the range of age
mgen, 		at(dadcoll=1 age=(11(1)21)) atmeans stub(dadcoll1)
label var	dadcoll1pr1 "Dad goes to college"

**For people whose dad does not go to college, across the range of age
mgen, 		at(dadcoll=0 age=(11(1)21)) atmeans stub(dadcoll0)
label var	dadcoll0pr1 "Dad does not go to college"

graph twoway ///
	(rarea dadcoll1ul1 dadcoll1ll1 dadcoll1age, color(gs10)) ///
	(rarea dadcoll0ul1 dadcoll0ll1 dadcoll0age, color(gs10)) ///
	(connected dadcoll1pr1 dadcoll1age, lpattern(dash) msize(zero)) ///
	(connected dadcoll0pr1 dadcoll0age, lpattern(solid) msize(zero)), ///
	legend(on order(3 4)) ///
	ylabel(0(.25)1) ytitle("Pr(havesex)") ///
	xlabel(11(1)21) xtitle("age") ///
	title("Predicted Probability of Having Sex")

graph export icpsrcda02-binary-fig2.png , width(1200) replace

margins, at(age=15 dadcoll=0) at(age=15 dadcoll=1) at(age=20 dadcoll=0) ///
         at(age=20 dadcoll=1) atmeans post

mlincom (3-1), clear rowname(atmeans) stats(est p ll ul)
mlincom (2-1), clear rowname(atmeans) stats(est p ll ul)


//2.END) Close Log File and Exit Do File. 
log close
exit




