* Set the global file path for exporting results
global filepath "C:\Users\AHema\OneDrive - CGIAR\Desktop\2024\WFP\G5 - Sahel countries\IFPR_WFP_SAHEL Data\Shocks and coping in Mali\data\"


global outputpath "C:\Users\AHema\OneDrive - CGIAR\Desktop\2024\WFP\G5 - Sahel countries\IFPR_WFP_SAHEL Data\Shocks and coping in Mali\outputs\"


* Load your dataset (assuming the dataset is in the same directory)
use "${filepath}G5_Sahel_2018_2023_Mali_enhanced_ModelData.dta", clear



* Generate the number of shocks as the sum of relevant shock variables
gen num_shocks = (deadliness > 0) + (danger > 0) + (diffusion > 0) + (fragmentation > 0) + (zs_maize_inte > 0) + (R_drought > 0) + (R_flood > 0) + (R_heat > 0) + (   R_composite > 0)

* Create dummy variables for different levels of shocks
gen shock_4 = num_shocks == 4
gen shock_5 = num_shocks == 5
gen shock_6 = num_shocks == 6
gen shock_7 = num_shocks == 7
gen shock_8_or_more = num_shocks >= 8

sum shock_4 shock_5 shock_6 shock_7 shock_8 



* List of coping strategies
local strategies Lcs_stress_DomAsset Lcs_stress_Saving Lcs_stress_EatOut ///
    Lcs_stress_BorrowCash Lcs_stress_BorrowFood Lcs_stress_MoreLabour ///
    Lcs_stress_Animals Lcs_crisis_ProdAssets Lcs_crisis_Edu_Health ///
    Lcs_crisis_OutSchool Lcs_em_ResAsset Lcs_em_Begged Lcs_em_IllegalAct Lcs_em_FemAnimal
* shocks: deadliness danger diffusion fragmentation zs_maize_inte R_drought R_flood R_heat R_composite
* Loop through each coping strategy and run the probit model
* First model - replace the existing file
* First probit model - Replace the existing file and include goodness-of-fit metrics
probit Lcs_stress_DomAsset shock_4 shock_5 shock_6 shock_7 education_head marital_head sex_head area

* Calculate the metrics
local loglik = e(ll)
local loglik_null = e(ll_0)
local n_params = e(df_m)
local n_obs = e(N)

* McFadden's Pseudo R-squared
local pseudo_r2 = 1 - (`loglik' / `loglik_null')

* AIC and BIC
local aic = -2*`loglik' + 2*`n_params'
local bic = -2*`loglik' + `n_params'*log(`n_obs')

* Add custom statistics using estadd
//ssc install estout
estadd scalar Pseudo_R2 = `pseudo_r2'
estadd scalar Log_Likelihood = `loglik'
estadd scalar AIC = `aic'
estadd scalar BIC = `bic'

* Export the results with esttab
esttab using "${outputpath}probit_model_results.csv", replace se 

* Loop through remaining coping strategies and append the results
local strategies Lcs_stress_DomAsset Lcs_stress_Saving Lcs_stress_EatOut ///
    Lcs_stress_BorrowCash Lcs_stress_BorrowFood Lcs_stress_MoreLabour ///
    Lcs_stress_Animals Lcs_crisis_ProdAssets Lcs_crisis_Edu_Health ///
    Lcs_crisis_OutSchool Lcs_em_ResAsset Lcs_em_Begged Lcs_em_IllegalAct Lcs_em_FemAnimal

foreach strategy of local strategies {
    di "Running Probit model for `strategy'"

    * Run the probit model
    probit `strategy' shock_4 shock_5 shock_6 shock_7 education_head marital_head sex_head area

    * Calculate the metrics
    local loglik = e(ll)
    local loglik_null = e(ll_0)
    local n_params = e(df_m)
    local n_obs = e(N)

    * McFadden's Pseudo R-squared
    local pseudo_r2 = 1 - (`loglik' / `loglik_null')

    * AIC and BIC
    local aic = -2*`loglik' + 2*`n_params'
	local bic = -2*`loglik' + `n_params'*log(`n_obs')

    * Add custom statistics using estadd
    estadd scalar Pseudo_R2 = `pseudo_r2'
    estadd scalar Log_Likelihood = `loglik'
    estadd scalar AIC = `aic'
    estadd scalar BIC = `bic'

    * Append the results to the CSV file
    esttab using "${outputpath}probit_model_results.csv", append se
}