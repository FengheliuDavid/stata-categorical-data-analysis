//6.1a) Set-up your do-file. 
capture log close
log using icpsrcda-05-nominal, replace text

//  program:    icpsrcda-05-nominal.do
//  task:       Nominal Regression
//  project:    ICPSR CDA
//  author:      \ 2021-08-10


*program setup
version 	17.0
clear 		all 
set 		linesize 80

//6.1b) Load the Data.
usecda 	cda_hsb4

//6.1c) Examine data, select variables, drop missing, and verify. 
codebook, 	compact
keep 		talkpar agehome female dadplans expenses
misschk, 	gen(m)
tab 		mnumber
keep if 	mnumber==0

//6.2) Verify data are clean. 
codebook 	talkpar agehome female dadplans expenses, compact
sum 		talkpar agehome female dadplans expenses

//6.3) Distribution of Dependent Variable
tab 		talkpar, mis

//6.4a) Multinomial Logit. 
mlogit 		talkpar agehome i.female dadplans expenses, baseoutcome(1) nolog

//6.4b) Multinomial Logit. 
listcoef, 	help

//6.5) Single Coefficient Wald & LR Test. 
mlogtest 	1.female , wald
mlogtest 	agehome , wald


//6.6) OR Plot using mlogitplot
mlogitplot 	i.female agehome, amount(sd) ///
			symbols(R L O D) ///
			note(Frequency: 1=Rarely   2=Less than 1/wk   3=One~Two times/wk   4=Daily)

graph export icpsrcda05-nominal-fig1.png , width(1200) replace

//6.8a) Discrete Change.  
mchange, atmeans

//6.8b) Marginal Effects Plot
mchangeplot i.female agehome, amount(sd) ///
			symbols(R L O D) ///
			note(Frequency: 1=Rarely   2=Less than 1/wk   3=One~Two times/wk   4=Daily)

graph export icpsrcda05-nominal-fig2.png , width(1200) replace
	
//6.9) 	Calculating and Plotting Discrete Change II at specified levels
*		of the covariates
mchange, at(dadplans=1) atmeans
mchangeplot i.female agehome, amount(sd) ///
			symbols(R L O D) ///
			note(Frequency: 1=Rarely  2=Less than 1/wk  3=One~Two times/wk  4=Daily) ///
			min(-.27) max(.29)

graph export icpsrcda05-nominal-fig3.png , width(1200) replace

//6.11) help to interpret
mchange female agehome, atmeans centered
mchange female agehome, atmeans centered stats(ci)

//6.END) Close Log File and Exit Do File.
log close
exit
*/





 
