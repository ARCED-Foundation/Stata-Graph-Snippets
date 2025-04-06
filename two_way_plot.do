                                                                                                                                                                                                      /*
╔═══════════════════════════════════════════════════════════════════════════════╗                                                                                                                               
║               __  __  ___ __     _____          __    ___ __                  ║
║           /\ |__)/  `|__ |  \   |__/  \|  ||\ ||  \ /\ ||/  \|\ |             ║
║          /~~\|  \\__,|___|__/   |  \__/\__/| \||__//~~\||\__/| \|             ║
║         www.arced.foundation;  https://github.com/ARCED-Foundation            ║
║                                                                               ║
║-------------------------------------------------------------------------------║
║  FILE NAME:      two_way_plot.do				  	                            ║                                           
║-------------------------------------------------------------------------------║
║  AUTHOR:         Fabliha Anber, SoTLab                                        ║
║  CONTACT:        fabliha.anber@arced.foundation                               ║
║-------------------------------------------------------------------------------║
║  CREATED:        06 Oct 2024                                                  ║
║-------------------------------------------------------------------------------║
║-------------------------------------------------------------------------------║ 			
║ 			     * ARCED Stata code snippet template *							║
╚═══════════════════════════════════════════════════════════════════════════════╝                                          
	
                         										
/*------------------------------------------------------------------------------
								PURPOSE
						------------------------
						
	TITLE: two way graph plot diagram
	
	This code plots different two-way graphs such as scatter diagram, line plot , histogram, bar diagram 
	The switches is used to select the type of graph to be plotted.
	The type of dataset used -(csv, xlsx or dta) can also be selected through switches.

------------------------------------------------------------------------------*/

  

	

 *************** Table of contents: ********************************
 * #1 - Define folder : This will define the folder location of dataset
 * #2 - Choose the type of graph : The type of graph will be chosen such as scatter plot, line graph, histogram or bar diagram
 * #3 - Choose dataset type : The type of the dataset will be selected whether it is a file with extension dta, csv or xlsx
 * #4 - Set graph theme (optional)
 * #5 - Plot the  diagram
 * 			#i -  Scatter plot
 * 			#ii - Line plot
 * 			#iii - Histogram
 *	 		#iv - Bar diagram
 * #6 - Save the graph plot diagram
 */
	
**# 1. Define folder
*------------------------------------------------------------------------------*
		
		gl rawdatafolder = "/DROPBOX/your_path"

		
		
**# 2. Choose the type of graph
*------------------------------------------------------------------------------*
		* The type of scatter plot to be plotted
		gl scatter_plot 				0		// A two-way scatter plot diagram
		gl line_plot 					0		// A simple line plot daigram
		gl histogram_plot				0		// A simple histogram plot
		gl bar_diagram					1
// 		gl multiple_graphs				1
		
**# 3. Choose dataset type
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
				
					if ${scatter_plot} 		sysuse auto.dta, clear
					if ${line_plot} 		sysuse sp500.dta, clear
					if ${histogram_plot} 	sysuse auto.dta, clear
					if ${bar_diagram} 		webuse sp500, clear
			}
		


**# 4 - Set graph theme (optional)
*-----------------------
		* Use custom scheme for graph
		gl custom_scheme				1
		
		if ${custom_scheme} {
			set scheme cleanplots
			graph set window fontface "Calibri"
			graph set print fontface "Calibri"
		}	

**#  5.Plot the  diagram		

**#     i. Scatter plot
*------------------------------------------------------------------------------*
		if ${scatter_plot} {
			* two way scatter plot for mpg verses price overlaid with a line showing the linear relationship between mpg and price
			* msymbol(O) means solid circle, mymbol(S) means solid Square 
			twoway 	scatter 	mpg price if foreign [fweight=mpg], mcolor(green%50) msymbol(O) 			///
								ytitle("Mileage(mpg)" "Miles per gallon of fuel the car can travel") 		///
								ylabel(0(5)40,nogrid) xlabel(0(1000)15000, angle(vertical)) 			||	///
					scatter		mpg price if ~foreign [fweight=mpg], mcolor(red%50) msymbol(S)  			///
								ytitle("Mileage(mpg)" "Miles per gallon of fuel the car can travel") 		///
								ylabel(0(5)40,nogrid) xlabel(0(1000)15000, angle(vertical)) 		 	 || ///
					scatteri	41 5397  (6) "Note this point", mcolor(green%50) msymbol(O)					///
						title("This is {it:scatter plot} for mpg and price") 								///
						subtitle("For foreign and domestic car type") 										///
						legend(order(1 "Foreign mpg" 2 "Domestic mpg" 3 "Important observation")) 			///
						note("Two-way scatter plots with an important observation marked")
		}
		

**#     ii. Line plot
*-------------------------------------------------------------------------------*
		if ${line_plot}{
		    * Line plots for low and high stock prices with the median of date plotted as a line
			summarize date, detail
			local date_median = r(p50)
			display `date_median' 
			loc text_location = `date_median' + 13 // This is the location where the median of date is placed
			
			line 	low date, lpattern(dash) lcolor(purple%70) || 	///
			line 	high date, lpattern(solid) lcolor(red%50) 		///
					legend(cols(1) position(0) bplacement(neast)) 	///
					title("Daily low and high stock price") 		///
					graphregion(color(white))						///
					xline(`date_median', lcolor(green)) 			///
					text(1100 `text_location' "Median" "of" "date" , justification(left) size(2.5)) ///
					note("Two-way line plot")
			
		}
		


	
**#     iii. Histogram
*-------------------------------------------------------------------------------*
		if ${histogram_plot}{
			* The graphs in one graph region of domestic and foreign price with title and subtitle in the graph
			twoway ///
					histogram 	price if foreign,  width(500) start(2000) color(red%30) freq  || 			///
					histogram 	price if ~foreign,  width(500) start(2000) color(green%30) freq 			///
								title("Histogram of price") subtitle("Based on foreign and domestic car") 	///
								legend(order(1 "Foreign" 2 "Domestic"))										///
								note("Two-way histogram")
		}	

			
**#     iv. Bar diagram
*-------------------------------------------------------------------------------*
		if ${bar_diagram}{
		    * Plotting the high and low dates of first 15 observations of the variables date, high and low
			twoway bar high low date in 1/15, ///
			note("twoway bar diagram")
		}
		
// 		if ${multiple_graphs}{
//				
// 		}
		
**# 6. Save the  diagram
*------------------------------------------------------------------------------*

		** Saving the graph plot with specific width and height
		if ${scatter_plot} 		graph export "figures/two_way_scatter_plot.jpg", 	width(600) height(450) replace
		if ${line_plot} 		graph export "figures/two_way_line_plot.jpg", 		width(600) height(450) replace
		if ${histogram_plot} 	graph export "figures/two_way_histogram.jpg", 		width(600) height(450) replace
		if ${bar_diagram} 		graph export "figures/two_way_bar_diagram.jpg", 	width(600) height(450) replace
	 
	 
	
	
	
**# End of file	

	
	