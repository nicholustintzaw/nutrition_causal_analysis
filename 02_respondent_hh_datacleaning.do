/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PURPOSE: 		WC - NCA Lashio Project

AUTHOR:  		Nicholus

CREATED: 		02 Dec 2019

MODIFIED:
   

THINGS TO DO:

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

**-----------------------------------------------------**
** PPI Score
**-----------------------------------------------------**
** vi dataset 
use "$dta/hh_roster.dta", clear

destring test hh_mem_age hh_mem_highedu hh_mem_relation, replace

// solve double hh head obs
replace hh_mem_relation = 1 if hh_mem_key ==  "2_3"
replace hh_mem_relation = 5 if hh_mem_key ==  "78_3"
replace hh_mem_relation = 5 if hh_mem_key ==  "4_3"
replace hh_mem_relation = 5 if hh_mem_key ==  "130_3"

* hh head education 
* note some hh with no hh head 
gen hh_head = (hh_mem_relation == 1)
replace hh_head = .m if mi(hh_mem_relation) |  hh_mem_relation == 999
tab hh_head, m

bysort key: egen hh_head_count = total(hh_head)
tab hh_head_count, m

* assume number one hh member position as hh head
gen hh_head_edu 	= hh_mem_highedu
replace hh_head_edu = .m if hh_mem_relation != 1
replace hh_head_edu = .m if hh_mem_highedu == 999
tab hh_head_edu, m

bysort key: replace hh_head_edu = hh_mem_highedu if hh_head_count == 0 & test == 1


* hh member 0 - 5 years old numbers
gen hh_mem_u5 		= (hh_mem_age < 5)
replace hh_mem_u5 	= .m if mi(hh_mem_age) 
tab hh_mem_u5, m

bysort key: egen hh_u5_count = total(hh_mem_u5)
tab hh_u5_count, m


* hh member 5 - 9 years old members
gen hh_mem_5to9 		= (hh_mem_age >= 5 & hh_mem_age <10)
replace hh_mem_5to9 	= .m if mi(hh_mem_age) 
tab hh_mem_5to9, m

bysort key: egen hh_5to9_count = total(hh_mem_5to9)
tab hh_5to9_count, m

//drop if hh_mem_relation != 1

//destring test hh_mem_relation, replace
sort test key
keep if !mi(hh_head_edu)

duplicates drop key, force

keep hh_mem_name hh_head_edu hh_u5_count hh_5to9_count hh_mem_relation hh_mem_key key

save "$dta/hh_roster_ppi.dta", replace

clear

**-----------------------------------------------------**
**  PREPARE DATASETS FOR DATA CLEANING  **
**-----------------------------------------------------**

use "$dta/respondent.dta", clear

merge 1:1 key using "$dta/hh_roster_ppi.dta", keepusing(hh_head_edu hh_u5_count hh_5to9_count)

drop _merge

// will_participate
destring will_participate, replace
tab will_participate, m

destring respd_who, replace
replace respd_who = .m if will_participate == 0
tab respd_who, m

**-----------------------------------------------------**
** GEOGRAPHICAL AREA
**-----------------------------------------------------**

destring geo_vill, replace

lab def geo_vill	1"Hnoke Kut" 2"Mauk Tawng" 3"Nar Hit" 4"Nar Loi" 5"Mat Khaw" ///
					6"Nam Pu" 7"Nawng Hkun" 8"Ka Na" 9"Mar Ku Long" 10"Mar Mo Kyei" ///
					11"Naw La" 12"Nawng Yone" 13"Pan Yang" 14"Ping Nar" 15"Zay Kon" 16"December"


lab val geo_vill geo_vill
tab geo_vill, m

