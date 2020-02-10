/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PURPOSE: 		WC - NCA Lashio Project

AUTHOR:  		Nicholus

CREATED: 		02 Dec 2019

MODIFIED:
   

THINGS TO DO:

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

** 	IMPORT DATASET **

import excel using "$raw/NCA_LAISHIO_WC_FINAL_2019_12_11_08_57_30_839866-group-name-removed.xls", describe 


// sheet("data") cellrange(A7:EI103)firstrow case(lower) allstring clear


local n_sheets `r(N_worksheet)'
forvalues j = 1/`n_sheets' {
	local sheet_`j' `r(worksheet_`j')'
}

forvalues i = 1/`n_sheets' {
	local range_`i' `r(range_`i')'
}


forvalues j = 1/`n_sheets' {
	import excel using "$raw/NCA_LAISHIO_WC_FINAL_2019_12_11_08_57_30_839866-group-name-removed.xls", ///
						sheet("`sheet_`j''") ///
						firstrow case(lower) ///
						cellrange(`range_`j'') ///
						allstring clear
	if `j' <= 2 {					
		count if !mi(_index)
		di "`sheet_`j'' : `r(N)'"
		save "$dta/`sheet_`j''.dta", replace
	}
	else if "`sheet_`j''" == "consent_child_vc_rep" {
		
		keep if !mi(child_ill)
		count if !mi(child_ill) 
		di "`sheet_`j'' : `r(N)'"
		save "$dta/`sheet_`j''.dta", replace
	}
	else if "`sheet_`j''" == "consent_grp_q2_5_to_q2_7" {
		
		keep if !mi(child_bf)
		count if !mi(child_bf) 
		di "`sheet_`j'' : `r(N)'"
		save "$dta/`sheet_`j''.dta", replace
	}
	else if "`sheet_`j''" == "consent_ancpast_rep" {
		
		keep if !mi(ancpast_adopt)
		count if !mi(ancpast_adopt) 
		di "`sheet_`j'' : `r(N)'"
		save "$dta/`sheet_`j''.dta", replace
	}
	else if "`sheet_`j''" == "consent_childanthro_rep" {
		
		keep if !mi(cal_anthro)
		count if !mi(cal_anthro) 
		di "`sheet_`j'' : `r(N)'"
		save "$dta/`sheet_`j''.dta", replace
	}

}

clear


