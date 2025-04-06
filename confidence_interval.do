                                                                                                                                                                                                      /*
╔═══════════════════════════════════════════════════════════════════════════════╗                                                                                                                               
║               __  __  ___ __     _____          __    ___ __                  ║
║           /\ |__)/  `|__ |  \   |__/  \|  ||\ ||  \ /\ ||/  \|\ |             ║
║          /~~\|  \\__,|___|__/   |  \__/\__/| \||__//~~\||\__/| \|             ║
║         www.arced.foundation;  https://github.com/ARCED-Foundation            ║
║                                                                               ║
║-------------------------------------------------------------------------------║
║  FILE NAME:      confidence_interval.do  	       			                    ║                                           
║-------------------------------------------------------------------------------║
║  AUTHOR:         Fabliha Anber, SoTLab                                        ║
║  CONTACT:        fabliha.anber@arced.foundation                               ║
║-------------------------------------------------------------------------------║
║  CREATED:        14 Oct 2024                                                  ║
║-------------------------------------------------------------------------------║
║-------------------------------------------------------------------------------║ 			
║ 			     * ARCED Stata code snippet template *							║
╚═══════════════════════════════════════════════════════════════════════════════╝                                                                                                                         */
 
 
 
/*------------------------------------------------------------------------------
								PURPOSE
						------------------------
						
	TITLE: Confidence Interval
	
	This code generates a plot with linear fit prediction and 95% confidence interval of the prediction
	The type of dataset used -(csv, xlsx or dta) can also be selected through switches.

------------------------------------------------------------------------------*/
	
/**
 *************** Table of contents: ********************************
 * #1 - Define folder : This will define the folder location of dataset
 * #2 - Choose dataset type : The type of the dataset will be selected whether it is a file with extension dta, csv or xlsx
 * #3 - Plot the diagram
 * #4 - Save the diagram
 */
	
**# 1. Define folder
*------------------------------------------------------------------------------*
		
		gl rawdatafolder = "/DROPBOX/your_path"

			
**# 2. Choose dataset type
*------------------------------------------------------------------------------*

		gl dataset_csv  	 			0			// For using data file with csv extension
		gl dataset_xlsx  				0			//For using data file with xlsx extension 
		gl dataset_dta  				0			// For using data file with dta extension
		* The example dataset is used for demonstration
		*-----------------------------------------------
			gl dataset_example  		1 			//For now, the example dataset is used
		
		
		* The differnent formats of different types of dataset
		if ${dataset_csv}				import delimited "${rawdatafolder}/dataset.csv", clear
		if ${dataset_xlsx}				import excel "${rawdatafolder}/dataset.xlsx", sheet("sheet_name") firstrow clear
		if ${dataset_dta}				u "${rawdatafolder}/dataset.dta", clear
		* The example dataset is used 
		*-----------------------------------
			if ${dataset_example}		sysuse auto.dta, clear
		
**# 3.  Plot the  diagram
*----------------------------------*
	
* 	In this stata file, no custom package is used. The plot is customized with the following specifications shown in detail.

	/*------------------------------------------------------------------------
		
		Linear fit with confidence interval:
		~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		The linear fit(twoway lfitci) is shown with a dashed line with 95% confidence interval in tranculet color
		1) Line Color: 					White (lcolor(white))
		2) Confidence Interval Color:	Semi-transparent light yellow color (acolor("224 223 188%50"))
		3) Line Style:					Dashed (lpattern(dash))
		
		Scatter Plot:
		~~~~~~~~~~~~~
		The scatter plot represents individual data points of  mpg vs weight
		1) Marker color: 		Semi-transparent bright sand (mcolor(sandb%70))
		
		Plot customization:
		~~~~~~~~~~~~~~~~~~~
		1) Plot Region:		Charcoal color (color("28 28 24"))
		2) Graph Region:	Dark color (fcolor("20 19 14")) 
		
		Axis customization:
		~~~~~~~~~~~~~~~~~~~
		
			X Axis Label,			Options are same for both X Axis Label and Y Axis Label:	 
			Y Axis Label:			1) Color of Label Text: off-white (labcolor("247 246 223"))
									2) Color of Label Line: White (tlcolor(white))
									3) grid : grid line should be included
									4) Pattern of Grid Line: Dash-dotted line (glpattern(dash_dot))
									5) Color of Grid Line: Stone(glcolor(stone%30))		
			X Axis Line,
			Y Axis Line:			1) Color of line: offwhite(xscale(lc("247 246 223"))  yscale(lc("247 246 223")))
									
		Graph title customization:
		~~~~~~~~~~~~~~~~~~~~~~~~~
			X Axis Title:			1) Color of X title text in graph: Warm beige(xtitle(,color("242 242 230")))
			Y Axis Title:			1) Text of Y title: ytitle("MPG(Miles Per Gallon)")
									2) Color of Y title text in graph: Warm beige (ytitle(,color("242 242 230")))
		Legend customization:
		~~~~~~~~~~~~~~~~~~~~~
		Adjusted legend order and custom color for consistency with the plot theme
		1) Legend Order: 		legend(order(3 2 1)) means the changing the order of legend where the default ordering shows:
								1) 95% CLI
								2) Fitted values and
								3) Mileage(mpg)	
								
		2) Legend Label:		Text Color: White (color(white))
		
		3) Region Background(region):	1) Background Shading: Dark color region (fcolor("20 19 14"))
										2) Border Colour: Charcoal color (color("28 28 24"))	
										
										
		Overall Graph Title customization:
		~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		1) Title:				i) Text: title("The linear fit prediction of mpg on weight")
								ii) Color: White(title(,color(white)))
		2) subtitle:			i) Text: title("95% confidence interval on the prediction")
								ii) Color: Ivory Tint(subtitle(color(237 229 206)))

	--------------------------------------------------------------------------*/

	twoway 	lfitci 	mpg weight , 																					///
					lcolor(white) acolor("224 223 188%50") lpattern(dash) || 										///
			scatter mpg weight, 																					///
					mcolor(sandb%70) 																				///
						plotregion(color("28 28 24")) graphregion(fcolor("20 19 14")) 								///
						xlabel(, labcolor("247 246 223") tlcolor(white) grid glpattern(dash_dot) glcolor(stone%30)) ///
						ylabel(, labcolor("247 246 223") tlcolor(white) grid glpattern(dash_dot) glcolor(stone%30)) ///
						xscale(lc("247 246 223"))  yscale(lc("247 246 223")) 										///
						xtitle(,color("242 242 230")) ytitle("MPG(Miles Per Gallon)", color("242 242 230")) 		///
						legend(order(3 2 1) color(white) region(fcolor("28 28 24") color("20 19 14"))) 				///
						title("The linear fit prediction of mpg on weight", color(white)) 							///
						subtitle("95% confidence interval on the prediction", color(237 229 206))
						
						
	
**# 4. Save the  diagram
*------------------------------------------------------------------------------*

		** Saving the graph plot with specific width and height
		graph export "figures/confidence_interval_linear_fit.jpg", 	width(600) height(450) replace			
			
**# End of file	

	
	