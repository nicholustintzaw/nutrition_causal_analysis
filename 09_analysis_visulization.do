/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PROJECT:		CPI - CHDN Nutrition Security Report

PURPOSE: 		Visulization

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

drop if geo_state == "MMR003"

tab will_participate geo_rural, chi2

global geo	urban rural eho




**----------------------------------------------------------------------------**
**----------------------------------------------------------------------------**

global ppi	national_povt_line ///
			wealth_poorest wealth_poor wealth_medium wealth_wealthy wealth_wealthiest

tab geo_rural wealth_quintile, chi2

graph box national_povt_line, over(geo_rural,label(labsize(vsmall))) ///
				legend(rows(1)) xsize(3) ysize(2) ///
				title(Poverty Probability Index by location, size(vsmall)) nolabel ///
				legend(size(vsmall)) nofill ///
				ytitle(PPI Score, size(vsmall)) ///
				ylabel(,labsize(vsmall)) 
graph export "$out/_pic/01_ppi_geo.png", replace
			
**----------------------------------------------------------------------------**
**----------------------------------------------------------------------------**
global control	wealth_poorest wealth_poor wealth_medium wealth_wealthy wealth_wealthiest

global ddsw		momdiet_ddsw momdiet_min_ddsw ///
				mom_meal_freq

graph bar		momdiet_min_ddsw, ///
				over(wealth_quintile,label(labsize(vsmall))) ///
				legend(rows(1)) xsize(3) ysize(2) ///
				legend(size(vsmall)) nofill ///
				ytitle(% of hosehold , size(vsmall)) ///
				ylabel(,labsize(vsmall))
graph export "$out/_pic/08_mddw_walth.png", replace


tab mom_meal_freq geo_rural , chi2


**----------------------------------------------------------------------------**
**----------------------------------------------------------------------------**
	
	
global fcs	fcs_score fcs_acceptable fcs_borderline fcs_poor 

tab fcs_poor geo_rural , chi2
tab fcs_borderline geo_rural , chi2
tab fcs_acceptable geo_rural , chi2


tab fcs_poor  wealth_quintile, chi2
tab fcs_borderline  wealth_quintile, chi2
tab fcs_acceptable  wealth_quintile, chi2
graph bar		fcs_acceptable fcs_borderline fcs_poor , ///
				by(wealth_quintile) ///
				legend(rows(1)) xsize(3) ysize(2) ///
				legend(size(vsmall) order(1 "Acceptable" 2 "Bordaline" 3 "Poor")) nofill ///
				ytitle(% of hosehold , size(vsmall)) ///
				ylabel(,labsize(vsmall))
graph export "$out/_pic/07_fcs_walth.png", replace

					

**----------------------------------------------------------------------------**
**----------------------------------------------------------------------------**


global csi	csi_score lcis_secure lcis_stress lcis_crisis lcis_emergency 

graph bar		lcis_secure lcis_stress lcis_crisis lcis_emergency , ///
				by(wealth_quintile) ///
				legend(rows(1)) xsize(3) ysize(2) ///
				legend(size(vsmall) order(1 "secure" 2 "stress" 3 "crisis" 4 "emergency")) nofill ///
				ytitle(% of hosehold , size(vsmall)) ///
				ylabel(,labsize(vsmall))
graph export "$out/_pic/06_lcsi_walth.png", replace


tab lcis_secure geo_rural , chi2
tab lcis_stress geo_rural , chi2
tab lcis_crisis geo_rural , chi2 row

tab lcis_secure wealth_quintile , chi2
tab lcis_stress wealth_quintile , chi2
tab lcis_crisis wealth_quintile , chi2 row

**----------------------------------------------------------------------------**
**----------------------------------------------------------------------------**

global wash		water_sum_limited water_sum_unimprove water_sum_surface ///
				water_rain_limited water_rain_unimprove water_rain_surface ///
 				water_winter_limited water_winter_unimprove water_winter_surface ///
				water_sum_treat_yes water_rain_treat_yes water_winter_treat_yes ///
				latrine_ladder latrine_basic latrine_limited latrine_unimprove latrine_opendef ///
				handwash_ladder handwash_basic handwash_limited handwash_no  
	

