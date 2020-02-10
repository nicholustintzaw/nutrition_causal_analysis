/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PURPOSE: 		WC - NCA Lashio Project

AUTHOR:  		Nicholus

CREATED: 		02 Dec 2019

MODIFIED:

THINGS TO DO:

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

**----------------------------------------------------------------------------**
** Respondent & HH Info Dataset
**----------------------------------------------------------------------------**

use "$cdta/respondent_cleanded.dta", clear

global geo	geo_vill_16 geo_vill_15 geo_vill_14 geo_vill_13 geo_vill_12 geo_vill_11 ///
			geo_vill_10 geo_vill_9 geo_vill_8 geo_vill_7 geo_vill_6 geo_vill_5 geo_vill_4 ///
			geo_vill_3 geo_vill_2 geo_vill_1 will_participate 
preserve 

keep $geo     
gen var_name = ""
	label var var_name "   "

foreach var in mean sd count {
	gen `var' = 0
	label var `var' "`var'"
}
	
local i = 1
foreach var of global geo {
		
	local label : variable label `var'
	replace var_name = "`label'" in `i'
	
	quietly mean `var' 
	estat sd
	mat a = r(mean)
	mat b = r(sd)
	global mean = round((a[1,1]), 0.001)
	replace mean = $mean in `i'
	
	global sd = round((b[1,1]), 0.001)	
	replace sd = $sd in `i'
	
	global count = e(N)
	replace count = $count in `i'
	
	local i = `i' + 1
	
}

drop if count == 0     //get rid of extra raws
global export_table var_name mean sd count

export excel $export_table using "$out/01_wc_nca_hh_sumstat.xls",  sheet("01_geo") firstrow(varlabels) sheetreplace 
restore

**----------------------------------------------------------------------------**
**----------------------------------------------------------------------------**


global ppi	national_povt_line wealth_quintile ///
			wealth_poorest wealth_poor wealth_medium wealth_wealthy wealth_wealthiest
preserve 

keep $ppi     
gen var_name = ""
	label var var_name "   "

foreach var in mean se lb ub count {
	gen `var' = 0
	label var `var' "`var'"
}
	