forvalue x = 1/16 {
	gen geo_vill_`x' = (geo_vill == `x')
	replace geo_vill_`x'	= .m if mi(geo_vill)
	order geo_vill_`x', after(geo_vill)
	tab geo_vill_`x', m
}



** reporting variables **
lab var  geo_vill_1 "Hnoke Kut"
lab var  geo_vill_2 "Mauk Tawng"
lab var  geo_vill_3 "Nar Hit"
lab var  geo_vill_4 "Nar Loi"
lab var  geo_vill_5 "Mat Khaw"
lab var  geo_vill_6 "Nam Pu"
lab var  geo_vill_7 "Nawng Hkun"
lab var  geo_vill_8 "Ka Na"
lab var  geo_vill_9 "Mar Ku Long"
lab var  geo_vill_10 "Mar Mo Kyei"
lab var  geo_vill_11 "Naw La"
lab var  geo_vill_12 "Nawng Yone"
lab var  geo_vill_13 "Pan Yang"
lab var  geo_vill_14 "Ping Nar"
lab var  geo_vill_15 "Zay Kon"
lab var  geo_vill_16 "December"

lab var will_participate	"consent yes"


global geo	geo_vill_16 geo_vill_15 geo_vill_14 geo_vill_13 geo_vill_12 geo_vill_11 ///
			geo_vill_10 geo_vill_9 geo_vill_8 geo_vill_7 geo_vill_6 geo_vill_5 geo_vill_4 ///
			geo_vill_3 geo_vill_2 geo_vill_1 will_participate  

**-----------------------------------------------------**
** Poverty Propobility Index
**-----------------------------------------------------**
destring	house_electric water_rain house_roof1 house_roof2 house_roof3 ///
			house_wall1 house_wall2 house_wall3 house_wall4 house_wall5 house_wall6 ///
			house_cooking mom_beef , replace

* ppi score generation 
gen ppi_1		= 0 //if geo_state == "MMR002" | geo_state == "MMR003"
//replace ppi_1	= .m if mi(geo_state)
tab ppi_1, m

gen ppi_2		= 0 if hh_u5_count >= 2
replace ppi_2	= 8 if hh_u5_count == 1
replace ppi_2	= 14 if hh_u5_count == 0
replace ppi_2	= .m if mi(hh_u5_count)
tab ppi_2, m

gen ppi_3		= 0 if hh_5to9_count >= 2
replace ppi_3	= 8 if hh_5to9_count == 1
replace ppi_3	= 12 if hh_5to9_count == 0
replace ppi_3	= .m if mi(hh_5to9_count)
tab ppi_3, m

gen ppi_4		= 0 
replace ppi_4 	= 9 if house_electric == 1
replace ppi_4	= .m if mi(house_electric)
tab ppi_4, m

gen ppi_5		= 0 
replace ppi_5 	= 11 if water_rain == 1 | water_rain == 5 | water_rain == 12
replace ppi_5	= .m if mi(water_rain)
tab ppi_5, m

gen ppi_6		= 0 if house_roof1 == 1
replace ppi_6 	= 7 if house_roof1 != 1 & !mi(house_roof1)
replace ppi_6	= .m if mi(house_roof)
tab ppi_6, m

gen ppi_7		= 0 if house_wall3 == 1
replace ppi_7 	= 10 if house_wall3 != 1 & !mi(house_wall3)
replace ppi_7	= .m if mi(house_wall)
tab ppi_7, m // vi took 9 instead of 10

gen ppi_8		= 8 if house_cooking == 4
replace ppi_8 	= 0 if house_cooking != 4 & !mi(house_cooking)
replace ppi_8	= .m if mi(house_cooking)
tab ppi_8, m

gen ppi_9		= 0 
replace ppi_9	= 7 if hh_head_edu == 3
replace ppi_9 	= 12 if hh_head_edu == 4 | hh_head_edu == 6
replace ppi_9	= .m if mi(hh_head_edu)
tab ppi_9, m

gen ppi_10		= 0 
replace ppi_10	= 11 if mom_beef > 0 & !mi(mom_beef)
replace ppi_10	= .m if mi(mom_beef)
tab ppi_10, m

egen ppi_score 		= rowtotal(ppi_1 ppi_2 ppi_3 ppi_4 ppi_5 ppi_6 ppi_7 ppi_8 ppi_9 ppi_10)
replace ppi_score 	= .m if mi(ppi_1) | mi(ppi_2) | mi(ppi_3) | mi(ppi_4) | ///
							mi(ppi_5) | mi(ppi_6) | mi(ppi_7) | mi(ppi_8) | ///
							mi(ppi_9) | mi(ppi_10)
tab ppi_score, m

merge m:1 ppi_score using "$dta/ppi_lookup_table.dta", keepusing(national_povt_line extreme_povt_line)

drop if _merge == 2
drop _merge

* wealth quantile ranking
sum extreme_povt_line, d
_pctile national_povt_line, p(20, 40, 60, 80)

gen wealth_quintile 	= (national_povt_line > `r(r4)')
replace wealth_quintile	= 2 if (national_povt_line > `r(r3)' & national_povt_line <= `r(r4)')
replace wealth_quintile	= 3 if (national_povt_line > `r(r2)' & national_povt_line <= `r(r3)')
replace wealth_quintile	= 4 if (national_povt_line > `r(r1)' & national_povt_line <= `r(r2)')
replace wealth_quintile	= 5 if (national_povt_line <= `r(r1)')
replace wealth_quintile	= .m if mi(national_povt_line)

lab def wealth_quintile	1"Poorest" 2"Poor" 3"Medium" 4"Wealthy" 5"Wealthiest"
lab val wealth_quintile wealth_quintile
tab wealth_quintile, m

forvalue x = 1/5 {
	gen wealth_quintile`x' = (wealth_quintile == `x')
	replace wealth_quintile`x'	= .m if mi(wealth_quintile)
	order wealth_quintile`x', after(wealth_quintile)
	tab wealth_quintile`x', m
}


rename wealth_quintile5 wealth_wealthiest 
rename wealth_quintile4 wealth_wealthy 
rename wealth_quintile3 wealth_medium
rename wealth_quintile2 wealth_poor
rename wealth_quintile1 wealth_poorest

** reporting variables **
lab var national_povt_line		"poverty likelihood - National Poverty Line"
lab var wealth_quintile			"wealth quantile ranking"
lab var wealth_poorest 			"wealth quantile - poorest"
lab var wealth_poor 			"wealth quantile - poor"
lab var wealth_medium 			"wealth quantile - medium"
lab var wealth_wealthy 			"wealth quantile - wealthy"
lab var wealth_wealthiest		"wealth quantile - wealthiest"

global ppi	national_povt_line wealth_quintile ///
			wealth_poorest wealth_poor wealth_medium wealth_wealthy wealth_wealthiest

**-----------------------------------------------------**
** Women Dietary Diversity 
**-----------------------------------------------------**

local momdiet mom_rice mom_potatoes mom_pumpkin mom_beans mom_nuts mom_yogurt mom_organ mom_beef mom_fish mom_eggs mom_leafyveg mom_mango mom_veg mom_fruit mom_fat mom_sweets mom_condiments 
foreach var in `momdiet' {
	destring `var', replace
	replace `var' = .m if respd_who != 1
	tab `var', m
}

* Grains
gen momdiet_fg_grains		=	(mom_rice == 1 | mom_potatoes == 1)
replace momdiet_fg_grains	=	.m if mi(mom_rice) & mi(mom_potatoes)
lab var momdiet_fg_grains "Women - Grain"
tab momdiet_fg_grains, m

* Vit Vegetables
gen momdiet_fg_vitveg		=	(mom_leafyveg == 1)
replace momdiet_fg_vitveg	=	.m if mi(mom_leafyveg) 
lab var momdiet_fg_vitveg "Women - Vitamin A riched vegetable"
tab momdiet_fg_vitveg, m

* Vit Fruit
gen momdiet_fg_vitfruit		=	(mom_pumpkin == 1 | mom_mango == 1) 
replace momdiet_fg_vitfruit	=	.m if mi(mom_pumpkin) & mi(mom_mango)
lab var momdiet_fg_vitfruit "Women - Vitamin A riched fruits"
tab momdiet_fg_vitfruit, m

* Fruit
gen momdiet_fg_othfruit		=	(mom_fruit == 1)
replace momdiet_fg_othfruit	=	.m if mi(mom_fruit)
lab var momdiet_fg_othfruit "Women - Other fruit"
tab momdiet_fg_othfruit, m

* Vegetables
gen momdiet_fg_othveg		=	(mom_veg == 1)
replace momdiet_fg_othveg	=	.m if mi(mom_veg)
lab var momdiet_fg_othveg "Women - Other vegetable"
tab momdiet_fg_othveg, m

* Proteins
gen momdiet_fg_meat			=	(mom_beef == 1 | mom_fish == 1 | mom_organ == 1)
replace momdiet_fg_meat		=	.m if mi(mom_beef) & mi(mom_fish) & mi(mom_organ)
lab var momdiet_fg_meat "Women - Meat"
tab momdiet_fg_meat, m

* Eggs
gen momdiet_fg_eggs			=	(mom_eggs == 1)
replace momdiet_fg_eggs		=	.m if mi(mom_eggs)
lab var momdiet_fg_eggs "Women - Eggs"
tab momdiet_fg_eggs, m

* Pulses
gen momdiet_fg_pulses		=	(mom_beans == 1)
replace momdiet_fg_pulses	=	.m if mi(mom_beans) 
lab var momdiet_fg_pulses "Women - Pulses"
tab momdiet_fg_pulses, m

* Nuts
gen momdiet_fg_nut			=	(mom_nuts == 1)
replace momdiet_fg_nut		=	.m if mi(mom_nuts)
lab var momdiet_fg_nut "Women - Nut"
tab momdiet_fg_nut, m

* Dairy
gen momdiet_fg_diary		=	(mom_yogurt == 1)
replace momdiet_fg_diary	=	.m if mi(mom_yogurt)
lab var momdiet_fg_diary "Women - Diary"
tab momdiet_fg_diary, m

** 3) MINIMUM DIETERY DIETARY DIVERSITY SCORE FOR WOMEN
egen momdiet_ddsw	=	rowtotal(momdiet_fg_grains momdiet_fg_vitveg momdiet_fg_vitfruit ///
								momdiet_fg_othfruit momdiet_fg_othveg momdiet_fg_meat ///
								momdiet_fg_eggs momdiet_fg_pulses momdiet_fg_nut ///
								momdiet_fg_diary), missing
replace momdiet_ddsw = .m if respd_who != 1   
//replace `var' = .m if respd_who != 1                   
lab var momdiet_ddsw "Dietary Diversity Score for Women" 
tab momdiet_ddsw, m
sum momdiet_ddsw

** Indicator definition: MDD-W (FAO, FANTA and FHI 360)
** consumed at least five out of ten defined food groups the previous day or night
** proxy indicator for higher micronutrient adequacy, one important dimension of diet quality

gen momdiet_min_ddsw		=	(momdiet_ddsw >= 5)
replace momdiet_min_ddsw	=	.m if mi(momdiet_ddsw)
lab var momdiet_min_ddsw "Women met minimum dietary diversity score"
tab momdiet_min_ddsw, m

// mom_meal_freq
destring mom_meal_freq, replace
replace mom_meal_freq = .m if respd_who != 1 
replace mom_meal_freq = .n if mom_meal_freq == 444 
tab mom_meal_freq, m


** reporting variables **

lab var momdiet_fg_grains 	"women - grain"
lab var momdiet_fg_vitveg 	"women - viamin rich vegetable"
lab var momdiet_fg_vitfruit "women - vitamin rich fruit"
lab var momdiet_fg_othfruit "women - other fruit"
lab var momdiet_fg_othveg 	"women - other vegetable"
lab var momdiet_fg_meat 	"women - meat"
lab var momdiet_fg_eggs 	"women - eggs"
lab var momdiet_fg_pulses 	"women - pulses"
lab var momdiet_fg_nut 		"women - nut"
lab var momdiet_fg_diary	"women - diary"

lab var momdiet_ddsw 		"dietary diversty score - women"
lab var momdiet_min_ddsw	"met minimum dds-w"

lab var mom_meal_freq		"women meal frequency"


global ddsw		momdiet_fg_grains momdiet_fg_vitveg momdiet_fg_vitfruit momdiet_fg_othfruit momdiet_fg_othveg ///
				momdiet_fg_meat momdiet_fg_eggs momdiet_fg_pulses momdiet_fg_nut momdiet_fg_diary ///
				momdiet_ddsw momdiet_min_ddsw ///
				mom_meal_freq

				
**-----------------------------------------------------**
** WASH
**-----------------------------------------------------**

** Water services ladder 
local source water_sum water_rain water_winter

foreach var in `source' {
	destring `var', replace
	tab `var', m
	gen `var'_ladder		= (`var' < 8 | `var' == 9 | `var' == 11 | `var' == 12) 
	replace `var'_ladder	= 3 if `var' == 13
	replace `var'_ladder	= 2 if `var'_ladder == 0
	replace `var'_ladder 	= .m if mi(`var')
	tab `var'_ladder, m
	order `var'_ladder, after(`var')
	
	forvalue x = 1/3 {
		gen `var'_ladder_`x' 		= (`var'_ladder == `x')
		replace `var'_ladder_`x' 	= .m if mi(`var'_ladder)
		tab `var'_ladder_`x', m
		order `var'_ladder_`x', after(`var'_ladder)
	}
}

rename water_sum_ladder_3 		water_sum_surface
rename water_sum_ladder_1 		water_sum_limited
rename water_sum_ladder_2		water_sum_unimprove

rename water_rain_ladder_3		water_rain_surface
rename water_rain_ladder_1 		water_rain_limited
rename water_rain_ladder_2 		water_rain_unimprove

rename water_winter_ladder_3 	water_winter_surface
rename water_winter_ladder_1 	water_winter_limited
rename water_winter_ladder_2	water_winter_unimprove


** Drinking Water Treatment
local treat water_sum_treatmethod water_rain_treatmethod water_winter_treatmethod
gen water_sum_treat_yes 	= 0
gen water_rain_treat_yes 	= 0 
gen water_winter_treat_yes	= 0

forvalue x = 1/7 {
	destring `var', replace
	
	replace water_sum_treat_yes 	= 1 if water_sum_treatmethod`x' == 1
	replace water_sum_treat_yes 	= .m if mi(water_sum_treatmethod)
	replace water_sum_treat_yes = 0 if water_sum_treat == 0
	order water_sum_treat_yes, after(water_sum_treatmethod)
	tab water_sum_treat_yes, m

	replace water_rain_treat_yes 	= 1 if water_rain_treatmethod`x' == 1
	replace water_rain_treat_yes 	= .m if mi(water_rain_treatmethod)
	replace water_rain_treat_yes = 0 if water_rain_treat == 0
	order water_rain_treat_yes, after(water_rain_treatmethod)
	tab water_rain_treat_yes, m
	
	replace water_winter_treat_yes 	= 1 if water_winter_treatmethod`x' == 1
	replace water_winter_treat_yes 	= .m if mi(water_winter_treatmethod)
	replace water_winter_treat_yes = 0 if water_winter_treat == 0
	order water_winter_treat_yes, after(water_winter_treatmethod)
	tab water_winter_treat_yes, m	
}


** Sanitation services ladder
destring latrine_type latrine_share, replace
local value 1 2 3 4 5 6 888


foreach x in `value' {
	gen latrine_type_`x' 		= (latrine_type == `x')
	replace latrine_type_`x' 	= .m if mi(latrine_type)
	tab latrine_type_`x', m
	order latrine_type_`x', after(latrine_type)
}

rename latrine_type_1 		latrine_septict
rename latrine_type_2 		latrine_notank
rename latrine_type_3 		latrine_pitproof
rename latrine_type_4 		latrine_pitnoproof
rename latrine_type_5 		latrine_floting
rename latrine_type_6 		latrine_open
rename latrine_type_888		latrine_other

gen latrine_ladder		= (latrine_type < 4 & latrine_share == 0)
replace latrine_ladder	= 2 if latrine_type <4 & latrine_share == 1
replace latrine_ladder	= 3 if latrine_type >= 4 & !mi(latrine_type)
replace latrine_ladder	= 4 if latrine_type == 6
replace latrine_ladder 	= .m if mi(latrine_type) //| mi(latrine_share)
tab latrine_ladder, m

order latrine_ladder, after(latrine_other)

forvalue x = 1/4 {
	gen latrine_ladder`x' 	= (latrine_ladder == `x')
	replace latrine_ladder`x'	= .m if mi(latrine_ladder)
	order latrine_ladder`x', after(latrine_ladder)
	tab latrine_ladder`x', m
}

rename latrine_ladder4	latrine_opendef 
rename latrine_ladder3 	latrine_unimprove
rename latrine_ladder2 	latrine_limited
rename latrine_ladder1 	latrine_basic

gen latrine_basic_funct		= (latrine_basic == 1 & latrine_observe_function == 1)
replace latrine_basic_funct	= .m if mi(latrine_basic) & mi(latrine_observe_function)
tab latrine_basic_funct, m

gen latrine_basic_funct_clean 		= (latrine_basic_funct == 1 & latrine_observe_clean == 1)
replace latrine_basic_funct_clean	= .m if mi(latrine_observe_clean) & mi(latrine_basic_funct)
tab latrine_basic_funct_clean, m

gen latrine_basic_funct_clean_nshare 		= (latrine_basic_funct_clean == 1 & latrine_share == 0)
replace latrine_basic_funct_clean_nshare	= .m if mi(latrine_share) & mi(latrine_basic_funct_clean)
tab latrine_basic_funct_clean_nshare, m

order latrine_basic_funct latrine_basic_funct_clean latrine_basic_funct_clean_nshare, after(latrine_basic)

** Handwashing service ladders

destring observ_washplace0 observ_washplace1 observ_washplace2 observ_washplace3 observ_washplace4 observ_washplace888 observ_water soap_present, replace

gen handwash_ladder 	=	(observ_washplace1 == 1 | observ_washplace2 == 1 | observ_washplace3 == 1 & ///
							(observ_water == 1 & soap_present == 1))
replace handwash_ladder = 2 if handwash_ladder == 0
replace handwash_ladder = 3 if observ_washplace4 == 1
replace handwash_ladder = .m if mi(observ_water) | mi(soap_present) | observ_washplace0 == 1
tab handwash_ladder, m

order handwash_ladder, after(soap_present)

forvalue x = 1/3 {
	gen handwash_ladder`x' 	= (handwash_ladder == `x')
	replace handwash_ladder`x'	= .m if mi(handwash_ladder)
	order handwash_ladder`x', after(handwash_ladder)
	tab handwash_ladder`x', m
}

rename handwash_ladder3 handwash_no
rename handwash_ladder2 handwash_limited
rename handwash_ladder1 handwash_basic

gen observ_washplace_no = (observ_washplace != "0")
replace observ_washplace_no = .m if mi(observ_washplace)
order observ_washplace_no, after(observ_washplace)
tab observ_washplace_no, m


// Hand washing at critical times 
// https://www.wsp.org/sites/wsp.org/files/PracticalGuidance_HWWS_3_0.pdf
// https://www.wsp.org/sites/wsp.org/files/publications/WSP-Practical-Guidance-Measuring-Handwashing-Behavior-2013-Update.pdf



gen handwash_critical	= 0 
order handwash_critical, after(handwash_no)
foreach var of varlist  soap_child_faeces soap_tiolet soap_before_cook soap_before_eat soap_feed_child {
	destring `var', replace	
}

