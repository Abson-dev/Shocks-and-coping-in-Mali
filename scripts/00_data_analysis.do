* Set the global file path for exporting results
global filepath "C:\Users\AHema\OneDrive - CGIAR\Desktop\2024\WFP\G5 - Sahel countries\IFPR_WFP_SAHEL Data\Shocks and coping in Mali\data\"


global outputpath "C:\Users\AHema\OneDrive - CGIAR\Desktop\2024\WFP\G5 - Sahel countries\IFPR_WFP_SAHEL Data\Shocks and coping in Mali\outputs\"


* Load your dataset
use "${filepath}G5_Sahel_2018_2023_Mali_enhanced_NewID.dta", clear

putdocx clear

putdocx begin
putdocx textblock begin, style(Title)
Food security report
putdocx textblock end
putdocx textblock begin
WFP - IFPRI
putdocx textblock end

quietly:dtable  i.area i.sex_head i.marital_head i.education_head, by(year) sample(N (%)) title(Table 1. Sample characteristics)
collect style putdocx, layout(autofitcontents)

putdocx collect


///////////////////////

//use "${filepath}G5_Sahel_2018_2023_Mali_enhanced_ModelData.dta", clear

/////////////////////////////////
putdocx textblock begin
Second section 
putdocx textblock end

quietly:dtable  i.area i.sex_head i.marital_head i.education_head, by(FCS) sample(N (%)) title(Table 2. Sample characteristics)
collect style putdocx, layout(autofitcontents)

putdocx collect

////////////////////////////////
putdocx textblock begin
Third section 
putdocx textblock end
quietly:dtable  i.area i.sex_head i.marital_head i.education_head, by(CARI) sample(N (%)) title(Table 3. Sample characteristics)
collect style putdocx, layout(autofitcontents)
putdocx collect
putdocx save "${outputpath}Mali_FS_analysis", replace