foreach var of varlist $wash {
	tab geo_rural `var', chi2

	tab wealth_quintile `var', chi2
}


 ///
				


graph bar	water_sum_limited water_sum_unimprove water_sum_surface ///
				water_rain_limited water_rain_unimprove water_rain_surface ///
 				water_winter_limited water_winter_unimprove water_winter_surface, ///
				by(wealth_quintile)  ///
				/*blabel(total, format(%9.1f) size(vsmall))*/ ///
				legend(rows(3)) xsize(3) ysize(2) ///
				legend(size(vsmall) order(1 "summer - limited" 2 "summer - unimproved" 3 "summer - surface water" ///
				4 "raining - limited" 5 "raining - unimproved" 6 "raining - surface water" ///
				7 "winter - limited" 8 "winter - unimproved" 9 "winter - surface water")) nofill ///
				ytitle(% of hosehold , size(vsmall)) ///
				ylabel(,labsize(vsmall))
graph export "$out/_pic/02_water_walth.png", replace

graph bar		water_sum_treat_yes water_rain_treat_yes water_winter_treat_yes, ///
				by(wealth_quintile) ///
				/*blabel(total, format(%9.1f) size(vsmall))*/ ///
				legend(rows(1)) xsize(3) ysize(2) ///
				legend(size(vsmall) order(1 "summer - treatment" 2 "summer - treatment" 3 "summer - treatment")) nofill ///
				ytitle(% of hosehold , size(vsmall)) ///
				ylabel(,labsize(vsmall))
graph export "$out/_pic/03_water_treat_walth.png", replace


tab geo_rural latrine_basic, chi2
tab geo_rural latrine_ladder if geo_rural != 1, chi2
tab geo_rural latrine_basic if geo_rural != 1, chi2
tab geo_rural latrine_limited if geo_rural != 1, chi2
tab geo_rural latrine_unimprove if geo_rural != 1, chi2 row
tab geo_rural latrine_opendef if geo_rural != 1, chi2 row


graph bar		latrine_basic latrine_limited latrine_unimprove latrine_opendef, ///
				by(wealth_quintile) ///
				legend(rows(1)) xsize(3) ysize(2) ///
				legend(size(vsmall) order(1 "Basic" 2 "Limited" 3 "Unimproved" 4 "Open Defecation")) nofill ///
				ytitle(% of hosehold , size(vsmall)) ///
				ylabel(,labsize(vsmall))
graph export "$out/_pic/04_Latrine_walth.png", replace


tab geo_rural handwash_ladder, chi2
						

graph bar		handwash_basic handwash_limited handwash_no, ///
				by(wealth_quintile) ///
				legend(rows(1)) xsize(3) ysize(2) ///
				legend(size(vsmall) order(1 "Basic" 2 "Limited" 3 "No facility")) nofill ///
				ytitle(% of hosehold , size(vsmall)) ///
				ylabel(,labsize(vsmall))
graph export "$out/_pic/05_handwash_walth.png", replace

						
**----------------------------------------------------------------------------**
**----------------------------------------------------------------------------**
**----------------------------------------------------------------------------**
**----------------------------------------------------------------------------**



**----------------------------------------------------------------------------**
** Child Anthro Dataset 
**----------------------------------------------------------------------------**

use "$cdta/child_anthro_cleanded.dta", clear

gen child_age_anthro 		= 1 if child_age_611 == 1 
replace child_age_anthro 	= 2 if child_age_1223 == 1 
replace child_age_anthro 	= 3 if child_age_2459 ==1
tab child_age_anthro, m


drop if geo_state == "MMR003"


