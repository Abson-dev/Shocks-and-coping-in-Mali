

* Set the global file path for exporting results
global filepath "C:\Users\AHema\OneDrive - CGIAR\Desktop\2024\WFP\G5 - Sahel countries\IFPR_WFP_SAHEL Data\Shocks and coping in Mali\data\"


global outputpath "C:\Users\AHema\OneDrive - CGIAR\Desktop\2024\WFP\G5 - Sahel countries\IFPR_WFP_SAHEL Data\Shocks and coping in Mali\outputs\"


* Load your dataset (assuming the dataset is in the same directory)
use "${filepath}G5_Sahel_2018_2023_Mali_enhanced_NewID.dta", clear


/*
1.	By nature, coping strategies should be binary; moreover, the variables still have 9999 values (should be set to missing). I cannot use them:

We decided to keep the initial labeling, coding, and naming convention of the WFP datasets, so that WFP staff could most easily use the integrated and enhanced datasets.
Coping strategies could be made binary in the following way, which in fact aligns with the way WFP does its analysis:

          10                no, because no need                                >>  NO
          20                no, because already depleted              >> YES! (as it is already depleted, it actually means that the household made use of this strategy)
          30                yes                                                                    >> YES
        9999             not applicable                                             >>  9999 is the code used by WFP to indicate "not applicable", because, for example, the household may not have animals to sell or children to withdraw from school. This is different from a missing response.
*/
		
*1.	Waves. Given some important volatility in the sampling frame over the several waves, we are working with the sep-oct waves only (=second wave of each year), which are the most comprehensive and most useful in terms of seasonal performance shocks and other extreme weather events. Below I copied some code to arrive at the 85,430 observation that we use.
*2.	Weights. Please make use of the household sampling weights, recorded under the "weight" variable.
*3.	Coping strategies: we also removed the coping strategies which were not asked across all waves to avoid some spurious relations between shocks and strategies, simply because some strategies were not asked during certain waves. See code also below.

*Code to keep sep-oct waves only 
g wavetype = .
replace wavetype = 1 if wave==1|wave==3|wave==5|wave==7|wave==9|wave==11
replace wavetype = 2 if wave==2|wave==4|wave==6|wave==8|wave==10|wave==12
move wavetype admin0Pcod
tab wave wavetype
keep if wavetype==2 
count // 85,430 obs

///////////////////////////////////////////////		
 foreach var of varlist Lcs_stress_DomAsset-Lcs_em_FemAnimal  {
                replace `var'=0 if `var'==10
				replace `var'=1 if `var'==20|`var'==30
				replace `var'=. if `var'==9999
        }
 
drop Lcs_crisis_ChildWork Lcs_crisis_HHSeparation Lcs_em_Migration

/////////////////////////////////////////////////
//
//            food security indicators
////////////////////////////////////////////////

*2.	We can also convert food security indicators into binary variables:
*Yes, we can. Again, this fully aligns with the vocabulary and coding conventions of WFP. Depending on the distribution and to assure a sufficient number of observations in each category, the multiple categories could be reduced to binary indicators – if this is required by the econometric approach.
/*

-> tabulation of FCS  

   Score de |
Consommatio |
          n |
Alimentaire |
    (SCA) - |
  Catégorie |      Freq.     Percent        Cum.
------------+-----------------------------------
       poor |      7,543        8.83        8.83
 borderline |     12,867       15.06       23.89
 acceptable |     65,020       76.11      100.00
------------+-----------------------------------
      Total |     85,430      100.00

-> tabulation of HDDS  

   Score de |
  Diversité |
Alimentaire |
        des |
    Ménages |
   (SDAM) - |
  Catégorie |      Freq.     Percent        Cum.
------------+-----------------------------------
 >=5 groups |     72,662       85.05       85.05
   4 groups |      6,914        8.09       93.15
   3 groups |      2,960        3.46       96.61
   2 groups |      1,348        1.58       98.19
 0-1 groups |      1,546        1.81      100.00
------------+-----------------------------------
      Total |     85,430      100.00

-> tabulation of HHS  

     Indice |
 Domestique |
 de la Faim |
    (HHS) - |
  Catégorie |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |     77,482       90.70       90.70
          1 |      3,549        4.15       94.85
        2-3 |      3,957        4.63       99.48
          4 |        244        0.29       99.77
        5-6 |        198        0.23      100.00
------------+-----------------------------------
      Total |     85,430      100.00

-> tabulation of CARI  

     Approche Consolidée |
pour le Compte-rendu des |
    Indicateurs (CARI) - |
               Catégorie |      Freq.     Percent        Cum.
-------------------------+-----------------------------------
             food secure |     24,511       28.69       28.69
  marginally food secure |     42,028       49.20       77.89
moderately food insecure |     16,991       19.89       97.78
  severely food insecure |      1,900        2.22      100.00
-------------------------+-----------------------------------
                   Total |     85,430      100.00


*/


label define fcs 1 "poor" 2 "borderline" 3 "acceptable", replace
label define hdds 1 ">=5 groups" 2 "4 groups" 3 "3 groups" 4 "2 groups" 5 "0-1 groups", replace
label define hhs 1 "0" 2 "1" 3 "2-3" 4 "4" 5 "5-6", replace

replace FCS=0 if FCS==1
replace FCS=1 if FCS==2|FCS==3

replace CARI=1 if CARI==1|CARI==2
replace CARI=0 if CARI==3|CARI==4

replace HHS=1 if HHS==1
replace HHS=0 if HHS==2| HHS==3| HHS==4| HHS==5

replace HDDS=1 if HDDS==1
replace HDDS=0 if HDDS==2|HDDS==3|HDDS==4|HDDS==5


*3.	Finally, on shocks, let make sure we have both idiosyncratic and systemic shocks. 
*That seemed to be impossible: there were hardly any questions on idiosyncratic shocks in the WFP surveys. So, most of this will be on systemic shocks. While this is certainly important at the household level, the effect may dissipate at a more aggregate level. That is, idiosyncratic shocks (such as, the prevalence of principal income earners dying from a car accident) might be assumed equal across regions that suffer or do not suffer from a drought shock.


*Conflict shocks include:*
sum deadliness danger diffusion fragmentation	
* Food price shocks include:*
sum zs_maize_inte zs_millet_inte  zs_rice_inte  zs_cowpea_inte zs_peanut_inte zs_maize_spell zs_millet_spell  zs_rice_spell  zs_cowpea_spell zs_peanut_spell zs_maize_freq zs_millet_freq  zs_rice_freq  zs_cowpea_freq zs_peanut_freq
*Climate shocks include:*
sum R_drought R_flood R_heat R_composite

*Other covariates include:*
replace sex_head=0 if sex_head==2 
replace area=0 if area==2
replace education_head=1 if education_head==1|education_head==2|education_head==3|education_head==4

replace marital_head=0 if marital_head==1|marital_head==3|marital_head==4|marital_head==5
replace marital_head=1 if marital_head==2

sum cdi_rainfall cdi_soilmoisture cdi_evapotranspiration sex_head education_head marital_head

drop hhid
rename hhid2 hhid


/////////////////////////
save "${filepath}G5_Sahel_2018_2023_Mali_enhanced_ModelData.dta", replace