replace handwash_critical = 1 if 	soap_child_faeces == 4 & soap_tiolet == 4 & soap_before_cook == 4 & ///
									soap_before_eat ==  4 & soap_feed_child == 4	

foreach var of varlist  soap_child_faeces soap_tiolet soap_before_cook soap_before_eat soap_feed_child {
	destring `var', replace	
	replace handwash_critical = .m if mi(`var')	
}

foreach var of varlist  soap_child_faeces soap_tiolet soap_before_cook soap_before_eat soap_feed_child {
	forvalue x = 1/4 {
	
	gen `var'_`x' 		= (`var' == `x')
	replace `var'_`x' 	= .m if mi(`var')
	tab `var'_`x', m
	
	}
}

** reporting variable **
lab var water_sum_limited 		"summer - limited"
lab var water_sum_unimprove 	"summer - unimproved"	
lab var water_sum_surface 		"summer - surface water"
lab var water_rain_limited 		"rain - limited"
lab var water_rain_unimprove 	"rain - unimproved"
lab var water_rain_surface 		"rain - surface water"
lab var water_winter_limited 	"winter - limited"
lab var water_winter_unimprove 	"winter - unimproved"
lab var water_winter_surface 	"winter - surface water"

lab var water_sum_treat_yes 	"summer - treated"
lab var water_rain_treat_yes 	"rain - treated"
lab var water_winter_treat_yes	"winter - treated"

lab var latrine_ladder 			"latrine - ladder"
lab var latrine_basic 			"latrine - basic" 
lab var latrine_limited 		"latrine - limited"
lab var latrine_unimprove 		"latrine - unimproved"
lab var latrine_opendef			"latrine - open defication"

lab var latrine_basic_funct 				"latrine basic functioning"
lab var latrine_basic_funct_clean 			"latrine basic functioning and clean"
lab var latrine_basic_funct_clean_nshare 	"latrine basic functioning, clean and not sharing with other"

lab var observ_washplace_no		"observed handwashing place" 

lab var handwash_ladder 		"handwashing ladder"
lab var handwash_basic 			"handwashing - basic"
lab var handwash_limited 		"handwashing - limited"
lab var handwash_no  			"handwashing - no facility"

lab var handwash_critical		"handwashing - always with soap at critical times"

lab var soap_child_faeces_1 	"After contact with the child’s stool - never"
lab var soap_child_faeces_2 	"After contact with the child’s stool - sometime"
lab var soap_child_faeces_3 	"After contact with the child’s stool - often"
lab var soap_child_faeces_4 	"After contact with the child’s stool - always"

lab var soap_tiolet_1 			"After going to the toilet - never"
lab var soap_tiolet_2 			"After going to the toilet - sometime"
lab var soap_tiolet_3 			"After going to the toilet - often"
lab var soap_tiolet_4 			"After going to the toilet - always"

lab var soap_before_cook_1 		"Before preparing food - never"
lab var soap_before_cook_2 		"Before preparing food - sometime"
lab var soap_before_cook_3 		"Before preparing food - often"
lab var soap_before_cook_4 		"Before preparing food - always"

lab var soap_before_eat_1 		"Before eating - never"
lab var soap_before_eat_2 		"Before eating - sometime"
lab var soap_before_eat_3 		"Before eating - often"
lab var soap_before_eat_4 		"Before eating - always"

lab var soap_feed_child_1 		"Before feeding a child - never"
lab var soap_feed_child_2 		"Before feeding a child - sometime"
lab var soap_feed_child_3 		"Before feeding a child - often"
lab var soap_feed_child_4 		"Before feeding a child - always"

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
				


				
drop _id _uuid _submission_time _parent_table_name _parent_index _tags _notes _version _duration _submitted_by _xform_id

save "$cdta/respondent_cleanded.dta", replace

clear
**-----------------------------------------------------**
**-----------------------------------------------------**




