/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PURPOSE: 		WC - NCA Lashio Project

AUTHOR:  		Nicholus

CREATED: 		02 Dec 2019

MODIFIED:

MODIFIED:
   

THINGS TO DO:

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/

// Settings for stata
pause on
clear all
clear mata
set more off
set scrollbufsize 100000

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// ***SET ROOT DIRECTORY HERE AND ONLY HERE***
do "_dir_setting.do"

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

** STEP 00: Import Dataset
do "$do/00_data_import_nca.do"

** STEP 01: Create Child Level Dataset
do "$do/01_combine_dataset.do"

** STEP 02: Household data Cleaning
do "$do/02_respondent_hh_datacleaning.do"

** STEP 03: Child data Cleaning
do "$do/03_child_datacleaning.do"

** STEP 4: Child Anthro data Cleaning
do "$do/04_mom_health_datacleaning.do"

** STEP 05: Data Analysis
do "$do/05_analysis.do"