global anthro_haz	haz06 haz06_female haz06_male haz06_611 haz06_1223 haz06_2459 ///
					stunt stunt_female stunt_male stunt_611 stunt_1223 stunt_2459 ///
					sev_stunt sev_stunt_female sev_stunt_male sev_stunt_611 sev_stunt_1223 sev_stunt_2459 ///
					mod_stunt mod_stunt_female mod_stunt_male mod_stunt_611 mod_stunt_1223 mod_stunt_2459 ///
					whz06 whz06_female whz06_male whz06_611 whz06_1223 whz06_2459 ///
					gam gam_female gam_male gam_611 gam_1223 gam_2459 ///
					sam sam_female sam_male sam_611 sam_1223 sam_2459 ///
					mam mam_female mam_male mam_611 mam_1223 mam_2459 ///
					waz06 waz06_female waz06_male waz06_611 waz06_1223 waz06_2459 ///
					under_wt under_wt_female under_wt_male under_wt_611 under_wt_1223 under_wt_2459 ///
					sev_under_wt sev_under_wt_female sev_under_wt_male sev_under_wt_611 sev_under_wt_1223 sev_under_wt_2459 ///
					mod_under_wt mod_under_wt_female mod_under_wt_male mod_under_wt_611 mod_under_wt_1223 mod_under_wt_2459 ///
					cmuac_case gam_muac sam_muac mam_muac


					
					
tab child_sex stunt, chi2 row
tab child_sex stunt_611, chi2
tab child_sex stunt_1223, chi2
tab child_sex stunt_2459, chi2

tab child_age_anthro stunt, chi2 


graph bar		stunt stunt_female stunt_male, ///
				by(wealth_quintile) ///
				legend(rows(2)) xsize(3) ysize(2) ///
				legend(size(vsmall) order(1 "Stunting" 2 "Stunted - Female" 3 "Stunted - Male")) nofill ///
				ytitle(% of children , size(vsmall)) ///
				ylabel(,labsize(vsmall))
graph export "$out/_pic/20_child_stunt_walth.png", replace


tab child_sex gam, chi2 row
tab child_sex gam_611, chi2
tab child_sex gam_1223, chi2
tab child_sex gam_2459, chi2

tab child_age_anthro gam, chi2 


tab geo_rural gam, chi2 row
tab geo_rural sam, chi2 row



graph bar		gam gam_female gam_male , ///
				by(wealth_quintile) ///
				legend(rows(2)) xsize(3) ysize(2) ///
				legend(size(vsmall) order(1 "Wasting" 2 "Wasted - Female" 3 "Wasted - Male")) nofill ///
				ytitle(% of children , size(vsmall)) ///
				ylabel(,labsize(vsmall))
graph export "$out/_pic/21_child_waste_walth.png", replace




tab child_sex under_wt, chi2 row
tab child_sex under_wt_611, chi2
tab child_sex under_wt_1223, chi2
tab child_sex under_wt_2459, chi2

tab child_age_anthro under_wt, chi2 

tab geo_rural under_wt, chi2 row
tab geo_rural sev_under_wt, chi2 row


graph bar		under_wt under_wt_female under_wt_male, ///
				by(wealth_quintile) ///
				legend(rows(2)) xsize(3) ysize(2) ///
				legend(size(vsmall) order(1 "Underweight" 2 "Underweight - Female" 3 "Underweight - Male")) nofill ///
				ytitle(% of children , size(vsmall)) ///
				ylabel(,labsize(vsmall))
graph export "$out/_pic/22_child_underwt_walth.png", replace


**----------------------------------------------------------------------------**

**----------------------------------------------------------------------------**
** Child Health Dataset 
**----------------------------------------------------------------------------**

use "$cdta/child_nonanthro_cleanded.dta", clear


drop if geo_state == "MMR003"


global iycf		child_bf child_breastfeed_eibf child_breastfeed_ebf child_breastfeed_predobf childdiet_timely_cf childdiet_introfood child_breastfeed_cont_1yr child_breastfeed_cont_2yr ///				
				childdiet_dds childdiet_min_dds ///
				childdiet_min_mealfreq ///
				childdiet_min_acceptdiet ///
				childdiet_iron_consum


tab geo_rural child_breastfeed_ebf, chi2 row

