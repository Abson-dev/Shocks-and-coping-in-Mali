* Set the global file path for exporting results
global filepath "C:\Users\AHema\OneDrive - CGIAR\Desktop\2024\WFP\G5 - Sahel countries\IFPR_WFP_SAHEL Data\Shocks and coping in Mali\data\"


global outputpath "C:\Users\AHema\OneDrive - CGIAR\Desktop\2024\WFP\G5 - Sahel countries\IFPR_WFP_SAHEL Data\Shocks and coping in Mali\outputs\"


* Load your dataset (assuming the dataset is in the same directory)
use "${filepath}G5_Sahel_2018_2023_Mali_enhanced_ModelData.dta", clear


//ssc install outreg2
* Define the sampling weight variable
svyset hhid [pweight=weight]

* Shortened names for strategies
local strategies Lcs_stress_DomAsset Lcs_stress_Saving Lcs_stress_EatOut Lcs_stress_BorrowCash Lcs_stress_BorrowFood Lcs_stress_MoreLabour Lcs_stress_Animals Lcs_crisis_ProdAssets Lcs_crisis_Edu_Health Lcs_crisis_OutSchool Lcs_em_ResAsset Lcs_em_Begged Lcs_em_IllegalAct Lcs_em_FemAnimal

* Shortened version for each strategy abbreviation
local shortnames ds sv eo bc bf ml an cp eh os ra bg il fa

* Create a local macro to loop through both sets
local n 1

* Probit model for conflict shocks (Equation 1)
foreach strategy in `strategies' {
    local shortname : word `n' of `shortnames'
    svy: probit `strategy' deadliness danger diffusion fragmentation area education_head marital_head sex_head
    margins, eyex(deadliness danger diffusion fragmentation)
    estimates store conf`shortname'
    * Use outreg2 to export results for this model
    outreg2 using "${outputpath}results.csv", replace ctitle("Conflict `strategy'") excel
    local n = `n' + 1
}

* Reset counter for next loop
local n 1

* Probit model for price shocks (Equation 2)
foreach strategy in `strategies' {
    local shortname : word `n' of `shortnames'
    svy: probit `strategy' zs_maize_spell zs_millet_spell zs_rice_spell zs_cowpea_spell zs_peanut_spell area education_head marital_head sex_head
    margins, eyex(zs_maize_spell zs_millet_spell zs_rice_spell zs_cowpea_spell zs_peanut_spell)
    estimates store price`shortname'
    * Use outreg2 to append results for this model
    outreg2 using "${outputpath}results.csv", append ctitle("Price `strategy'") excel
    local n = `n' + 1
}

* Reset counter for next loop
local n 1

* Probit model for seasonal performance shocks (Equation 3)
foreach strategy in `strategies' {
    local shortname : word `n' of `shortnames'
    svy: probit `strategy' cdi_rainfall cdi_soilmoisture cdi_evapotranspiration area education_head marital_head sex_head
    margins, eyex(cdi_rainfall cdi_soilmoisture cdi_evapotranspiration)
    estimates store season`shortname'
    * Use outreg2 to append results for this model
    outreg2 using "${outputpath}results.csv", append ctitle("Seasonal `strategy'") excel
    local n = `n' + 1
}

* Reset counter for next loop
local n 1

* Probit model for climate shocks (Equation 4)
foreach strategy in `strategies' {
    local shortname : word `n' of `shortnames'
    svy: probit `strategy' R_drought R_flood R_heat area education_head marital_head sex_head
    margins, eyex(R_drought R_flood R_heat)
    estimates store climate`shortname'
    * Use outreg2 to append results for this model
    outreg2 using "${outputpath}results.csv", append ctitle("Climate `strategy'") excel
    local n = `n' + 1
}

* Reset counter for next loop
local n 1

* Combined model for all shocks (Equation 5)
foreach strategy in `strategies' {
    local shortname : word `n' of `shortnames'
    svy: probit `strategy' zs_maize_spell zs_millet_spell zs_rice_spell zs_cowpea_spell zs_peanut_spell cdi_rainfall cdi_soilmoisture cdi_evapotranspiration deadliness danger diffusion fragmentation R_drought R_flood R_heat area education_head marital_head sex_head
    margins, eyex(zs_maize_spell zs_millet_spell zs_rice_spell zs_cowpea_spell zs_peanut_spell cdi_rainfall cdi_soilmoisture cdi_evapotranspiration deadliness danger diffusion fragmentation R_drought R_flood R_heat)
    estimates store comb`shortname'
    * Use outreg2 to append results for this model
    outreg2 using "${outputpath}results.csv", append ctitle("Combined `strategy'") excel
    local n = `n' + 1
}

* Reset counter for next loop
local n 1

* Probit model for food security outcomes (Equation 6)
foreach outcome in FCS HDDS HHS CARI {
    svy: probit `outcome' Lcs_stress_DomAsset Lcs_stress_Saving Lcs_stress_EatOut Lcs_stress_BorrowCash Lcs_stress_BorrowFood Lcs_stress_MoreLabour Lcs_stress_Animals Lcs_crisis_ProdAssets Lcs_crisis_Edu_Health Lcs_crisis_OutSchool Lcs_em_ResAsset Lcs_em_Begged Lcs_em_IllegalAct Lcs_em_FemAnimal area education_head marital_head sex_head
    margins, eyex(Lcs_stress_DomAsset Lcs_stress_Saving Lcs_stress_EatOut Lcs_stress_BorrowCash Lcs_stress_BorrowFood Lcs_stress_MoreLabour Lcs_stress_Animals Lcs_crisis_ProdAssets Lcs_crisis_Edu_Health Lcs_crisis_OutSchool Lcs_em_ResAsset Lcs_em_Begged Lcs_em_IllegalAct Lcs_em_FemAnimal)
    estimates store foodsec`outcome'
    * Use outreg2 to append results for food security models
    outreg2 using "${outputpath}results.csv", append ctitle("Food Security `outcome'") excel
}

