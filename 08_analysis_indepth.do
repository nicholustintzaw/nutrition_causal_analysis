/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PURPOSE: 		WC - NCA Lashio Project

AUTHOR:  		Nicholus

CREATED: 		02 Dec 2019

MODIFIED:

THINGS TO DO:

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

**----------------------------------------------------------------------------**
** import cleaned dataset: HH dataset
**----------------------------------------------------------------------------**

use "$cdta/respondent_cleanded.dta", clear

**----------------------------------------------------------------------------**
** WASH
**----------------------------------------------------------------------------**

// Drinking Water Soruce + Treatment
tab water_sum_limited wealth_quintile, chi2 
tab water_rain_limited wealth_quintile, chi2 
tab water_winter_limited wealth_quintile, chi2 


  
tab water_sum_treat_yes wealth_quintile, chi2 
tab water_rain_treat_yes wealth_quintile, chi2 
tab water_winter_treat_yes wealth_quintile, chi2 

// Sanitation
tab latrine_ladder wealth_quintile, chi2 


// Handwashing
tab observ_washplace_no wealth_quintile, chi2
tab handwash_ladder wealth_quintile, chi2 
tab handwash_critical wealth_quintile, chi2 


// DDS - W
tab momdiet_min_ddsw wealth_quintile, chi2 

mean momdiet_ddsw, over(wealth_quintile)

anova momdiet_ddsw wealth_quintile
ttest momdiet_ddsw if wealth_quintile < 3, by (wealth_quintile)
ttest momdiet_ddsw if wealth_quintile > 1 & wealth_quintile < 4, by (wealth_quintile)
ttest momdiet_ddsw if wealth_quintile > 2 & wealth_quintile < 5, by (wealth_quintile)
ttest momdiet_ddsw if wealth_quintile > 3, by (wealth_quintile)


clear
**----------------------------------------------------------------------------**
** import cleaned dataset: Child dataset
**----------------------------------------------------------------------------**

use "$cdta/child_cleanded.dta", clear

**----------------------------------------------------------------------------**
** Child - IYCF
**----------------------------------------------------------------------------**

// general breastfeeding
tab child_bf wealth_quintile, chi2 

// exclusive breastfeeding
tab child_breastfeed_eibf wealth_quintile, chi2 

// continious breastfeeding 
tab child_breastfeed_cont_1yr wealth_quintile, chi2 
tab child_breastfeed_cont_2yr wealth_quintile, chi2 

// introduction of complementary feeding
tab childdiet_timely_cf wealth_quintile, chi2 

// Dietary Diversity
tab childdiet_min_dds wealth_quintile, chi2 

mean childdiet_dds, over(wealth_quintile)

anova childdiet_dds wealth_quintile
ttest childdiet_dds if wealth_quintile < 3, by (wealth_quintile)
ttest childdiet_dds if wealth_quintile > 1 & wealth_quintile < 4, by (wealth_quintile)
ttest childdiet_dds if wealth_quintile > 2 & wealth_quintile < 5, by (wealth_quintile)
ttest childdiet_dds if wealth_quintile > 3, by (wealth_quintile)

// Minimum meal frequency
tab childdiet_min_mealfreq child_bf, chi2

tab childdiet_min_mealfreq wealth_quintile, chi2

// Minimum meal frequency
tab childdiet_min_acceptdiet child_bf, chi2

tab childdiet_min_acceptdiet wealth_quintile, chi2

tab childdiet_min_acceptdiet wealth_quintile if wealth_quintile < 3, chi2
tab childdiet_min_acceptdiet wealth_quintile if wealth_quintile > 1 & wealth_quintile < 4, chi2
tab childdiet_min_acceptdiet wealth_quintile if wealth_quintile > 2 & wealth_quintile < 5, chi2
tab childdiet_min_acceptdiet wealth_quintile if wealth_quintile > 3, chi2


tab childdiet_iron_consum child_bf, chi2
tab childdiet_iron_consum wealth_quintile, chi2


// Immunization
tab child_vaccin_rpt wealth_quintile, chi2
tab complete_cv_rpt wealth_quintile, chi2

tab complete_cv_rpt wealth_quintile if wealth_quintile < 3, chi2
tab complete_cv_rpt wealth_quintile if wealth_quintile > 1 & wealth_quintile < 4, chi2
tab complete_cv_rpt wealth_quintile if wealth_quintile > 2 & wealth_quintile < 5, chi2
tab complete_cv_rpt wealth_quintile if wealth_quintile > 3, chi2


// Child Birthweight
tab child_low_birthweight wealth_quintile, chi2

mean child_birth_weight, over(wealth_quintile)