local i = 1
foreach var of global ppi {
		
	local label : variable label `var'
	replace var_name = "`label'" in `i'
	
	quietly mean `var'
	estat sd
	ci mean `var', level(95)
	
	mat a 	= r(mean)
	mat c	= r(se)
	mat d	= r(lb)
	mat e	= r(up)
	
	global mean 	= round(`r(mean)', 0.001)
	replace mean 	= $mean in `i'
	
	global se		= round(`r(se)', 0.001)
	replace se		= $se in `i'
	
	global lb		= round(`r(lb)', 0.001)
	replace lb		= $lb in `i'
	
	global ub		= round(`r(ub)', 0.001)
	replace ub		= $ub in `i'
	
	global count = `r(N)'
	replace count = $count in `i'
	
	local i = `i' + 1
	
}

drop if count == 0     //get rid of extra raws
global export_table var_name mean se lb ub count

export excel $export_table using "$out/01_wc_nca_hh_sumstat.xls",  sheet("02_ppi") firstrow(varlabels) sheetreplace 
restore


**----------------------------------------------------------------------------**
**----------------------------------------------------------------------------**

global ddsw		momdiet_fg_grains momdiet_fg_vitveg momdiet_fg_vitfruit momdiet_fg_othfruit momdiet_fg_othveg ///
				momdiet_fg_meat momdiet_fg_eggs momdiet_fg_pulses momdiet_fg_nut momdiet_fg_diary ///
				momdiet_ddsw momdiet_min_ddsw ///
				mom_meal_freq


preserve 

keep $ddsw     
gen var_name = ""
	label var var_name "   "

foreach var in mean se lb ub count {
	gen `var' = 0
	label var `var' "`var'"
}
	
local i = 1
foreach var of global ddsw {
		
	local label : variable label `var'
	replace var_name = "`label'" in `i'
	
	quietly mean `var'
	estat sd
	ci mean `var', level(95)
	
	mat a 	= r(mean)
	mat c	= r(se)
	mat d	= r(lb)
	mat e	= r(up)
	
	global mean 	= round(`r(mean)', 0.001)
	replace mean 	= $mean in `i'
	
	global se		= round(`r(se)', 0.001)
	replace se		= $se in `i'
	
	global lb		= round(`r(lb)', 0.001)
	replace lb		= $lb in `i'
	
	global ub		= round(`r(ub)', 0.001)
	replace ub		= $ub in `i'
	
	global count = `r(N)'
	replace count = $count in `i'
	
	local i = `i' + 1
	
}

drop if count == 0     //get rid of extra raws
global export_table var_name mean se lb ub count

export excel $export_table using "$out/01_wc_nca_hh_sumstat.xls",  sheet("03_ddsw") firstrow(varlabels) sheetreplace 
restore				


//wealth_quintile

forvalue x = 1/5 {
	preserve 
	
	keep if wealth_quintile == `x'

	keep $ddsw     
	gen var_name = ""
		label var var_name "   "

	foreach var in mean se lb ub count {
		gen `var' = 0
		label var `var' "`var'"
	}
		
	local i = 1
	foreach var of global ddsw {

		local label : variable label `var'
		replace var_name = "`label'" in `i'
		
		count if !mi(`var')
		if `r(N)' > 0 {
			quietly mean `var'
			estat sd
			ci mean `var', level(95)
			
			mat a 	= r(mean)
			mat c	= r(se)
			mat d	= r(lb)
			mat e	= r(up)
			
			global mean 	= round(`r(mean)', 0.001)
			replace mean 	= $mean in `i'
			
			global se		= round(`r(se)', 0.001)
			replace se		= $se in `i'
			
			global lb		= round(`r(lb)', 0.001)
			replace lb		= $lb in `i'
			
			global ub		= round(`r(ub)', 0.001)
			replace ub		= $ub in `i'
			
			global count = `r(N)'
			replace count = $count in `i'
			}
		
		local i = `i' + 1
		
	}

	drop if mi(var_name) 
	global export_table var_name mean se lb ub count


	export excel $export_table using "$out/01_wc_nca_hh_sumstat.xls",  sheet("03_ddsw_quan_`x'") firstrow(varlabels) sheetreplace 
	restore			
}

**----------------------------------------------------------------------------**
**----------------------------------------------------------------------------**

global wash		water_sum_limited water_sum_unimprove water_sum_surface ///
				water_rain_limited water_rain_unimprove water_rain_surface ///
 				water_winter_limited water_winter_unimprove water_winter_surface ///
				water_sum_treat_yes water_rain_treat_yes water_winter_treat_yes ///
				latrine_ladder latrine_basic latrine_limited latrine_unimprove latrine_opendef ///
				latrine_basic_funct latrine_basic_funct_clean latrine_basic_funct_clean_nshare ///
				observ_washplace_no handwash_ladder handwash_basic handwash_limited handwash_no handwash_critical ///
				soap_child_faeces_1 soap_child_faeces_2 soap_child_faeces_3 soap_child_faeces_4 ///
				soap_tiolet_1 soap_tiolet_2 soap_tiolet_3 soap_tiolet_4 soap_before_cook_1 ///
				soap_before_cook_2 soap_before_cook_3 soap_before_cook_4 soap_before_eat_1 ///
				soap_before_eat_2 soap_before_eat_3 soap_before_eat_4 soap_feed_child_1 ///
				soap_feed_child_2 soap_feed_child_3 soap_feed_child_4
preserve 

keep $wash     
gen var_name = ""
	label var var_name "   "

foreach var in mean se lb ub count {
	gen `var' = 0
	label var `var' "`var'"
}
	
local i = 1
foreach var of global wash {
		
	local label : variable label `var'
	replace var_name = "`label'" in `i'
	
	quietly mean `var'
	estat sd
	ci mean `var', level(95)
	
	mat a 	= r(mean)
	mat c	= r(se)
	mat d	= r(lb)
	mat e	= r(up)
	
	global mean 	= round(`r(mean)', 0.001)
	replace mean 	= $mean in `i'
	
	global se		= round(`r(se)', 0.001)
	replace se		= $se in `i'
	
	global lb		= round(`r(lb)', 0.001)
	replace lb		= $lb in `i'
	
	global ub		= round(`r(ub)', 0.001)
	replace ub		= $ub in `i'
	
	global count = `r(N)'
	replace count = $count in `i'
	
	local i = `i' + 1
	
}

drop if count == 0     //get rid of extra raws
global export_table var_name mean se lb ub count

export excel $export_table using "$out/01_wc_nca_hh_sumstat.xls",  sheet("06_wash") firstrow(varlabels) sheetreplace 
restore	


global wash		water_sum_limited water_sum_unimprove water_sum_surface ///
				water_rain_limited water_rain_unimprove water_rain_surface ///
 				water_winter_limited water_winter_unimprove water_winter_surface ///
				water_sum_treat_yes water_rain_treat_yes water_winter_treat_yes ///
				latrine_ladder latrine_basic latrine_limited latrine_unimprove latrine_opendef ///
				latrine_basic_funct latrine_basic_funct_clean latrine_basic_funct_clean_nshare ///
				observ_washplace_no handwash_ladder handwash_basic handwash_limited handwash_no 
				
//wealth_quintile
forvalue x = 1/5 {
	preserve 
	
	keep if wealth_quintile == `x'

	keep $wash     
	gen var_name = ""
		label var var_name "   "

	foreach var in mean se lb ub count {
		gen `var' = 0
		label var `var' "`var'"
	}
		
	local i = 1
	foreach var of global wash {
			
		local label : variable label `var'
		replace var_name = "`label'" in `i'
		
		count if !mi(`var')
		if `r(N)' > 0 {
			quietly mean `var'
			estat sd
			ci mean `var', level(95)
			
			mat a 	= r(mean)
			mat c	= r(se)
			mat d	= r(lb)
			mat e	= r(up)
			
			global mean 	= round(`r(mean)', 0.001)
			replace mean 	= $mean in `i'
			
			global se		= round(`r(se)', 0.001)
			replace se		= $se in `i'
			
			global lb		= round(`r(lb)', 0.001)
			replace lb		= $lb in `i'
			
			global ub		= round(`r(ub)', 0.001)
			replace ub		= $ub in `i'
			
			global count = `r(N)'
			replace count = $count in `i'
			}
		
		local i = `i' + 1
		
	}

	drop if mi(var_name) 
	global export_table var_name mean se lb ub count

	export excel $export_table using "$out/01_wc_nca_hh_sumstat.xls",  sheet("06_wash_quan_`x'") firstrow(varlabels) sheetreplace 
	restore			
}



global wash		handwash_critical ///
				soap_child_faeces_1 soap_child_faeces_2 soap_child_faeces_3 soap_child_faeces_4 ///
				soap_tiolet_1 soap_tiolet_2 soap_tiolet_3 soap_tiolet_4 soap_before_cook_1 ///
				soap_before_cook_2 soap_before_cook_3 soap_before_cook_4 soap_before_eat_1 ///
				soap_before_eat_2 soap_before_eat_3 soap_before_eat_4 soap_feed_child_1 ///
				soap_feed_child_2 soap_feed_child_3 soap_feed_child_4
				
//wealth_quintile
forvalue x = 1/5 {
	preserve 
	
	keep if wealth_quintile == `x'

	keep $wash     
	gen var_name = ""
		label var var_name "   "

	foreach var in mean se lb ub count {
		gen `var' = 0
		label var `var' "`var'"
	}
		
	local i = 1
	foreach var of global wash {
			
		local label : variable label `var'
		replace var_name = "`label'" in `i'
		
		count if !mi(`var')
		if `r(N)' > 0 {
			quietly mean `var'
			estat sd
			ci mean `var', level(95)
			
			mat a 	= r(mean)
			mat c	= r(se)
			mat d	= r(lb)
			mat e	= r(up)
			
			global mean 	= round(`r(mean)', 0.001)
			replace mean 	= $mean in `i'
			
			global se		= round(`r(se)', 0.001)
			replace se		= $se in `i'
			
			global lb		= round(`r(lb)', 0.001)
			replace lb		= $lb in `i'
			
			global ub		= round(`r(ub)', 0.001)
			replace ub		= $ub in `i'
			
			global count = `r(N)'
			replace count = $count in `i'
			}
		
		local i = `i' + 1
		
	}

	drop if mi(var_name) 
	global export_table var_name mean se lb ub count

	export excel $export_table using "$out/01_wc_nca_hh_sumstat.xls",  sheet("06_wash_quan_2_`x'") firstrow(varlabels) sheetreplace 
	restore			
}

**----------------------------------------------------------------------------**
**----------------------------------------------------------------------------**
**----------------------------------------------------------------------------**
**----------------------------------------------------------------------------**

clear


**----------------------------------------------------------------------------**
** Child Anthro 
**----------------------------------------------------------------------------**

use "$cdta/child_cleanded.dta", clear


global childage		child_age_05  child_age_623 child_age_2459

/*child_age_05 child_age_68 child_age_69 child_age_611 child_age_623 child_age_923 child_age_1215 ///
					child_age_1217 child_age_1823 child_age_2023 child_age_1223 child_age_2429 child_age_2436*/

					
preserve 

keep $childage     
gen var_name = ""
	label var var_name "   "

foreach var in mean sd count {
	gen `var' = 0
	label var `var' "`var'"
}
	
local i = 1
foreach var of global childage {
		
	local label : variable label `var'
	replace var_name = "`label'" in `i'
	
	quietly mean `var' 
	estat sd
	mat a = r(mean)
	mat b = r(sd)
	global mean = round((a[1,1]), 0.001)
	replace mean = $mean in `i'
	
	global sd = round((b[1,1]), 0.001)	
	replace sd = $sd in `i'
	
	global count = e(N)
	replace count = $count in `i'
	
	local i = `i' + 1
	
}

drop if count == 0     //get rid of extra raws
global export_table var_name mean sd count

export excel $export_table using "$out/02_wc_nca_child_sumstat.xls",  sheet("01_child_anthro_demo") firstrow(varlabels) sheetreplace 
restore					

					
**----------------------------------------------------------------------------**
**----------------------------------------------------------------------------**					

global anthro_child cwt_case cht_case haz_case ///
					haz06 haz06_female haz06_male haz06_05 haz06_05_male haz06_05_female haz06_611 haz06_611_male haz06_611_female haz06_1223 haz06_1223_male haz06_1223_female haz06_2459 haz06_2459_male haz06_2459_female ///
					stunt stunt_female stunt_male stunt_05 stunt_05_male stunt_05_female stunt_611 stunt_611_male stunt_611_female stunt_1223 stunt_1223_male stunt_1223_female stunt_2459 stunt_2459_male stunt_2459_female ///
					sev_stunt sev_stunt_female sev_stunt_male sev_stunt_05 sev_stunt_05_male sev_stunt_05_female sev_stunt_611 sev_stunt_611_male sev_stunt_611_female sev_stunt_1223 sev_stunt_1223_male sev_stunt_1223_female sev_stunt_2459 sev_stunt_2459_male sev_stunt_2459_female ///
					mod_stunt mod_stunt_female mod_stunt_male mod_stunt_05 mod_stunt_05_male mod_stunt_05_female mod_stunt_611 mod_stunt_611_male mod_stunt_611_female mod_stunt_1223 mod_stunt_1223_male mod_stunt_1223_female mod_stunt_2459 mod_stunt_2459_male mod_stunt_2459_female ///
					whz_case ///
					whz06 whz06_female whz06_male whz06_05 whz06_05_male whz06_05_female whz06_611 whz06_611_male whz06_611_female whz06_1223 whz06_1223_male whz06_1223_female whz06_2459 whz06_2459_male whz06_2459_female ///
					gam gam_female gam_male gam_05 gam_05_male gam_05_female gam_611 gam_611_male gam_611_female gam_1223 gam_1223_male gam_1223_female gam_2459 gam_2459_male gam_2459_female ///
					sam sam_female sam_male sam_05 sam_05_male sam_05_female sam_611 sam_611_male sam_611_female sam_1223 sam_1223_male sam_1223_female sam_2459 sam_2459_male sam_2459_female ///
					mam mam_female mam_male mam_05 mam_05_male mam_05_female mam_611 mam_611_male mam_611_female mam_1223 mam_1223_male mam_1223_female mam_2459 mam_2459_male mam_2459_female ///
					waz_case ///
					waz06 waz06_female waz06_male waz06_05 waz06_05_male waz06_05_female waz06_611 waz06_611_male waz06_611_female waz06_1223 waz06_1223_male waz06_1223_female waz06_2459 waz06_2459_male waz06_2459_female ///
					under_wt under_wt_female under_wt_male under_wt_05 under_wt_05_male under_wt_05_female under_wt_611 under_wt_611_male under_wt_611_female under_wt_1223 under_wt_1223_male under_wt_1223_female under_wt_2459 under_wt_2459_male under_wt_2459_female ///
					sev_under_wt sev_under_wt_female sev_under_wt_male sev_under_wt_05 sev_under_wt_05_male sev_under_wt_05_female sev_under_wt_611 sev_under_wt_611_male sev_under_wt_611_female sev_under_wt_1223 sev_under_wt_1223_male sev_under_wt_1223_female sev_under_wt_2459 sev_under_wt_2459_male sev_under_wt_2459_female ///
					mod_under_wt mod_under_wt_female mod_under_wt_male mod_under_wt_05 mod_under_wt_05_male mod_under_wt_05_female mod_under_wt_611 mod_under_wt_611_male mod_under_wt_611_female mod_under_wt_1223 mod_under_wt_1223_male mod_under_wt_1223_female mod_under_wt_2459 mod_under_wt_2459_male mod_under_wt_2459_female ///
					cmuac_case gam_muac sam_muac mam_muac
					

preserve
keep $anthro_child     
gen var_name = ""
	label var var_name "   "

foreach var in mean se lb ub count {
	gen `var' = 0
	label var `var' "`var'"
}
	
local i = 1
foreach var of global anthro_child {
		
	local label : variable label `var'
	replace var_name = "`label'" in `i'
	
	quietly mean `var'
	estat sd
	ci mean `var', level(95)
	
	mat a 	= r(mean)
	mat c	= r(se)
	mat d	= r(lb)
	mat e	= r(up)
	
	global mean 	= round(`r(mean)', 0.001)
	replace mean 	= $mean in `i'
	
	global se		= round(`r(se)', 0.001)
	replace se		= $se in `i'
	
	global lb		= round(`r(lb)', 0.001)
	replace lb		= $lb in `i'
	
	global ub		= round(`r(ub)', 0.001)
	replace ub		= $ub in `i'
	
	global count = `r(N)'
	replace count = $count in `i'
	
	local i = `i' + 1
	
}

drop if count == 0     //get rid of extra raws
global export_table var_name mean se lb ub count

export excel $export_table using "$out/02_wc_nca_child_sumstat.xls",  sheet("02_anthro") firstrow(varlabels) sheetreplace 
restore	

					
					
global anthro_child cwt_case cht_case haz_case ///
					stunt_05 stunt_05_male stunt_05_female ///
					sev_stunt_05 sev_stunt_05_male sev_stunt_05_female ///
					mod_stunt_05 mod_stunt_05_male mod_stunt_05_female ///
					gam_05 gam_05_male gam_05_female ///
					sam_05 sam_05_male sam_05_female ///
					mam_05 mam_05_male mam_05_female ///
					under_wt_05 under_wt_05_male under_wt_05_female ///
					sev_under_wt_05 sev_under_wt_05_male sev_under_wt_05_female ///
					mod_under_wt_05 mod_under_wt_05_male mod_under_wt_05_female 

					/*haz06 haz06_female haz06_male haz06_05 haz06_05_male haz06_05_female haz06_611 haz06_611_male haz06_611_female haz06_1223 haz06_1223_male haz06_1223_female haz06_2459 haz06_2459_male haz06_2459_female ///
					stunt stunt_female stunt_male stunt_05 stunt_05_male stunt_05_female stunt_611 stunt_611_male stunt_611_female stunt_1223 stunt_1223_male stunt_1223_female stunt_2459 stunt_2459_male stunt_2459_female ///
					sev_stunt sev_stunt_female sev_stunt_male sev_stunt_05 sev_stunt_05_male sev_stunt_05_female sev_stunt_611 sev_stunt_611_male sev_stunt_611_female sev_stunt_1223 sev_stunt_1223_male sev_stunt_1223_female sev_stunt_2459 sev_stunt_2459_male sev_stunt_2459_female ///
					mod_stunt mod_stunt_female mod_stunt_male mod_stunt_05 mod_stunt_05_male mod_stunt_05_female mod_stunt_611 mod_stunt_611_male mod_stunt_611_female mod_stunt_1223 mod_stunt_1223_male mod_stunt_1223_female mod_stunt_2459 mod_stunt_2459_male mod_stunt_2459_female 
*/										
//wealth_quintile

forvalue x = 1/5 {
	preserve 
	
	keep if wealth_quintile == `x'

	keep $anthro_child     
	gen var_name = ""
		label var var_name "   "

	foreach var in mean se lb ub count {
		gen `var' = 0
		label var `var' "`var'"
	}
		
	local i = 1
	foreach var of global anthro_child {
			
		local label : variable label `var'
		replace var_name = "`label'" in `i'
		
		count if !mi(`var')
		if `r(N)' > 0 {
			quietly mean `var'
			estat sd
			ci mean `var', level(95)
			
			mat a 	= r(mean)
			mat c	= r(se)
			mat d	= r(lb)
			mat e	= r(up)
			
			global mean 	= round(`r(mean)', 0.001)
			replace mean 	= $mean in `i'
			
			global se		= round(`r(se)', 0.001)
			replace se		= $se in `i'
			
			global lb		= round(`r(lb)', 0.001)
			replace lb		= $lb in `i'
			
			global ub		= round(`r(ub)', 0.001)
			replace ub		= $ub in `i'
			
			global count = `r(N)'
			replace count = $count in `i'
			}
		
		local i = `i' + 1
		
	}

	drop if mi(var_name) 
	global export_table var_name mean se lb ub count

	export excel $export_table using "$out/02_wc_nca_child_sumstat.xls",  sheet("02_anthro_haz_quan_`x'") firstrow(varlabels) sheetreplace 
	restore			
}



global anthro_child whz_case ///
					whz06 whz06_female whz06_male whz06_05 whz06_05_male whz06_05_female /*whz06_611 whz06_611_male whz06_611_female whz06_1223 whz06_1223_male whz06_1223_female whz06_2459 whz06_2459_male whz06_2459_female ///
					gam gam_female gam_male gam_05 gam_05_male gam_05_female gam_611 gam_611_male gam_611_female gam_1223 gam_1223_male gam_1223_female gam_2459 gam_2459_male gam_2459_female ///
					sam sam_female sam_male sam_05 sam_05_male sam_05_female sam_611 sam_611_male sam_611_female sam_1223 sam_1223_male sam_1223_female sam_2459 sam_2459_male sam_2459_female ///
					mam mam_female mam_male mam_05 mam_05_male mam_05_female mam_611 mam_611_male mam_611_female mam_1223 mam_1223_male mam_1223_female mam_2459 mam_2459_male mam_2459_female 
*/
//wealth_quintile

forvalue x = 1/5 {
	preserve 
	
	keep if wealth_quintile == `x'

	keep $anthro_child     
	gen var_name = ""
		label var var_name "   "

	foreach var in mean se lb ub count {
		gen `var' = 0
		label var `var' "`var'"
	}
		
	local i = 1
	foreach var of global anthro_child {
			
		local label : variable label `var'
		replace var_name = "`label'" in `i'
		
		count if !mi(`var')
		if `r(N)' > 0 {
			quietly mean `var'
			estat sd
			ci mean `var', level(95)
			
			mat a 	= r(mean)
			mat c	= r(se)
			mat d	= r(lb)
			mat e	= r(up)
			
			global mean 	= round(`r(mean)', 0.001)
			replace mean 	= $mean in `i'
			
			global se		= round(`r(se)', 0.001)
			replace se		= $se in `i'
			
			global lb		= round(`r(lb)', 0.001)
			replace lb		= $lb in `i'
			
			global ub		= round(`r(ub)', 0.001)
			replace ub		= $ub in `i'
			
			global count = `r(N)'
			replace count = $count in `i'
			}
		
		local i = `i' + 1
		
	}

	drop if mi(var_name) 
	global export_table var_name mean se lb ub count

	export excel $export_table using "$out/02_wc_nca_child_sumstat.xls",  sheet("02_anthro_whz_quan_`x'") firstrow(varlabels) sheetreplace 
	restore			
}


global anthro_child waz_case ///
					waz06 waz06_female waz06_male waz06_05 waz06_05_male waz06_05_female /*waz06_611 waz06_611_male waz06_611_female waz06_1223 waz06_1223_male waz06_1223_female waz06_2459 waz06_2459_male waz06_2459_female ///
					under_wt under_wt_female under_wt_male under_wt_05 under_wt_05_male under_wt_05_female under_wt_611 under_wt_611_male under_wt_611_female under_wt_1223 under_wt_1223_male under_wt_1223_female under_wt_2459 under_wt_2459_male under_wt_2459_female ///
					sev_under_wt sev_under_wt_female sev_under_wt_male sev_under_wt_05 sev_under_wt_05_male sev_under_wt_05_female sev_under_wt_611 sev_under_wt_611_male sev_under_wt_611_female sev_under_wt_1223 sev_under_wt_1223_male sev_under_wt_1223_female sev_under_wt_2459 sev_under_wt_2459_male sev_under_wt_2459_female ///
					mod_under_wt mod_under_wt_female mod_under_wt_male mod_under_wt_05 mod_under_wt_05_male mod_under_wt_05_female mod_under_wt_611 mod_under_wt_611_male mod_under_wt_611_female mod_under_wt_1223 mod_under_wt_1223_male mod_under_wt_1223_female mod_under_wt_2459 mod_under_wt_2459_male mod_under_wt_2459_female 
*/					
//wealth_quintile

forvalue x = 1/5 {
	preserve 
	
	keep if wealth_quintile == `x'

	keep $anthro_child     
	gen var_name = ""
		label var var_name "   "

	foreach var in mean se lb ub count {
		gen `var' = 0
		label var `var' "`var'"
	}
		
	local i = 1
	foreach var of global anthro_child {
			
		local label : variable label `var'
		replace var_name = "`label'" in `i'
		
		count if !mi(`var')
		if `r(N)' > 0 {
			quietly mean `var'
			estat sd
			ci mean `var', level(95)
			
			mat a 	= r(mean)
			mat c	= r(se)
			mat d	= r(lb)
			mat e	= r(up)
			
			global mean 	= round(`r(mean)', 0.001)
			replace mean 	= $mean in `i'
			
			global se		= round(`r(se)', 0.001)
			replace se		= $se in `i'
			
			global lb		= round(`r(lb)', 0.001)
			replace lb		= $lb in `i'
			
			global ub		= round(`r(ub)', 0.001)
			replace ub		= $ub in `i'
			
			global count = `r(N)'
			replace count = $count in `i'
			}
		
		local i = `i' + 1
		
	}

	drop if mi(var_name) 
	global export_table var_name mean se lb ub count

	export excel $export_table using "$out/02_wc_nca_child_sumstat.xls",  sheet("02_anthro_waz_quan_`x'") firstrow(varlabels) sheetreplace 
	restore			
}


global anthro_child cmuac_case gam_muac sam_muac mam_muac
					
//wealth_quintile

forvalue x = 1/5 {
	preserve 
	
	keep if wealth_quintile == `x'

	keep $anthro_child     
	gen var_name = ""
		label var var_name "   "

	foreach var in mean se lb ub count {
		gen `var' = 0
		label var `var' "`var'"
	}
		
	local i = 1
	foreach var of global anthro_child {
			
		local label : variable label `var'
		replace var_name = "`label'" in `i'
		
		count if !mi(`var')
		if `r(N)' > 0 {
			quietly mean `var'
			estat sd
			ci mean `var', level(95)
			
			mat a 	= r(mean)
			mat c	= r(se)
			mat d	= r(lb)
			mat e	= r(up)
			
			global mean 	= round(`r(mean)', 0.001)
			replace mean 	= $mean in `i'
			
			global se		= round(`r(se)', 0.001)
			replace se		= $se in `i'
			
			global lb		= round(`r(lb)', 0.001)
			replace lb		= $lb in `i'
			
			global ub		= round(`r(ub)', 0.001)
			replace ub		= $ub in `i'
			
			global count = `r(N)'
			replace count = $count in `i'
			}
		
		local i = `i' + 1
		
	}

	drop if mi(var_name) 
	global export_table var_name mean se lb ub count

	export excel $export_table using "$out/02_wc_nca_child_sumstat.xls",  sheet("02_anthro_muac_quan_`x'") firstrow(varlabels) sheetreplace 
	restore			
}

**----------------------------------------------------------------------------**

**----------------------------------------------------------------------------**
** Child Health  
**----------------------------------------------------------------------------**

global iycf		child_bf child_breastfeed_eibf child_breastfeed_ebf child_breastfeed_predobf childdiet_timely_cf childdiet_introfood child_breastfeed_cont_1yr child_breastfeed_cont_2yr ///				
				childdiet_fg_grains childdiet_fg_pulses childdiet_fg_diary childdiet_fg_meat childdiet_fg_eggs childdiet_fg_vit_vegfruit childdiet_fg_vegfruit_oth childdiet_dds childdiet_min_dds ///
				childdiet_min_mealfreq childdiet_bf_minfreq childdiet_68_bf_minfreq childdiet_923_bf_minfreq childdiet_nobf_minfreq ///
				childdiet_min_acceptdiet childdiet_bf_min_acceptdiet childdiet_nobf_min_acceptdiet childdiet_611_min_acceptdiet childdiet_1217_min_acceptdiet childdiet_1823_min_acceptdiet ///
				childdiet_iron_consum

preserve
keep $iycf     
gen var_name = ""
	label var var_name "   "

foreach var in mean se lb ub count {
	gen `var' = 0
	label var `var' "`var'"
}
	
local i = 1
foreach var of global iycf {
		
	local label : variable label `var'
	replace var_name = "`label'" in `i'
	
	quietly mean `var'
	estat sd
	ci mean `var', level(95)
	
	mat a 	= r(mean)
	mat c	= r(se)
	mat d	= r(lb)
	mat e	= r(up)
	
	global mean 	= round(`r(mean)', 0.001)
	replace mean 	= $mean in `i'
	
	global se		= round(`r(se)', 0.001)
	replace se		= $se in `i'
	
	global lb		= round(`r(lb)', 0.001)
	replace lb		= $lb in `i'
	
	global ub		= round(`r(ub)', 0.001)
	replace ub		= $ub in `i'
	
	global count = `r(N)'
	replace count = $count in `i'
	
	local i = `i' + 1
	
}

drop if count == 0     //get rid of extra raws
global export_table var_name mean se lb ub count

export excel $export_table using "$out/02_wc_nca_child_sumstat.xls",  sheet("03_iycf") firstrow(varlabels) sheetreplace 
restore	
	
//wealth_quintile

forvalue x = 1/5 {
	preserve 
	
	keep if wealth_quintile == `x'

	keep $iycf     
	gen var_name = ""
		label var var_name "   "

	foreach var in mean se lb ub count {
		gen `var' = 0
		label var `var' "`var'"
	}
		
	local i = 1
	foreach var of global iycf {
			
		local label : variable label `var'
		replace var_name = "`label'" in `i'
		
		count if !mi(`var')
		if `r(N)' > 0 {
			quietly mean `var'
			estat sd
			ci mean `var', level(95)
			
			mat a 	= r(mean)
			mat c	= r(se)
			mat d	= r(lb)
			mat e	= r(up)
			
			global mean 	= round(`r(mean)', 0.001)
			replace mean 	= $mean in `i'
			
			global se		= round(`r(se)', 0.001)
			replace se		= $se in `i'
			
			global lb		= round(`r(lb)', 0.001)
			replace lb		= $lb in `i'
			
			global ub		= round(`r(ub)', 0.001)
			replace ub		= $ub in `i'
			
			global count = `r(N)'
			replace count = $count in `i'
			}
		
		local i = `i' + 1
		
	}

	drop if mi(var_name) 
	global export_table var_name mean se lb ub count

	export excel $export_table using "$out/02_wc_nca_child_sumstat.xls",  sheet("03_iycf_quan_`x'") firstrow(varlabels) sheetreplace 
	restore			
}

**----------------------------------------------------------------------------**
**----------------------------------------------------------------------------**

global	vacin		child_vaccin_rpt child_bcg_yes_rpt child_vc_bcg_rpt child_novc_bcgd_rpt ///
					child_penta_yes_1_rpt child_vc_penta1_rpt child_novc_penta_1_rpt ///
					child_penta_yes_2_rpt child_vc_penta2_rpt child_novc_penta_2_rpt ///
					child_penta_yes_3_rpt child_vc_penta3_rpt child_novc_penta_3_rpt ///
					child_polio_yes_1_rpt child_vc_polio1_rpt child_novc_polio_1_rpt ///
					child_polio_yes_2_rpt child_vc_polio2_rpt child_novc_polio_2_rpt ///
					child_polio_yes_3_rpt child_vc_polio3_rpt child_novc_polio_3_rpt ///
					child_polioinj child_vc_polioinj child_novc_polio_inj_rpt ///
					child_measel_yes_1_rpt child_vc_measel1_rpt child_novc_measel_1_rpt ///
					child_measel_yes_2_rpt child_vc_measel2_rpt child_novc_measel_2_rpt ///
					child_rubella_yes_rpt child_vc_rubella_rpt child_novc_rubella_rpt ///
					complete_cv_rpt noimmu_cv_rpt ///
					child_birth_weight child_birth_weight_vc child_birth_weight_novc ///
					child_low_birthweight child_low_birthweight_vc child_low_birthweight_novc

preserve					
keep $vacin     
gen var_name = ""
	label var var_name "   "

foreach var in mean se lb ub count {
	gen `var' = 0
	label var `var' "`var'"
}
	
local i = 1
foreach var of global vacin {
		
	local label : variable label `var'
	replace var_name = "`label'" in `i'
	
	quietly mean `var'
	estat sd
	ci mean `var', level(95)
	
	mat a 	= r(mean)
	mat c	= r(se)
	mat d	= r(lb)
	mat e	= r(up)
	
	global mean 	= round(`r(mean)', 0.001)
	replace mean 	= $mean in `i'
	
	global se		= round(`r(se)', 0.001)
	replace se		= $se in `i'
	
	global lb		= round(`r(lb)', 0.001)
	replace lb		= $lb in `i'
	
	global ub		= round(`r(ub)', 0.001)
	replace ub		= $ub in `i'
	
	global count = `r(N)'
	replace count = $count in `i'
	
	local i = `i' + 1
	
}

drop if count == 0     //get rid of extra raws
global export_table var_name mean se lb ub count

export excel $export_table using "$out/02_wc_nca_child_sumstat.xls",  sheet("04_vacin") firstrow(varlabels) sheetreplace 
restore						

//wealth_quintile

forvalue x = 1/5 {
	preserve 
	
	keep if wealth_quintile == `x'

	keep $vacin     
	gen var_name = ""
		label var var_name "   "

	foreach var in mean se lb ub count {
		gen `var' = 0
		label var `var' "`var'"
	}
		
	local i = 1
	foreach var of global vacin {
			
		local label : variable label `var'
		replace var_name = "`label'" in `i'
		
		count if !mi(`var')
		if `r(N)' > 0 {
			quietly mean `var'
			estat sd
			ci mean `var', level(95)
			
			mat a 	= r(mean)
			mat c	= r(se)
			mat d	= r(lb)
			mat e	= r(up)
			
			global mean 	= round(`r(mean)', 0.001)
			replace mean 	= $mean in `i'
			
			global se		= round(`r(se)', 0.001)
			replace se		= $se in `i'
			
			global lb		= round(`r(lb)', 0.001)
			replace lb		= $lb in `i'
			
			global ub		= round(`r(ub)', 0.001)
			replace ub		= $ub in `i'
			
			global count = `r(N)'
			replace count = $count in `i'
			}
		
		local i = `i' + 1
		
	}

	drop if mi(var_name) 
	global export_table var_name mean se lb ub count

	export excel $export_table using "$out/02_wc_nca_child_sumstat.xls",  sheet("04_vacin_quan_`x'") firstrow(varlabels) sheetreplace 
	restore			
}

					
**----------------------------------------------------------------------------**
**----------------------------------------------------------------------------**
// CHILD ILLNESS

global diar1	child_ill_yes child_ill_treat child_ill_hp ///
				child_ill_diarrhea child_diarrh_treat child_diarrh_hp child_diarrh_pay child_diarrh_amount child_diarrh_loan child_diarrh_still ///
				child_diarrh_treat_hosp child_diarrh_treat_station child_diarrh_treat_rhc child_diarrh_treat_srhc child_diarrh_treat_doctor child_diarrh_treat_eho child_diarrh_treat_ngo ///		
				child_diarrh_treat_chw child_diarrh_treat_healer child_diarrh_treat_quack child_diarrh_treat_shop child_diarrh_treat_family child_diarrh_treat_amw child_diarrh_treat_oth 
				
global diar2	child_diarrh_else_no child_diarrh_else_hosp child_diarrh_else_station child_diarrh_else_rhc child_diarrh_else_srhc child_diarrh_else_doctor child_diarrh_else_eho child_diarrh_else_ngo ///
				child_diarrh_else_chw child_diarrh_else_healer child_diarrh_else_quack child_diarrh_else_shop child_diarrh_else_family child_diarrh_else_amw child_diarrh_else_othc ///
				child_diarrh_notx_hfno child_diarrh_notx_hffar child_diarrh_notx_hfacc child_diarrh_notx_exp child_diarrh_notx_nobl child_diarrh_notx_askno child_diarrh_notx_alter child_diarrh_notx_dk child_diarrh_notx_oth
				
global cough1	child_ill_cough child_cough_treat child_cough_hp child_cough_pay child_cough_amount child_cough_loan child_cough_still ///
				child_cough_treat_hosp child_cough_treat_station child_cough_treat_rhc child_cough_treat_srhc child_cough_treat_doctor child_cough_treat_eho child_cough_treat_ngo ///								
				child_cough_treat_chw child_cough_treat_healer child_cough_treat_quack child_cough_treat_shop child_cough_treat_family child_cough_treat_amw child_cough_treat_oth 
				
global cough2	child_cough_else_no child_cough_else_hosp child_cough_else_station child_cough_else_rhc child_cough_else_srhc child_cough_else_doctor child_cough_else_eho child_cough_else_ngo ///									
				child_cough_else_chw child_cough_else_healer child_cough_else_quack child_cough_else_shop child_cough_else_family child_cough_else_amw child_cough_else_othc ///
				child_cough_notx_hfno child_cough_notx_hffar child_cough_notx_hfacc child_cough_notx_exp child_cough_notx_nobl child_cough_notx_askno child_cough_notx_alter child_cough_notx_dk child_cough_notx_oth
				
global fever1	child_ill_fever child_fever_treat child_fever_hp child_fever_pay child_fever_amount child_fever_loan child_fever_still child_fever_malaria ///
				child_fever_treat_hosp child_fever_treat_station child_fever_treat_rhc child_fever_treat_srhc child_fever_treat_doctor child_fever_treat_eho child_fever_treat_ngo ///
				child_fever_treat_chw child_fever_treat_healer child_fever_treat_quack child_fever_treat_shop child_fever_treat_family child_fever_treat_amw child_fever_treat_oth 
				
global fever2	child_fever_else_no child_fever_else_hosp child_fever_else_station child_fever_else_rhc child_fever_else_srhc child_fever_else_doctor child_fever_else_eho child_fever_else_ngo ///
				child_fever_else_chw child_fever_else_healer child_fever_else_quack child_fever_else_shop child_fever_else_family child_fever_else_amw child_fever_else_othc ///
				child_fever_notx_hfno child_fever_notx_hffar child_fever_notx_hfacc child_fever_notx_exp child_fever_notx_nobl child_fever_notx_askno child_fever_notx_alter child_fever_notx_dk child_fever_notx_oth ///
				child_ill_other

				
local global diar1 diar2 cough1 cough2 fever1 fever2

foreach anc in `global' {
		preserve 
		
		keep $`anc'     
		gen var_name = ""
			label var var_name "   "

		foreach var in mean se lb ub count {
			gen `var' = 0
			label var `var' "`var'"
		}
		
		
		
		local i = 1
		foreach var of global `anc' {
				
		local label : variable label `var'
		replace var_name = "`label'" in `i'
		
		count if !mi(`var')
		if `r(N)' > 0 {
			quietly mean `var'
			estat sd
			ci mean `var', level(95)
			
			mat a 	= r(mean)
			mat c	= r(se)
			mat d	= r(lb)
			mat e	= r(up)
			
			global mean 	= round(`r(mean)', 0.001)
			replace mean 	= $mean in `i'
			
			global se		= round(`r(se)', 0.001)
			replace se		= $se in `i'
			
			global lb		= round(`r(lb)', 0.001)
			replace lb		= $lb in `i'
			
			global ub		= round(`r(ub)', 0.001)
			replace ub		= $ub in `i'
			
			global count = `r(N)'
			replace count = $count in `i'
			}
		
		local i = `i' + 1
		
	}

	drop if mi(var_name) 
	global export_table var_name mean se lb ub count

		export excel $export_table using "$out/02_wc_nca_child_sumstat.xls",  sheet("05_`anc'") firstrow(varlabels) sheetreplace 
		restore			
}

/*
preserve				
keep $illness     
gen var_name = ""
	label var var_name "   "

foreach var in mean se lb ub count {
	gen `var' = 0
	label var `var' "`var'"
}
	
local i = 1
foreach var of global illness {
		
	local label : variable label `var'
	replace var_name = "`label'" in `i'
	
	quietly mean `var'
	estat sd
	ci mean `var', level(95)
	
	mat a 	= r(mean)
	mat c	= r(se)
	mat d	= r(lb)
	mat e	= r(up)
	
	global mean 	= round(`r(mean)', 0.001)
	replace mean 	= $mean in `i'
	
	global se		= round(`r(se)', 0.001)
	replace se		= $se in `i'
	
	global lb		= round(`r(lb)', 0.001)
	replace lb		= $lb in `i'
	
	global ub		= round(`r(ub)', 0.001)
	replace ub		= $ub in `i'
	
	global count = `r(N)'
	replace count = $count in `i'
	
	local i = `i' + 1
	
}

drop if count == 0     //get rid of extra raws
global export_table var_name mean se lb ub count

export excel $export_table using "$out/02_wc_nca_child_sumstat.xls",  sheet("05_ill") firstrow(varlabels) sheetreplace 
restore	
*/


//wealth_quintile
local global diar1 diar2 cough1 cough2 fever1 fever2

foreach anc in `global' {
	forvalue x = 1/5 {
		preserve 
		
		keep if wealth_quintile == `x'

		keep $`anc'     
		gen var_name = ""
			label var var_name "   "

		foreach var in mean se lb ub count {
			gen `var' = 0
			label var `var' "`var'"
		}
		
		
		
		local i = 1
		foreach var of global `anc' {
				
		local label : variable label `var'
		replace var_name = "`label'" in `i'
		
		count if !mi(`var')
		if `r(N)' > 0 {
			quietly mean `var'
			estat sd
			ci mean `var', level(95)
			
			mat a 	= r(mean)
			mat c	= r(se)
			mat d	= r(lb)
			mat e	= r(up)
			
			global mean 	= round(`r(mean)', 0.001)
			replace mean 	= $mean in `i'
			
			global se		= round(`r(se)', 0.001)
			replace se		= $se in `i'
			
			global lb		= round(`r(lb)', 0.001)
			replace lb		= $lb in `i'
			
			global ub		= round(`r(ub)', 0.001)
			replace ub		= $ub in `i'
			
			global count = `r(N)'
			replace count = $count in `i'
			}
		
		local i = `i' + 1
		
	}

	drop if mi(var_name) 
	global export_table var_name mean se lb ub count

		export excel $export_table using "$out/02_wc_nca_child_sumstat.xls",  sheet("05_`anc'_quan_`x'") firstrow(varlabels) sheetreplace 
		restore			
	}
}


**----------------------------------------------------------------------------**
**----------------------------------------------------------------------------**
**----------------------------------------------------------------------------**
**----------------------------------------------------------------------------**

clear


**----------------------------------------------------------------------------**
** Mother Health Dataset 
**----------------------------------------------------------------------------**

use "$cdta/mom_health_cleanded.dta", clear

global anchp		ancpast_yn ///
					ancpast_spelist ancpast_doc ancpast_nurs ancpast_ha ancpast_pdoc ancpast_lhv ancpast_mw ancpast_amw ancpast_tba ancpast_chw ancpast_ehw ancpast_oth ///
					ancpast_trained ancpast_trained_freq ancpast_trained_freq1 ancpast_trained_freq2 ancpast_trained_freq3 ancpast_trained_freq4 ///
					
					
global anchp2		ancpast_spelist_home ancpast_spelist_hosp ancpast_spelist_clinic ancpast_spelist_rhc ancpast_spelist_vill ancpast_spelist_eho ancpast_spelist_othplc ///
					ancpast_spelist_visit ///
					ancpast_doc_home ancpast_doc_hosp ancpast_doc_clinic ancpast_doc_rhc ancpast_doc_vill ancpast_doc_eho ancpast_doc_othplc ///
					ancpast_doc_visit ///
					ancpast_nurs_home ancpast_nurs_hosp ancpast_nurs_clinic ancpast_nurs_rhc ancpast_nurs_vill ancpast_nurs_eho ancpast_nurs_othplc ///
					ancpast_nurs_visit 
					
global anchp3		ancpast_ha_home ancpast_ha_hosp ancpast_ha_clinic ancpast_ha_rhc ancpast_ha_vill ancpast_ha_eho ancpast_ha_othplc ///
					ancpast_ha_visit ///
					ancpast_pdoc_home ancpast_pdoc_hosp ancpast_pdoc_clinic ancpast_pdoc_rhc ancpast_pdoc_vill ancpast_pdoc_eho ancpast_pdoc_othplc ///
					ancpast_pdoc_visit ///
					ancpast_lhv_home ancpast_lhv_hosp ancpast_lhv_clinic ancpast_lhv_rhc ancpast_lhv_vill ancpast_lhv_eho ancpast_lhv_othplc ///
					ancpast_lhv_visit 
					
global anchp4		ancpast_mw_home ancpast_mw_hosp ancpast_mw_clinic ancpast_mw_rhc ancpast_mw_vill ancpast_mw_eho ancpast_mw_othplc ///
					ancpast_mw_visit ///
					ancpast_ehw_home ancpast_ehw_hosp ancpast_ehw_clinic ancpast_ehw_rhc ancpast_ehw_vill ancpast_ehw_eho ancpast_ehw_othplc ///
					ancpast_ehw_visit 

					
global ancnhp		ancpast_amw_home ancpast_amw_hosp ancpast_amw_clinic ancpast_amw_rhc ancpast_amw_vill ancpast_amw_eho ancpast_amw_othplc ///
					ancpast_amw_visit ///
					ancpast_tba_home ancpast_tba_hosp ancpast_tba_clinic ancpast_tba_rhc ancpast_tba_vill ancpast_tba_eho ancpast_tba_othplc ///
					ancpast_tba_visit 
					
global ancnhp2		ancpast_chw_home ancpast_chw_hosp ancpast_chw_clinic ancpast_chw_rhc ancpast_chw_vill ancpast_chw_eho ancpast_chw_othplc ///
					ancpast_chw_visit ///
					ancpast_oth_home ancpast_oth_hosp ancpast_oth_clinic ancpast_oth_rhc ancpast_oth_vill ancpast_oth_eho ancpast_oth_othplc ///
					ancpast_oth_visit 
					
global anccost		ancpast_cost ancpast_amount ancpast_cost_ta ancpast_cost_reg ancpast_cost_drug ancpast_cost_lab ancpast_cost_consult ancpast_cost_gift ancpast_cost_oth ancpast_borrow ///
					ancpast_no_important ancpast_no_distance ancpast_no_restrict ancpast_no_accompany ancpast_no_hf ancpast_no_staff ancpast_no_finance ancpast_no_oth 
					
global anccost2		ancpast_restrict ancpast_restrict_veg ancpast_restrict_fruit ancpast_restrict_grain ancpast_restrict_meat ancpast_restrict_fish ancpast_restrict_diary ancpast_restrict_oth /// 		
					ancpast_bone ///
					ancpast_rion ancpast_iron_consum ancpast_iron_cost ancpast_iron_amount ///
					ancpast_iron_hosp ancpast_iron_eho ancpast_iron_pdoc ancpast_iron_rhc ancpast_iron_vill ancpast_iron_oth 

//wealth_quintile
local global anchp anchp2 anchp3 anchp4 ancnhp ancnhp2 anccost anccost2

foreach anc in `global' {
		preserve 
		
		keep $`anc'     
		gen var_name = ""
			label var var_name "   "

		foreach var in mean se lb ub count {
			gen `var' = 0
			label var `var' "`var'"
		}
		
		
		
		local i = 1
		foreach var of global `anc' {
				
		local label : variable label `var'
		replace var_name = "`label'" in `i'
		
		count if !mi(`var')
		if `r(N)' > 0 {
			quietly mean `var'
			estat sd
			ci mean `var', level(95)
			
			mat a 	= r(mean)
			mat c	= r(se)
			mat d	= r(lb)
			mat e	= r(up)
			
			global mean 	= round(`r(mean)', 0.001)
			replace mean 	= $mean in `i'
			
			global se		= round(`r(se)', 0.001)
			replace se		= $se in `i'
			
			global lb		= round(`r(lb)', 0.001)
			replace lb		= $lb in `i'
			
			global ub		= round(`r(ub)', 0.001)
			replace ub		= $ub in `i'
			
			global count = `r(N)'
			replace count = $count in `i'
			}
		
		local i = `i' + 1
		
	}

	drop if mi(var_name) 
	global export_table var_name mean se lb ub count

		export excel $export_table using "$out/03_wc_anc_mom_sumstat.xls",  sheet("01_`anc'") firstrow(varlabels) sheetreplace 
		restore			
}

/*					
preserve				
keep $anc     
gen var_name = ""
	label var var_name "   "

foreach var in mean se lb ub count {
	gen `var' = 0
	label var `var' "`var'"
}
	
local i = 1
foreach var of global anc {
		
	local label : variable label `var'
	replace var_name = "`label'" in `i'
	
	count if !mi(`var')
	if `r(N)' > 0 {
		quietly mean `var'
		estat sd
		ci mean `var', level(95)
		
		mat a 	= r(mean)
		mat c	= r(se)
		mat d	= r(lb)
		mat e	= r(up)
		
		global mean 	= round(`r(mean)', 0.001)
		replace mean 	= $mean in `i'
		
		global se		= round(`r(se)', 0.001)
		replace se		= $se in `i'
		
		global lb		= round(`r(lb)', 0.001)
		replace lb		= $lb in `i'
		
		global ub		= round(`r(ub)', 0.001)
		replace ub		= $ub in `i'
		
		global count = `r(N)'
		replace count = $count in `i'
	}
	
	local i = `i' + 1
	
}

drop if count == 0     //get rid of extra raws
global export_table var_name mean se lb ub count

export excel $export_table using "$out/03_wc_anc_mom_sumstat.xls",  sheet("01_anc") firstrow(varlabels) sheetreplace 
restore						
*/


//wealth_quintile
local global anchp anchp2 anchp3 anchp4 ancnhp ancnhp2 anccost anccost2

foreach anc in `global' {
	forvalue x = 1/5 {
		preserve 
		
		keep if wealth_quintile == `x'

		keep $`anc'     
		gen var_name = ""
			label var var_name "   "

		foreach var in mean se lb ub count {
			gen `var' = 0
			label var `var' "`var'"
		}
		
		
		
		local i = 1
		foreach var of global `anc' {
				
		local label : variable label `var'
		replace var_name = "`label'" in `i'
		
		count if !mi(`var')
		if `r(N)' > 0 {
			quietly mean `var'
			estat sd
			ci mean `var', level(95)
			
			mat a 	= r(mean)
			mat c	= r(se)
			mat d	= r(lb)
			mat e	= r(up)
			
			global mean 	= round(`r(mean)', 0.001)
			replace mean 	= $mean in `i'
			
			global se		= round(`r(se)', 0.001)
			replace se		= $se in `i'
			
			global lb		= round(`r(lb)', 0.001)
			replace lb		= $lb in `i'
			
			global ub		= round(`r(ub)', 0.001)
			replace ub		= $ub in `i'
			
			global count = `r(N)'
			replace count = $count in `i'
			}
		
		local i = `i' + 1
		
	}

	drop if mi(var_name) 
	global export_table var_name mean se lb ub count

		export excel $export_table using "$out/03_wc_anc_mom_sumstat.xls",  sheet("01_`anc'_quan_`x'") firstrow(varlabels) sheetreplace 
		restore			
	}
}


**----------------------------------------------------------------------------**
**----------------------------------------------------------------------------**

global delivery		deliv_place_home deliv_place_hosp deliv_place_pdoc deliv_place_rhc deliv_place_eho deliv_place_placoth ///
					deliv_place_conve deliv_place_trad deliv_place_dist deliv_place_safe deliv_place_cost deliv_place_whyoth ///
					deliv_assist_doc deliv_assist_nurs deliv_assist_lhv deliv_assist_mw deliv_assist_amw deliv_assist_tba deliv_assist_own deliv_assist_hhmem deliv_assist_eho deliv_assist_whooth ///
					deliv_trained deliv_institute ///
					deliv_cost deliv_cost_amount deliv_cost_loan 

preserve				
keep $delivery     
gen var_name = ""
	label var var_name "   "

foreach var in mean se lb ub count {
	gen `var' = 0
	label var `var' "`var'"
}
	
local i = 1
foreach var of global delivery {
		
	local label : variable label `var'
	replace var_name = "`label'" in `i'
	
	quietly mean `var'
	estat sd
	ci mean `var', level(95)
	
	mat a 	= r(mean)
	mat c	= r(se)
	mat d	= r(lb)
	mat e	= r(up)
	
	global mean 	= round(`r(mean)', 0.001)
	replace mean 	= $mean in `i'
	
	global se		= round(`r(se)', 0.001)
	replace se		= $se in `i'
	
	global lb		= round(`r(lb)', 0.001)
	replace lb		= $lb in `i'
	
	global ub		= round(`r(ub)', 0.001)
	replace ub		= $ub in `i'
	
	global count = `r(N)'
	replace count = $count in `i'
	
	local i = `i' + 1
	
}

drop if count == 0     //get rid of extra raws
global export_table var_name mean se lb ub count

export excel $export_table using "$out/03_wc_anc_mom_sumstat.xls",  sheet("02_deli") firstrow(varlabels) sheetreplace 
restore						


global deli			deliv_place_home deliv_place_hosp deliv_place_pdoc deliv_place_rhc deliv_place_eho deliv_place_placoth ///
					deliv_place_conve deliv_place_trad deliv_place_dist deliv_place_safe deliv_place_cost deliv_place_whyoth 

global deli2		deliv_assist_doc deliv_assist_nurs deliv_assist_lhv deliv_assist_mw deliv_assist_amw deliv_assist_tba deliv_assist_own deliv_assist_hhmem deliv_assist_eho deliv_assist_whooth ///
					deliv_trained deliv_institute ///
					deliv_cost deliv_cost_amount deliv_cost_loan 

//wealth_quintile
local global deli deli2

foreach anc in `global' {
	forvalue x = 1/5 {
		preserve 
		
		keep if wealth_quintile == `x'

		keep $`anc'     
		gen var_name = ""
			label var var_name "   "

		foreach var in mean se lb ub count {
			gen `var' = 0
			label var `var' "`var'"
		}
		
		
		
		local i = 1
		foreach var of global `anc' {
				
		local label : variable label `var'
		replace var_name = "`label'" in `i'
		
		count if !mi(`var')
		if `r(N)' > 0 {
			quietly mean `var'
			estat sd
			ci mean `var', level(95)
			
			mat a 	= r(mean)
			mat c	= r(se)
			mat d	= r(lb)
			mat e	= r(up)
			
			global mean 	= round(`r(mean)', 0.001)
			replace mean 	= $mean in `i'
			
			global se		= round(`r(se)', 0.001)
			replace se		= $se in `i'
			
			global lb		= round(`r(lb)', 0.001)
			replace lb		= $lb in `i'
			
			global ub		= round(`r(ub)', 0.001)
			replace ub		= $ub in `i'
			
			global count = `r(N)'
			replace count = $count in `i'
			}
		
		local i = `i' + 1
		
	}

	drop if mi(var_name) 
	global export_table var_name mean se lb ub count

		export excel $export_table using "$out/03_wc_anc_mom_sumstat.xls",  sheet("02_`anc'_quan_`x'") firstrow(varlabels) sheetreplace 
		restore			
	}
}

**----------------------------------------------------------------------------**
**----------------------------------------------------------------------------**
					
global pnc 	pnc_yn pnc_yes_6wks ///
			pnc_doc_rpt pnc_nurs_rpt pnc_lhv_rpt pnc_mw_rpt pnc_amw_rpt pnc_tba_rpt pnc_relative_rpt pnc_eho_rpt ///
			pnc_doc_freq_rpt pnc_nurs_freq_rpt pnc_lhv_freq_rpt pnc_mw_freq_rpt pnc_amw_freq_rpt pnc_tba_freq_rpt pnc_relative_freq_rpt  pnc_eho_freq_rpt 
			
global pnc2 pnc_trained pnc_bone ///
			pnc_cost_rpt pnc_cost_amount_rpt ///
			pnc_cost_ta_rpt pnc_cost_reg_rpt pnc_cost_drug_rpt pnc_cost_lab_rpt pnc_cost_consult_rpt pnc_cost_gift_rpt pnc_cost_oth_rpt pnc_cost_loan_rpt


			
local global pnc pnc2

foreach anc in `global' {
		preserve 
		
		keep $`anc'     
		gen var_name = ""
			label var var_name "   "

		foreach var in mean se lb ub count {
			gen `var' = 0
			label var `var' "`var'"
		}
		
		
		
		local i = 1
		foreach var of global `anc' {
				
		local label : variable label `var'
		replace var_name = "`label'" in `i'
		
		count if !mi(`var')
		if `r(N)' > 0 {
			quietly mean `var'
			estat sd
			ci mean `var', level(95)
			
			mat a 	= r(mean)
			mat c	= r(se)
			mat d	= r(lb)
			mat e	= r(up)
			
			global mean 	= round(`r(mean)', 0.001)
			replace mean 	= $mean in `i'
			
			global se		= round(`r(se)', 0.001)
			replace se		= $se in `i'
			
			global lb		= round(`r(lb)', 0.001)
			replace lb		= $lb in `i'
			
			global ub		= round(`r(ub)', 0.001)
			replace ub		= $ub in `i'
			
			global count = `r(N)'
			replace count = $count in `i'
			}
		
		local i = `i' + 1
		
	}

	drop if mi(var_name) 
	global export_table var_name mean se lb ub count

		export excel $export_table using "$out/03_wc_anc_mom_sumstat.xls",  sheet("03_`anc'") firstrow(varlabels) sheetreplace 
		restore			
}


//wealth_quintile
local global pnc pnc2

foreach anc in `global' {
	forvalue x = 1/5 {
		preserve 
		
		keep if wealth_quintile == `x'

		keep $`anc'     
		gen var_name = ""
			label var var_name "   "

		foreach var in mean se lb ub count {
			gen `var' = 0
			label var `var' "`var'"
		}
		
		
		
		local i = 1
		foreach var of global `anc' {
				
		local label : variable label `var'
		replace var_name = "`label'" in `i'
		
		count if !mi(`var')
		if `r(N)' > 0 {
			quietly mean `var'
			estat sd
			ci mean `var', level(95)
			
			mat a 	= r(mean)
			mat c	= r(se)
			mat d	= r(lb)
			mat e	= r(up)
			
			global mean 	= round(`r(mean)', 0.001)
			replace mean 	= $mean in `i'
			
			global se		= round(`r(se)', 0.001)
			replace se		= $se in `i'
			
			global lb		= round(`r(lb)', 0.001)
			replace lb		= $lb in `i'
			
			global ub		= round(`r(ub)', 0.001)
			replace ub		= $ub in `i'
			
			global count = `r(N)'
			replace count = $count in `i'
			}
		
		local i = `i' + 1
		
	}

	drop if mi(var_name) 
	global export_table var_name mean se lb ub count

		export excel $export_table using "$out/03_wc_anc_mom_sumstat.xls",  sheet("03_`anc'_quan_`x'") firstrow(varlabels) sheetreplace 
		restore			
	}
}

**----------------------------------------------------------------------------**
**----------------------------------------------------------------------------**
			
global nbc		nbc_yn nbc_2days_yn ///
				nbc_doc nbc_nurs nbc_lhv nbc_mw nbc_amw nbc_tba nbc_relative nbc_eho ///
				nbc_doc_freq nbc_nurs_freq nbc_lhv_freq nbc_mw_freq nbc_amw_freq nbc_tba_freq nbc_relative_freq nbc_eho_freq ///
				
global nbc2		nbc_2days_trained ///
				nbc_cost nbc_cost_amount nbc_cost_ta nbc_cost_reg nbc_cost_drug nbc_cost_lab nbc_cost_consult nbc_cost_gift nbc_cost_oth ///
				nbc_cost_loan 


			
local global nbc nbc2


foreach anc in `global' {
		preserve 
		
		keep $`anc'     
		gen var_name = ""
			label var var_name "   "

		foreach var in mean se lb ub count {
			gen `var' = 0
			label var `var' "`var'"
		}
		
		
		
		local i = 1
		foreach var of global `anc' {
				
		local label : variable label `var'
		replace var_name = "`label'" in `i'
		
		count if !mi(`var')
		if `r(N)' > 0 {
			quietly mean `var'
			estat sd
			ci mean `var', level(95)
			
			mat a 	= r(mean)
			mat c	= r(se)
			mat d	= r(lb)
			mat e	= r(up)
			
			global mean 	= round(`r(mean)', 0.001)
			replace mean 	= $mean in `i'
			
			global se		= round(`r(se)', 0.001)
			replace se		= $se in `i'
			
			global lb		= round(`r(lb)', 0.001)
			replace lb		= $lb in `i'
			
			global ub		= round(`r(ub)', 0.001)
			replace ub		= $ub in `i'
			
			global count = `r(N)'
			replace count = $count in `i'
			}
		
		local i = `i' + 1
		
	}

	drop if mi(var_name) 
	global export_table var_name mean se lb ub count

		export excel $export_table using "$out/03_wc_anc_mom_sumstat.xls",  sheet("04_`anc'") firstrow(varlabels) sheetreplace 
		restore			
}


//wealth_quintile
local global nbc nbc2

foreach anc in `global' {
	forvalue x = 1/5 {
		preserve 
		
		keep if wealth_quintile == `x'

		keep $`anc'     
		gen var_name = ""
			label var var_name "   "

		foreach var in mean se lb ub count {
			gen `var' = 0
			label var `var' "`var'"
		}
		
		
		
		local i = 1
		foreach var of global `anc' {
				
		local label : variable label `var'
		replace var_name = "`label'" in `i'
		
		count if !mi(`var')
		if `r(N)' > 0 {
			quietly mean `var'
			estat sd
			ci mean `var', level(95)
			
			mat a 	= r(mean)
			mat c	= r(se)
			mat d	= r(lb)
			mat e	= r(up)
			
			global mean 	= round(`r(mean)', 0.001)
			replace mean 	= $mean in `i'
			
			global se		= round(`r(se)', 0.001)
			replace se		= $se in `i'
			
			global lb		= round(`r(lb)', 0.001)
			replace lb		= $lb in `i'
			
			global ub		= round(`r(ub)', 0.001)
			replace ub		= $ub in `i'
			
			global count = `r(N)'
			replace count = $count in `i'
			}
		
		local i = `i' + 1
		
	}

	drop if mi(var_name) 
	global export_table var_name mean se lb ub count

		export excel $export_table using "$out/03_wc_anc_mom_sumstat.xls",  sheet("04_`anc'_quan_`x'") firstrow(varlabels) sheetreplace 
		restore			
	}
}