graph bar		child_bf child_breastfeed_ebf child_breastfeed_cont_1yr child_breastfeed_cont_2yr, ///
				by(wealth_quintile) ///
				legend(rows(2)) xsize(3) ysize(2) ///
				legend(size(vsmall) order(1 "breastfeed children" 2 "exclusively breastfeed" 3 "continious breastfeed at 1 year" 4 "continious breastfeed at 2 years")) nofill ///
				ytitle(% of children , size(vsmall)) ///
				ylabel(,labsize(vsmall))
graph export "$out/_pic/17_child_bf_walth.png", replace



graph bar		childdiet_min_dds childdiet_min_mealfreq childdiet_min_acceptdiet, ///
				by(wealth_quintile) ///
				legend(rows(2)) xsize(3) ysize(2) ///
				legend(size(vsmall) order(1 "Minimum Dietary Diversity" 2 "Minimum Meal Frequency" 3 "Minimum Acceptable Diet")) nofill ///
				ytitle(% of children , size(vsmall)) ///
				ylabel(,labsize(vsmall))
graph export "$out/_pic/17_child_dietindi_walth.png", replace

			
tab geo_rural childdiet_min_dds, chi2 row
tab geo_rural childdiet_min_mealfreq, chi2 row
tab geo_rural childdiet_min_acceptdiet, chi2 row
			
tab geo_rural childdiet_iron_consum, chi2 row


**----------------------------------------------------------------------------**
**----------------------------------------------------------------------------**

global	vacin		child_vaccin_rpt child_bcg_yes_rpt child_vc_bcg_rpt child_novc_bcgd_rpt ///
					child_penta_yes_1_rpt  ///
					child_penta_yes_2_rpt ///
					child_penta_yes_3_rpt ///
					child_polio_yes_1_rpt ///
					child_polio_yes_2_rpt ///
					child_polio_yes_3_rpt ///
					child_polioinj ///
					child_measel_yes_1_rpt ///
					child_measel_yes_2_rpt ///
					child_rubella_yes_rpt ///
					complete_cv_rpt ///
					child_birth_weight ///
					child_low_birthweight


tab geo_rural child_low_birthweight, chi2 row
tab geo_rural child_low_birthweight if geo_rural != 0, chi2 row

tab geo_rural wealth_quintile, chi2 row


graph bar		child_low_birthweight, ///
				over(wealth_quintile,label(labsize(vsmall))) ///
				legend(rows(1)) xsize(3) ysize(2) ///
				legend(size(vsmall)) nofill ///
				ytitle(% of children , size(vsmall)) ///
				ylabel(,labsize(vsmall))
graph export "$out/_pic/15_child_lbw_walth.png", replace

tab geo_rural child_vaccin_rpt, chi2 row
tab geo_rural complete_cv_rpt, chi2 row

tab wealth_quintile child_vaccin_rpt, chi2 row
tab wealth_quintile complete_cv_rpt, chi2 row

graph bar		child_vaccin_rpt complete_cv_rpt, ///
				by(wealth_quintile) ///
				legend(rows(1)) xsize(3) ysize(2) ///
				legend(size(vsmall) order(1 "completed at least one vacincation" 2 "completed all vacincation")) nofill ///
				ytitle(% of children , size(vsmall)) ///
				ylabel(,labsize(vsmall))
graph export "$out/_pic/16_child_immu_walth.png", replace

			
**----------------------------------------------------------------------------**
**----------------------------------------------------------------------------**


global illness	child_ill_yes child_ill_treat child_ill_hp ///
				child_ill_diarrhea child_diarrh_treat child_diarrh_hp child_diarrh_pay child_diarrh_amount child_diarrh_loan child_diarrh_still ///
				child_ill_cough child_cough_treat child_cough_hp child_cough_pay child_cough_amount child_cough_loan child_cough_still ///
				child_ill_fever child_fever_treat child_fever_hp child_fever_pay child_fever_amount child_fever_loan child_fever_still child_fever_malaria ///
				child_ill_other
				