anova child_birth_weight wealth_quintile
ttest child_birth_weight if wealth_quintile < 3, by (wealth_quintile)
ttest child_birth_weight if wealth_quintile > 1 & wealth_quintile < 4, by (wealth_quintile)
ttest child_birth_weight if wealth_quintile > 2 & wealth_quintile < 5, by (wealth_quintile)
ttest child_birth_weight if wealth_quintile > 3, by (wealth_quintile)

**----------------------------------------------------------------------------**
** Child - Health
**----------------------------------------------------------------------------**

// Childhoold illness
tab child_ill_yes wealth_quintile, chi2
tab child_ill_treat wealth_quintile, chi2
tab child_ill_hp wealth_quintile, chi2

// Diarrhea
tab child_ill_diarrhea wealth_quintile, chi2

// Cough
tab child_ill_cough wealth_quintile, chi2
tab child_cough_treat wealth_quintile, chi2
tab child_cough_hp wealth_quintile, chi2
tab child_cough_loan wealth_quintile, chi2


tab child_ill_cough wealth_quintile if wealth_quintile < 3, chi2
tab child_ill_cough wealth_quintile if wealth_quintile > 1 & wealth_quintile < 4, chi2
tab child_ill_cough wealth_quintile if wealth_quintile > 2 & wealth_quintile < 5, chi2
tab child_ill_cough wealth_quintile if wealth_quintile > 3, chi2

tab child_cough_hp wealth_quintile if wealth_quintile < 3, chi2
tab child_cough_hp wealth_quintile if wealth_quintile > 1 & wealth_quintile < 4, chi2
tab child_cough_hp wealth_quintile if wealth_quintile > 2 & wealth_quintile < 5, chi2
tab child_cough_hp wealth_quintile if wealth_quintile > 3, chi2

tab child_cough_loan wealth_quintile if wealth_quintile < 3, chi2
tab child_cough_loan wealth_quintile if wealth_quintile > 1 & wealth_quintile < 4, chi2
tab child_cough_loan wealth_quintile if wealth_quintile > 2 & wealth_quintile < 5, chi2
tab child_cough_loan wealth_quintile if wealth_quintile > 3, chi2

			
// Fever
tab child_ill_fever wealth_quintile, chi2
tab child_fever_treat wealth_quintile, chi2
tab child_fever_hp wealth_quintile, chi2
tab child_fever_loan wealth_quintile, chi2

tab child_ill_fever wealth_quintile if wealth_quintile < 3, chi2
tab child_ill_fever wealth_quintile if wealth_quintile > 1 & wealth_quintile < 4, chi2
tab child_ill_fever wealth_quintile if wealth_quintile > 2 & wealth_quintile < 5, chi2
tab child_ill_fever wealth_quintile if wealth_quintile > 3, chi2

**----------------------------------------------------------------------------**
** Child - Malnutrtiion
**----------------------------------------------------------------------------**


// child age grouo 
gen child_age_grp = .m 
replace child_age_grp = 1 if child_age_05 == 1
replace child_age_grp = 2 if child_age_611 == 1
replace child_age_grp = 3 if child_age_1223 == 1
replace child_age_grp = 4 if child_age_2459 == 1
tab child_age_grp, m
		
// Stunting
anova haz06 wealth_quintile
ttest haz06 if wealth_quintile < 3, by (wealth_quintile)
ttest haz06 if wealth_quintile > 1 & wealth_quintile < 4, by (wealth_quintile)
ttest haz06 if wealth_quintile > 2 & wealth_quintile < 5, by (wealth_quintile)
ttest haz06 if wealth_quintile > 3, by (wealth_quintile)

ttest haz06 if child_age_grp < 3, by (child_age_grp)
ttest haz06 if child_age_grp > 1 & child_age_grp < 4, by (child_age_grp)
ttest haz06 if child_age_grp > 2, by (child_age_grp)

ttest haz06, by (child_sex)

tab stunt wealth_quintile, chi2
tab stunt child_sex, chi2
tab stunt child_age_grp, chi2

tab stunt child_sex if child_age_grp == 1, chi2 col
tab stunt child_sex if child_age_grp == 2, chi2 col
tab stunt child_sex if child_age_grp == 3, chi2 col
tab stunt child_sex if child_age_grp == 4, chi2 col

tab stunt child_sex if wealth_quintile == 1, chi2 col
tab stunt child_sex if wealth_quintile == 2, chi2 col
tab stunt child_sex if wealth_quintile == 3, chi2 col
tab stunt child_sex if wealth_quintile == 4, chi2 col
tab stunt child_sex if wealth_quintile == 5, chi2 col

tab sev_stunt child_sex, chi2


