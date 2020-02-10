/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PURPOSE: 		WC - NCA Lashio Project

AUTHOR:  		Nicholus

CREATED: 		02 Dec 2019

MODIFIED:
   

THINGS TO DO:

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

**  PREPARE DATASET TO COMBINE AT ONE  **
// Main respondent dataset //
use "$dta/nca_laishio_v3.dta", clear

gen key = _index
order key, before(_index)
drop _index

save "$dta/respondent.dta",replace
clear


// hh members dataset //
use "$dta/consent_hh_grp_grp_hh.dta", clear

gen key = _parent_index
order key, before(_parent_index)

gen hh_mem_key = _parent_index + "_" + test
order hh_mem_key, after(key)

drop _index _parent_index
save "$dta/hh_roster", replace
clear

// child health dataset //
use "$dta/consent_child_vc_rep.dta", replace

gen key = _parent_index
order key, before(_parent_index)

gen hh_mem_key = _parent_index + "_" + child_id_health
order hh_mem_key, after(key)

drop _index _parent_index
save "$dta/child_health", replace
clear


// child iycf //
use "$dta/consent_grp_q2_5_to_q2_7.dta", clear

gen key = _parent_index
order key, before(_parent_index)

gen hh_mem_key = _parent_index + "_" + child_id_iycf
order hh_mem_key, after(key)

drop _index _parent_index
save "$dta/child_iycf", replace
clear

// child anthro //
use "$dta/consent_childanthro_rep.dta", clear

gen key = _parent_index
order key, before(_parent_index)

gen hh_mem_key = _parent_index + "_" + child_id_nut
order hh_mem_key, after(key)

drop _index _parent_index
save "$dta/child_anthro", replace
clear


// mother health
use "$dta/consent_ancpast_rep.dta", clear

gen key = _parent_index
order key, before(_parent_index)

gen hh_mem_key = _parent_index + "_" + women_id_pregpast
order hh_mem_key, after(key)

drop _index _parent_index
save "$dta/mom_health", replace
clear

********************************************************************************
********************************************************************************
**  PREPARE TO COMBINE AS ONE CHILD DATASET  **

use "$cdta/respondent_cleanded.dta",clear
tostring key, replace

merge 1:m key using "$dta/hh_roster"

keep if _merge == 3
drop _merge

order hh_mem_key test, after(key)

merge 1:m hh_mem_key using "$dta/child_health"

keep if _merge == 3
drop _merge

order hh_mem_key test child_id_health, after(key)

merge 1:1 hh_mem_key using "$dta/child_iycf"

drop _merge

order hh_mem_key test child_id_health child_id_iycf, after(key)

merge 1:1 hh_mem_key using "$dta/child_anthro"

drop _merge

order hh_mem_key test child_id_health child_id_iycf child_id_nut, after(key)

save "$dta/child_dataset_combined.dta", replace

clear


**  PREPARE TO COMBINE AS ONE MOTHER DATASET  **
use "$cdta/respondent_cleanded.dta",clear
tostring key, replace

merge 1:m key using "$dta/hh_roster"

keep if _merge == 3
drop _merge

order hh_mem_key test, after(key)

merge 1:m hh_mem_key using "$dta/mom_health"

keep if _merge == 3
drop _merge

order hh_mem_key test, after(key)

save "$dta/mom_dataset_combined.dta", replace

clear


 