tab geo_rural child_ill_yes, chi2 row
tab geo_rural child_ill_treat, chi2 row
tab geo_rural child_ill_hp, chi2 row

 
tab geo_rural child_ill_diarrhea, chi2 row
tab geo_rural child_diarrh_hp, chi2 row
tab geo_rural child_diarrh_pay, chi2 row


graph bar		child_ill_diarrhea child_diarrh_treat child_diarrh_hp child_diarrh_still child_diarrh_pay, ///
				by(wealth_quintile) ///
				legend(rows(2)) xsize(3) ysize(2) ///
				legend(size(vsmall) order(1 "Diarrhea" 2 "Took Treatment" 3 "Trained health personnel" 4 "Still Diarrhea" 5 "Paid for treatment")) nofill ///
				ytitle(% of children , size(vsmall)) ///
				ylabel(,labsize(vsmall))
graph export "$out/_pic/18_child_diarrhea_walth.png", replace

			
tab geo_rural child_ill_cough, chi2 row
tab geo_rural child_cough_hp, chi2 row
tab geo_rural child_cough_pay, chi2 row


tab geo_rural child_ill_fever, chi2 row
tab geo_rural child_fever_hp, chi2 row
tab geo_rural child_fever_pay, chi2 row


graph bar		child_ill_cough child_cough_treat child_cough_hp child_cough_still child_cough_pay, ///
				by(wealth_quintile) ///
				legend(rows(2)) xsize(3) ysize(2) ///
				legend(size(vsmall) order(1 "Cough" 2 "Took Treatment" 3 "Trained health personnel" 4 "Still Coughing" 5 "Paid for treatment")) nofill ///
				ytitle(% of children , size(vsmall)) ///
				ylabel(,labsize(vsmall))
graph export "$out/_pic/19_child_cough_walth.png", replace


graph bar		child_ill_fever child_fever_treat child_fever_hp child_fever_still child_fever_pay, ///
				by(wealth_quintile) ///
				legend(rows(2)) xsize(3) ysize(2) ///
				legend(size(vsmall) order(1 "Fever" 2 "Took Treatment" 3 "Trained health personnel" 4 "Still Fever" 5 "Paid for treatment")) nofill ///
				ytitle(% of children , size(vsmall)) ///
				ylabel(,labsize(vsmall))
graph export "$out/_pic/20_child_fever_walth.png", replace


**----------------------------------------------------------------------------**
**----------------------------------------------------------------------------**
**----------------------------------------------------------------------------**
**----------------------------------------------------------------------------**

**----------------------------------------------------------------------------**
** Mother Anthro Dataset 
**----------------------------------------------------------------------------**

use "$cdta/mom_anthro_cleanded.dta", clear

drop if geo_state == "MMR003"

global mommuac	mom_muac mom_gam


graph bar		mom_gam, ///
				over(wealth_quintile,label(labsize(vsmall))) ///
				legend(rows(1)) xsize(3) ysize(2) ///
				legend(size(vsmall)) nofill ///
				ytitle(% of hosehold , size(vsmall)) ///
				ylabel(,labsize(vsmall))
graph export "$out/_pic/09_mom_muac_walth.png", replace


tab mom_gam geo_rural , chi2 row
tab mom_gam wealth_quintile , chi2 row



**----------------------------------------------------------------------------**
** Mother Health Dataset 
**----------------------------------------------------------------------------**

use "$cdta/mom_health_cleanded.dta", clear


drop if geo_state == "MMR003"


global anc			ancpast_yn ///
					ancpast_trained ancpast_trained_freq ancpast_trained_freq1 ancpast_trained_freq2 ancpast_trained_freq3 ancpast_trained_freq4 ///
					ancpast_cost ancpast_amount ///
					ancpast_conselling ///
					ancpast_restrict /// 		
					ancpast_bone ///
					ancpast_rion ancpast_iron_consum ancpast_iron_cost ancpast_iron_amount 



tab geo_rural ancpast_trained, chi2 row
tab geo_rural ancpast_trained_freq4, chi2 row