// Wasting
anova whz06 wealth_quintile
ttest whz06 if wealth_quintile < 3, by (wealth_quintile)
ttest whz06 if wealth_quintile > 1 & wealth_quintile < 4, by (wealth_quintile)
ttest whz06 if wealth_quintile > 2 & wealth_quintile < 5, by (wealth_quintile)
ttest whz06 if wealth_quintile > 3, by (wealth_quintile)

ttest whz06 if child_age_grp < 3, by (child_age_grp)
ttest whz06 if child_age_grp > 1 & child_age_grp < 4, by (child_age_grp)
ttest whz06 if child_age_grp > 2, by (child_age_grp)

ttest whz06, by (child_sex)

tab gam wealth_quintile, chi2
tab gam child_sex, chi2
tab gam child_age_grp, chi2

tab gam child_sex if child_age_grp == 1, chi2 col
tab gam child_sex if child_age_grp == 2, chi2 col
tab gam child_sex if child_age_grp == 3, chi2 col
tab gam child_sex if child_age_grp == 4, chi2 col

tab gam child_sex if wealth_quintile == 1, chi2 col
tab gam child_sex if wealth_quintile == 2, chi2 col
tab gam child_sex if wealth_quintile == 3, chi2 col
tab gam child_sex if wealth_quintile == 4, chi2 col
tab gam child_sex if wealth_quintile == 5, chi2 col

tab sam child_sex, chi2


// Underweight
anova waz06 wealth_quintile
ttest waz06 if wealth_quintile < 3, by (wealth_quintile)
ttest waz06 if wealth_quintile > 1 & wealth_quintile < 4, by (wealth_quintile)
ttest waz06 if wealth_quintile > 2 & wealth_quintile < 5, by (wealth_quintile)
ttest waz06 if wealth_quintile > 3, by (wealth_quintile)

ttest waz06 if child_age_grp < 3, by (child_age_grp)
ttest waz06 if child_age_grp > 1 & child_age_grp < 4, by (child_age_grp)
ttest waz06 if child_age_grp > 2, by (child_age_grp)

ttest waz06, by (child_sex)

tab under_wt wealth_quintile, chi2
tab under_wt child_sex, chi2
tab under_wt child_age_grp, chi2

tab under_wt child_sex if child_age_grp == 1, chi2 col
tab under_wt child_sex if child_age_grp == 2, chi2 col
tab under_wt child_sex if child_age_grp == 3, chi2 col
tab under_wt child_sex if child_age_grp == 4, chi2 col

tab under_wt child_sex if wealth_quintile == 1, chi2 col
tab under_wt child_sex if wealth_quintile == 2, chi2 col
tab under_wt child_sex if wealth_quintile == 3, chi2 col
tab under_wt child_sex if wealth_quintile == 4, chi2 col
tab under_wt child_sex if wealth_quintile == 5, chi2 col

tab sev_under_wt child_sex, chi2

clear
**----------------------------------------------------------------------------**
** import cleaned dataset: Mother dataset
**----------------------------------------------------------------------------**

use "$cdta/mom_health_cleanded.dta", clear

**----------------------------------------------------------------------------**
** Mother ANC
**----------------------------------------------------------------------------**

// ANC Visit
tab ancpast_yn wealth_quintile, chi2
tab ancpast_trained wealth_quintile, chi2

tab ancpast_trained wealth_quintile if wealth_quintile < 3, chi2
tab ancpast_trained wealth_quintile if wealth_quintile > 1 & wealth_quintile < 4, chi2
tab ancpast_trained wealth_quintile if wealth_quintile > 2 & wealth_quintile < 5, chi2
tab ancpast_trained wealth_quintile if wealth_quintile > 3, chi2

tab ancpast_trained wealth_quintile if wealth_quintile == 1 | wealth_quintile == 3 , chi2
tab ancpast_trained wealth_quintile if wealth_quintile == 1 | wealth_quintile == 4 , chi2
tab ancpast_trained wealth_quintile if wealth_quintile == 1 | wealth_quintile == 5 , chi2

tab ancpast_trained wealth_quintile if wealth_quintile == 2 | wealth_quintile == 3 , chi2
tab ancpast_trained wealth_quintile if wealth_quintile == 2 | wealth_quintile == 4 , chi2
tab ancpast_trained wealth_quintile if wealth_quintile == 2 | wealth_quintile == 5 , chi2

anova ancpast_trained_freq wealth_quintile
ttest ancpast_trained_freq if wealth_quintile < 3, by (wealth_quintile)
ttest ancpast_trained_freq if wealth_quintile > 1 & wealth_quintile < 4, by (wealth_quintile)
ttest ancpast_trained_freq if wealth_quintile > 2 & wealth_quintile < 5, by (wealth_quintile)
ttest ancpast_trained_freq if wealth_quintile > 3, by (wealth_quintile)

tab ancpast_trained_freq3 wealth_quintile, chi2

