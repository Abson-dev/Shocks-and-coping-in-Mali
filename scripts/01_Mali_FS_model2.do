* Set the global file path for exporting results
global filepath "C:\Users\AHema\OneDrive - CGIAR\Desktop\2024\WFP\G5 - Sahel countries\IFPR_WFP_SAHEL Data\Shocks and coping in Mali\data\"


global outputpath "C:\Users\AHema\OneDrive - CGIAR\Desktop\2024\WFP\G5 - Sahel countries\IFPR_WFP_SAHEL Data\Shocks and coping in Mali\outputs\"


* Load your dataset (assuming the dataset is in the same directory)
use "${filepath}G5_Sahel_2018_2023_Mali_enhanced_ModelData.dta", clear


* Define the list of coping strategies
local strategies Lcs_stress_DomAsset Lcs_stress_Saving Lcs_stress_EatOut ///
    Lcs_stress_BorrowCash Lcs_stress_BorrowFood Lcs_stress_MoreLabour ///
    Lcs_stress_Animals Lcs_crisis_ProdAssets Lcs_crisis_Edu_Health ///
    Lcs_crisis_OutSchool Lcs_em_ResAsset Lcs_em_Begged Lcs_em_IllegalAct Lcs_em_FemAnimal

* Conflict shocks variables
local conflict_shocks deadliness danger diffusion fragmentation

* Food price shocks variables (updated)
local foodprice_shocks zs_maize_inte zs_millet_inte zs_rice_inte zs_sorghum_inte

* Climate shocks variables
local climate_shocks R_drought R_flood R_heat R_composite

* Other covariates (X) - without cdi_rainfall, cdi_soilmoisture, and cdi_evapotranspiration
local covariates area education_head marital_head sex_head

/***********************
* Step 1: Probit Model WITHOUT Interaction Terms
***********************/
foreach strategy of local strategies {
    di "Running Probit model for `strategy' without interaction terms"
    
    * Run the probit model without interaction terms
    probit `strategy' `conflict_shocks' `foodprice_shocks' `climate_shocks' `covariates'

    * Store results for later use
    estimates store noint_`strategy'
}

/***********************
* Step 2: Probit Model WITH Interaction Terms
***********************/
foreach strategy of local strategies {
    di "Running Probit model for `strategy' with interaction terms"
    
    * Drop interaction variables if they already exist
    capture drop conflict_foodprice_maize conflict_foodprice_millet conflict_foodprice_rice ///
        conflict_foodprice_sorghum conflict_climate_drought conflict_climate_flood ///
        maize_climate_drought millet_climate_drought rice_climate_drought ///
        sorghum_climate_drought maize_climate_flood millet_climate_flood ///
        rice_climate_flood sorghum_climate_flood

    * Create interaction terms for shocks (pairwise interactions)
    
    * Conflict and food price shocks (with different grains)
    gen conflict_foodprice_maize = deadliness*zs_maize_inte
    gen conflict_foodprice_millet = deadliness*zs_millet_inte
    gen conflict_foodprice_rice = deadliness*zs_rice_inte
    gen conflict_foodprice_sorghum = deadliness*zs_sorghum_inte
    
    * Conflict and climate shocks
    gen conflict_climate_drought = deadliness*R_drought
    gen conflict_climate_flood = deadliness*R_flood

    * Food price shocks and climate shocks (with different grains)
    gen maize_climate_drought = zs_maize_inte*R_drought
    gen millet_climate_drought = zs_millet_inte*R_drought
    gen rice_climate_drought = zs_rice_inte*R_drought
    gen sorghum_climate_drought = zs_sorghum_inte*R_drought

    gen maize_climate_flood = zs_maize_inte*R_flood
    gen millet_climate_flood = zs_millet_inte*R_flood
    gen rice_climate_flood = zs_rice_inte*R_flood
    gen sorghum_climate_flood = zs_sorghum_inte*R_flood

    * Run the probit model with interaction terms
    probit `strategy' `conflict_shocks' `foodprice_shocks' `climate_shocks' ///
        conflict_foodprice_maize conflict_foodprice_millet conflict_foodprice_rice ///
        conflict_foodprice_sorghum conflict_climate_drought conflict_climate_flood ///
        maize_climate_drought millet_climate_drought rice_climate_drought ///
        sorghum_climate_drought maize_climate_flood millet_climate_flood ///
        rice_climate_flood sorghum_climate_flood `covariates'

    * Store results for later use
    estimates store int_`strategy'
}

/***********************
* Step 3: Export Results to CSV
***********************/

* Export stored results of probit models without interaction terms
esttab noint_* using "${outputpath}probit_results_no_interaction.csv", replace se  

* Export stored results of probit models with interaction terms
esttab int_* using "${outputpath}probit_results_interaction.csv", replace se 
