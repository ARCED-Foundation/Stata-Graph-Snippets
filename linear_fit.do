                                                     /*
╔═══════════════════════════════════════════════════════════════════════════════╗                                                                                                                               
║               __  __  ___ __     _____          __    ___ __                  ║
║           /\ |__)/  `|__ |  \   |__/  \|  ||\ ||  \ /\ ||/  \|\ |             ║
║          /~~\|  \\__,|___|__/   |  \__/\__/| \||__//~~\||\__/| \|             ║
║         www.arced.foundation;  https://github.com/ARCED-Foundation            ║
║                                                                               ║
║-------------------------------------------------------------------------------║
║  FILE NAME:      linear_fit.do  	                            ║                                           
║-------------------------------------------------------------------------------║
║  AUTHOR:         Fabliha Anber, SoTLab                                        ║
║  CONTACT:        fabliha.anber@arced.foundation                               ║
║-------------------------------------------------------------------------------║
║  CREATED:        06 Oct 2024                                                  ║
║-------------------------------------------------------------------------------║
║-------------------------------------------------------------------------------║ 			
║ 			     * ARCED Stata code snippet template *							║
╚═══════════════════════════════════════════════════════════════════════════════╝                                                                                                                         */

	
                         										
/*------------------------------------------------------------------------------
								PURPOSE
						------------------------
						
	TITLE: linear fit graph plot diagram
	
	This code plots a scattter diagram with a linear fit prediction overlay
	The switches is used to select the type of graph to be plotted.
	The type of dataset used -(csv, xlsx or dta) can also be selected through switches.

------------------------------------------------------------------------------*/

  

	
/**
 *************** Table of contents: ********************************
 * #1 - Define folder : This will define the folder location of dataset
 * #2 - Choose dataset type : The type of the dataset will be selected whether it is a file with extension dta, csv or xlsx
 * #3 - Set graph theme : This is used if the default scheme will be used or custom graph theme
 * #4 - Plot the  diagram
 * #5 - Save the graph plot diagram
 */
	
**# 1. Define folder
*------------------------------------------------------------------------------*
		
		gl rawdatafolder = "/DROPBOX/your_path"

		
**# 2. Choose dataset type
*------------------------------------------------------------------------------*

		gl dataset_csv  	 			0			// For using data file with csv extension
		gl dataset_xlsx  				0			//For using data file with .xlsx extension 
		gl dataset_dta  				0			// For using data file with dta extension
		* The example dataset is used for demonstration
		*-----------------------------------------------
			gl dataset_example  		1 	//For now, the example dataset is used
		
		
		* The differnent formats of different types of dataset
		if ${dataset_csv}				import delimited "${rawdatafolder}/dataset.csv", clear
		if ${dataset_xlsx}				import excel "${rawdatafolder}/dataset.xlsx", sheet("sheet_name") firstrow clear
		if ${dataset_dta}				u "${rawdatafolder}/dataset.dta", clear
		* The example dataset is used 
		*-----------------------------------
			if ${dataset_example}	{
					sysuse auto.dta, clear
			}

**# 3 - Set graph theme (optional)
*-----------------------
		* Use custom scheme for graph
		gl custom_scheme				1
		
		if ${custom_scheme} {
			set scheme cleanplots
			graph set window fontface "Calibri"
			graph set print fontface "Calibri"
		}
		
* #4 - Plot the  diagram
		* linear fit and scatter graph
			
		* two way scatter plot for mpg verses price overlaid with a line showing the linear relationship between mpg and price
		twoway 	scatter mpg price [fweight=mpg], ///
						mcolor(green%50) ///
						ytitle("Mileage(mpg)" "Miles per gallon") ///
						ylabel(0(5)40,nogrid) xlabel(0(1000)15000, angle(vertical)) 		 ///
						title("This is {it:scatter plot} of mpg and price with a linear fit overlay") ||				 ///
				lfit 	mpg price, lcolor(maroon%80)
				
				
**# 5. Save the  diagram
*------------------------------------------------------------------------------*

		** Saving the graph plot with specific width and height
		graph export "figures/linear_fit_in_scatter_diagram.jpg", 	width(600) height(450) replace