tab ancpast_trained wealth_quintile, chi2 row
tab ancpast_trained_freq4 wealth_quintile, chi2 row

tab geo_rural ancpast_cost, chi2 row
tab geo_rural ancpast_noreason, chi2 row
tab geo_rural ancpast_restrict, chi2 row

tab geo_rural ancpast_bone, chi2 row
tab geo_rural ancpast_rion, chi2 row

tab geo_rural ancpast_iron_cost, chi2 row
tab geo_rural ancpast_rion, chi2 row

tab ancpast_bone wealth_quintile, chi2 row
tab ancpast_rion wealth_quintile, chi2 row


tab geo_rural ancpast_test_yes, chi2 row


graph bar		ancpast_trained ancpast_trained_freq1 ancpast_trained_freq2 ancpast_trained_freq3 ancpast_trained_freq4, ///
				by(wealth_quintile) ///
				legend(rows(2)) xsize(3) ysize(2) ///
				legend(size(vsmall) order(1 "trained health personnel" 2 "at least 2 ANC visits" 3 "at least 3 ANC visits" 4 "at least 4 ANC visits")) nofill ///
				ytitle(% of hosehold , size(vsmall)) ///
				ylabel(,labsize(vsmall))
graph export "$out/_pic/10_anc_walth.png", replace


graph bar		ancpast_rion, ///
				over(wealth_quintile,label(labsize(vsmall))) ///
				legend(rows(1)) xsize(3) ysize(2) ///
				legend(size(vsmall)) nofill ///
				ytitle(% of hosehold , size(vsmall)) ///
				ylabel(,labsize(vsmall))
graph export "$out/_pic/11_mom_iron_walth.png", replace

**----------------------------------------------------------------------------**
**----------------------------------------------------------------------------**

global delivery		deliv_trained deliv_institute ///
					deliv_cost deliv_cost_amount deliv_cost_loan 

tab geo_rural deliv_trained, chi2 row
tab geo_rural deliv_institute, chi2 row
tab geo_rural deliv_cost, chi2 row
tab geo_rural deliv_cost_loan, chi2 row


tab wealth_quintile deliv_trained, chi2 row
tab wealth_quintile deliv_institute, chi2 row

graph bar		deliv_trained deliv_institute, ///
				by(wealth_quintile) ///
				legend(rows(1)) xsize(3) ysize(2) ///
				legend(size(vsmall) order(1 "trained health personnel" 2 "institutional delivery")) nofill ///
				ytitle(% of hosehold , size(vsmall)) ///
				ylabel(,labsize(vsmall))
graph export "$out/_pic/12_deli_walth.png", replace

**----------------------------------------------------------------------------**
**----------------------------------------------------------------------------**
					
global pnc 	pnc_yn pnc_yes_6wks ///
			pnc_trained pnc_bone ///
			pnc_cost_rpt pnc_cost_amount_rpt ///
			pnc_cost_loan_rpt

			
tab geo_rural pnc_trained, chi2 row
tab geo_rural pnc_cost_rpt, chi2 row

graph bar		pnc_trained, ///
				over(wealth_quintile,label(labsize(vsmall))) ///
				legend(rows(1)) xsize(3) ysize(2) ///
				legend(size(vsmall)) nofill ///
				ytitle(% of hosehold , size(vsmall)) ///
				ylabel(,labsize(vsmall))
graph export "$out/_pic/13_mom_pnc_walth.png", replace

**----------------------------------------------------------------------------**
**----------------------------------------------------------------------------**
			
global nbc		nbc_yn nbc_2days_yn ///
				nbc_2days_trained ///
				nbc_cost_loan


tab geo_rural nbc_2days_trained, chi2 row

graph bar		nbc_2days_trained, ///
				over(wealth_quintile,label(labsize(vsmall))) ///
				legend(rows(1)) xsize(3) ysize(2) ///
				legend(size(vsmall)) nofill ///
				ytitle(% of hosehold , size(vsmall)) ///
				ylabel(,labsize(vsmall))
graph export "$out/_pic/14_mom_nbc_walth.png", replace