tab ancpast_trained_freq3 wealth_quintile if wealth_quintile == 1 | wealth_quintile == 2 , chi2
tab ancpast_trained_freq3 wealth_quintile if wealth_quintile == 1 | wealth_quintile == 3 , chi2
tab ancpast_trained_freq3 wealth_quintile if wealth_quintile == 1 | wealth_quintile == 4 , chi2
tab ancpast_trained_freq3 wealth_quintile if wealth_quintile == 1 | wealth_quintile == 5 , chi2

tab ancpast_trained_freq3 wealth_quintile if wealth_quintile == 2 | wealth_quintile == 3 , chi2
tab ancpast_trained_freq3 wealth_quintile if wealth_quintile == 2 | wealth_quintile == 4 , chi2
tab ancpast_trained_freq3 wealth_quintile if wealth_quintile == 2 | wealth_quintile == 5 , chi2


tab ancpast_trained_freq3 wealth_quintile if wealth_quintile == 4 | wealth_quintile == 1 , chi2
tab ancpast_trained_freq3 wealth_quintile if wealth_quintile == 4 | wealth_quintile == 2 , chi2
tab ancpast_trained_freq3 wealth_quintile if wealth_quintile == 4 | wealth_quintile == 3 , chi2
tab ancpast_trained_freq3 wealth_quintile if wealth_quintile == 4 | wealth_quintile == 5 , chi2

tab ancpast_trained_freq3 wealth_quintile if wealth_quintile == 5 | wealth_quintile == 1 , chi2
tab ancpast_trained_freq3 wealth_quintile if wealth_quintile == 5 | wealth_quintile == 2 , chi2
tab ancpast_trained_freq3 wealth_quintile if wealth_quintile == 5 | wealth_quintile == 3 , chi2
tab ancpast_trained_freq3 wealth_quintile if wealth_quintile == 5 | wealth_quintile == 4 , chi2


// ANC Cost
tab ancpast_cost wealth_quintile, chi2

anova ancpast_amount wealth_quintile
ttest ancpast_amount if wealth_quintile < 3, by (wealth_quintile)
ttest ancpast_amount if wealth_quintile > 1 & wealth_quintile < 4, by (wealth_quintile)
ttest ancpast_amount if wealth_quintile > 2 & wealth_quintile < 5, by (wealth_quintile)
ttest ancpast_amount if wealth_quintile > 3, by (wealth_quintile)

tab ancpast_borrow wealth_quintile, chi2

// ANC no visit
tab ancpast_no_important wealth_quintile, chi2

tab ancpast_no_important wealth_quintile if wealth_quintile == 3 | wealth_quintile == 1 , chi2
tab ancpast_no_important wealth_quintile if wealth_quintile == 3 | wealth_quintile == 2 , chi2
tab ancpast_no_important wealth_quintile if wealth_quintile == 3 | wealth_quintile == 4 , chi2
tab ancpast_no_important wealth_quintile if wealth_quintile == 3 | wealth_quintile == 5 , chi2


tab ancpast_no_finance wealth_quintile, chi2
tab ancpast_no_finance wealth_quintile if wealth_quintile == 3 | wealth_quintile == 1 , chi2
tab ancpast_no_finance wealth_quintile if wealth_quintile == 3 | wealth_quintile == 2 , chi2
tab ancpast_no_finance wealth_quintile if wealth_quintile == 3 | wealth_quintile == 4 , chi2
tab ancpast_no_finance wealth_quintile if wealth_quintile == 3 | wealth_quintile == 5 , chi2


// Diet Restriction
tab ancpast_restrict wealth_quintile, chi2

// B1 supplementation 
tab ancpast_bone wealth_quintile, chi2

// IFA supplementation
tab ancpast_rion wealth_quintile, chi2
tab ancpast_iron_cost wealth_quintile, chi2
			

**----------------------------------------------------------------------------**
** Mother Delivery
**----------------------------------------------------------------------------**

// Delivery with health personnel 
tab deliv_trained wealth_quintile, chi2
tab deliv_institute wealth_quintile, chi2

tab deliv_place_home wealth_quintile, chi2


tab deliv_cost wealth_quintile, chi2
tab deliv_cost_loan wealth_quintile, chi2


**----------------------------------------------------------------------------**
** PNC and NBC
**----------------------------------------------------------------------------**
				
// PNC visit 
tab pnc_trained wealth_quintile, chi2

tab pnc_bone wealth_quintile, chi2

tab pnc_cost_rpt wealth_quintile, chi2

tab pnc_cost_loan_rpt wealth_quintile, chi2

				
// NBC visit
tab nbc_2days_trained wealth_quintile, chi2

tab nbc_cost wealth_quintile, chi2

tab nbc_cost_loan wealth_quintile, chi2

		
	

