* Import the CSV file
import delimited "/your path/paper_info.csv"

* Generate a new variable lnc3 lnc10, which is the natural logarithm of (1 + c3)
gen lnc3 = log(1 + c3)
gen lnc10 = log(1 + c10)
############################################################################################################
* Table 1 Code

reg lnc3 affiliation_diversity teamsize log_ref sjr if year <= 2017, r
 
reg lnc3 affiliation_diversity teamsize log_ref sjr i.year i.field if year <= 2017, r

reg lnc10 affiliation_diversity teamsize log_ref sjr if year <= 2010, r

reg lnc10 affiliation_diversity teamsize log_ref sjr i.year i.field if year <= 2010, r

logit top5 affiliation_diversity teamsize log_ref sjr, r
 
logit top5 affiliation_diversity teamsize log_ref sjr i.year i.field, r

#########################################################################################################
* Table 2 Code

* Define a local macro 'countries' containing a list of countries
local countries "US CN JP GB"

* c3
foreach country in `countries' {	
    reg lnc3 affiliation_diversity teamsize log_ref sjr i.year i.field if country == "`country'" & year <= 2017, r
}
* c10
foreach country in `countries' {
    reg lnc10 affiliation_diversity teamsize log_ref sjr i.year i.field if country == "`country'" & year <= 2010, r  
}
* hit paper
foreach country in `countries' {
    logit top5 affiliation_diversity teamsize log_ref sjr i.year i.field if country == "`country'", r iterate(10)   
}

###############################################################################################################
* Figure 6 Code

* overall c3
* Loop through team sizes from 2 to 10
forvalues t = 2/10 {
    reg lnc3 affiliation_diversity log_ref sjr i.year i.field if teamsize == `t' & year <= 2017, r
    est sto m`t'
}
* Export the regression results of lnc3 for each team size to a Word document
reg2docx m2 m3 m4 m5 m6 m7 m8 m9 m10 ///
    using "/your path/figure6_overall_c3.docx", append ///
    scalars(N r2(%9.3f) r2_a(%9.3f)) b(%9.3f) se(%7.3f) title("Overall c3")  
	
* overall c10
* Loop through team sizes from 2 to 10
forvalues t = 2/10 {
    reg lnc10 affiliation_diversity log_ref sjr i.year i.field if teamsize == `t' & year <= 2010, r
    est sto m`t'
}
* Export the regression results of lnc10 for each team size to a Word document
reg2docx m2 m3 m4 m5 m6 m7 m8 m9 m10 ///
    using "/your path/figure6_overall_c10.docx", append ///
    scalars(N r2(%9.3f) r2_a(%9.3f)) b(%9.3f) se(%7.3f) title("Overall c10")    


* overall top5
* Loop through team sizes from 2 to 10
forvalues t = 2/10 {
    reg top5 affiliation_diversity log_ref sjr i.year i.field if teamsize == `t' , r
    est sto m`t'
}
* Export the regression results of top5 for each team size to a Word document
reg2docx m2 m3 m4 m5 m6 m7 m8 m9 m10 ///
    using "/your path/figure6_overall_top5.docx", append ///
    scalars(N r2(%9.3f) r2_a(%9.3f)) b(%9.3f) se(%7.3f) title("Overall top5")  


* Define a local macro 'countries' containing a list of countries
local countries "US CN JP GB "

* c3
foreach country in `countries' {
    * Loop through team sizes from 2 to 10
    forvalues t = 2/10 {
        reg lnc3 affiliation_diversity log_ref sjr i.year i.field if teamsize == `t' & country == "`country'" & year <= 2017, r
        est sto `country'_m`t'
    }
    * Export the regression results of lnc3 for each team size of the current country to a Word document
    reg2docx `country'_m2 `country'_m3 `country'_m4 `country'_m5 `country'_m6 `country'_m7 `country'_m8 `country'_m9 `country'_m10 ///
        using "/your path/figure6_c3.docx", append ///
        scalars(N r2(%9.3f) r2_a(%9.3f)) b(%9.3f) se(%7.3f) title("`country' c3")
}

* c10
foreach country in `countries' {
    forvalues t = 2/10 {
        reg lnc10 affiliation_diversity log_ref sjr i.year i.field if teamsize == `t' & country == "`country'" & year <= 2010, r
        est sto `country'_m`t'
    }
    * Export the regression results of lnc10 for each team size of the current country to a Word document
    reg2docx `country'_m2 `country'_m3 `country'_m4 `country'_m5 `country'_m6 `country'_m7 `country'_m8 `country'_m9 `country'_m10 ///
        using "/your path/figure6_c10.docx", append ///
        scalars(N r2(%9.3f) r2_a(%9.3f)) b(%9.3f) se(%7.3f) title("`country' c10")
}

* hit paper
foreach country in `countries' {

    forvalues t = 2/10 {
        logit top5 affiliation_diversity log_ref sjr i.year i.field if teamsize == `t' & country == "`country'", r iterate(10)
        est sto `country'_m`t'
    }
    * Export the regression results of top5 for each team size of the current country to a Word document
    reg2docx `country'_m2 `country'_m3 `country'_m4 `country'_m5 `country'_m6 `country'_m7 `country'_m8 `country'_m9 `country'_m10 ///
        using "/your path/figure6_top5.docx", append ///
        scalars(N r2(%9.3f) r2_a(%9.3f)) b(%9.3f) se(%7.3f) title("`country' HIT")
}
#############################################################################################################
* Table 3 Code

encode country, gen(country_num)

recode country_num (176 = 1) (38 = 2) (85 = 3) (59 = 4) (44 = 5) (77 = 6) (31 = 7) (25 = 8) (57 = 9)

* Define a label set 'country_label' for the 'country_num' variable
label define country_label 1 "US" 2 "CN" 3 "JP" 4 "GB" 5 "DE" 6 "IN" 7 "CA" 8 "BR" 9 "FR", modify

* Apply the label set to the 'country_num' variable
label values country_num country_label

reg lnc3 contribution affiliation_diversity teamsize log_ref sjr i.year i.field if year <= 2017, r

reg lnc10 contribution affiliation_diversity teamsize log_ref sjr i.year i.field if year <= 2010, r

logit top5 contribution affiliation_diversity teamsize log_ref sjr i.year i.field, r

reg contribution i.country_num, r

reg contribution affiliation_diversity teamsize i.country_num, r

reg contribution affiliation_diversity teamsize log_ref sjr i.year i.field i.country_num, r

* End


