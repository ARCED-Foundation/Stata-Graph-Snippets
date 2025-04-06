                                                                                                                                                                                                      /*
╔═══════════════════════════════════════════════════════════════════════════════╗                                                                                                                               
║               __  __  ___ __     _____          __    ___ __                  ║
║           /\ |__)/  `|__ |  \   |__/  \|  ||\ ||  \ /\ ||/  \|\ |             ║
║          /~~\|  \\__,|___|__/   |  \__/\__/| \||__//~~\||\__/| \|             ║
║         www.arced.foundation;  https://github.com/ARCED-Foundation            ║
║                                                                               ║
║-------------------------------------------------------------------------------║
║  FILE NAME:      two_way_plot_with_by_group.do  	                            ║                                           
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
						
	TITLE: two-way graph plot diagram in groups of data
	
	This code plots different two-way graphs such as scatter diagram, line plot, histogram, multiple diagram with subgroups of data of any variable
	The switches is used to select the type of graph to be plotted.
	The type of dataset used -(csv, xlsx or dta) csn also be selected through switches.

------------------------------------------------------------------------------*/

  

	
/**
 *************** Table of contents: ********************************
 * #1 - Define folder : This will define the folder location of dataset
 * #2 - Choose the type of graph : The type og graph will be chosen such as scatter plot, line graph, histogram or bar diagram
 * #3 - Choose dataset type : The type of the dataset will be selected whether it is a file with extension dta, csv or xlsx
 * #4 - Set graph theme (optional)
 * #5 - Plot the  diagram
 * 			#i -  Scatter plot
 * 			#ii - Line plot
 * 			#iii - Histogram
 *	 		#iv - Multiple diagram
 * #6 - Save the graph plot diagram
 */
	
**# 1. Define folder
*------------------------------------------------------------------------------*
		
		gl rawdatafolder = "/DROPBOX/your_path"

		
		
**# 2. Choose the type of graph
*------------------------------------------------------------------------------*
		* The type of scatter plot to be plotted
		gl scatter_plot 				0		// Two-way scatter plot diagram with by group
		gl line_plot 					0		// Two-way line plot daigram with by group
		gl histogram_plot				1		// Two-way histogram plot with by group
		gl multiple_graphs				0		// Two-way multiple graphs combined plot with by group
		
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
				
					if ${scatter_plot} 		webuse census, clear //Load the U.S. Census dataset
					if ${line_plot} 		sysuse sp500.dta, clear
					if ${histogram_plot} 	sysuse auto.dta, clear
					if ${multiple_graphs}	sysuse auto, clear
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

	

* #5 - Plot the  diagram		

**#     i. Scatter plot
*------------------------------------------------------------------------------*
		if ${scatter_plot} {
		    
				* Scatter plot of population vs median age by region
				* Linear fit overlaid for every region
				twoway scatter 	pop medage, ///
								by(region, rescale title("Scatter plot of population vs median for every region") subtitle("With linear fit overlaid") legend(cols(1) position(1) bplacement(neast)) note("Two-way scatter plot in groups of data with linear fit overlaid.")) ///
								mcolor(green%50) ///
								 || ///
						lfit 	pop medage, by(region) lcolor(maroon%80)
						
				
		}
		
**#     ii. Line plot
*-------------------------------------------------------------------------------*
		if ${line_plot}{
// 		    * Line plots for low and high stock prices with the median of date plotted as a line
			summarize date, detail
			local date_median = r(p50)
			display `date_median' 
			loc text_location = `date_median' + 23 // This is the location where the median of date is placed
//			
			sysuse sp500.dta, clear
			br
			* The trading volume of stock price on a given trading day is classified as high, medium and low 
			* Finding the percentile for volume to classify according to thresholds
			summarize volume, detail
			* Based on the percentiles, let's define:
			* - Low Volume: below the 33rd percentile
			* - Medium Volume: between the 33rd and 67th percentiles
			* - High Volume: above the 67th percentile

			* Generate a new categorical variable for volume categories
			gen volume_cat = .
			replace volume_cat = 1 if volume < r(p25)   /* Low Volume */
			replace volume_cat = 2 if volume >= r(p25) & volume <= r(p75)   /* Medium Volume */
			replace volume_cat = 3 if volume > r(p75)   /* High Volume */

			* Label the new categorical variable
			label define volumelabel 1 "Low Volume" 2 "Medium Volume" 3 "High Volume"
			label values volume_cat volumelabel
			
			
			** Back to the main code
			** xline(`date_median', lcolor(green))
			twoway 	line 	low date, lpattern(dash) lcolor(purple%70)  || 	///
					line 	high date, lpattern(solid) lcolor(red%50) 		///
							by(volume_cat, rescale ///
							title("Daily low and high stock price") ///
							note("Two-way line graph in groups of data" "Median of date shown in vertical line") ///
							legend(cols(1)  ring(0) bplacement(seast))) ///
							graphregion(color(white))	///
							xline(`date_median', lcolor(green))
							
							
			//text(1050 `text_location' "Median" "of" "date" , justification(left) size(2.5)) 
		}
		


	
**#     iii. Histogram
*-------------------------------------------------------------------------------*
		if ${histogram_plot}{
			* The graphs in one graph region of domestic and foreign price with title and subtitle in the graph
			* Note that we labelled the variable rep78 with values from repair_record to generate the graph.
			* What if we did not label the variable and instead created a new variable with respective values
			* The new variable rep78_name is generated with for rep_78 with corresponding values 
			gen rep78_name = ""
			replace rep78_name = "Poor repair record (frequent repairs needed)" if rep78 == 1
			replace rep78_name = "Fair repair record" if rep78 == 2
			replace rep78_name = "Average repair record" if rep78 == 3
			replace rep78_name = "Good repair record" if rep78 == 4
			replace rep78_name = "Excellent repair record (few or no repairs needed)" if rep78 == 5
			
			* Now if the graph is generated with rep78_name with the by group as below:
			twoway ///
					histogram price if foreign,  width(500) start(2000) color(red%30) freq  || ///
					histogram price if ~foreign,  width(500) start(2000) color(green%30) freq ///
					legend(order(1 "Foreign" 2 "Domestic"))  ///
					by(rep78_name, rescale note("Two-way histogram") title("Histogram price for each foreign and domestic car type")) ///
					xsize(23) ysize(10) 
					
					
		}	

			
**#     iv. Multiple diagram
*-------------------------------------------------------------------------------*
		
		if ${multiple_graphs}{
				
				* Scatter diagrams of mpg vs weight are generated for each car type(domestic and foreign) 
				* The overall median of weight is plotted as a vertical line in each graph
				* The median of weight of each group of data (domestic and foreign) is plotted as a vertical line
				
				egen weight_median_by_foreign = median(weight), by(foreign)	 //The median of weight for each subgroup of data of variable foreign
				egen max = max(mpg) 	//The max value of mpg is the line length of the bar diagram which contains the median
				egen weight_median = median(weight)	 //Median of overall weight
				
				scatter ///
						mpg weight, mcolor(emerald) ///
						by(foreign, note("Two-way multiple graphs combined" "Medians shown by vertical lines") ///
						title("Scatter diagrams of mpg vs weight for each car type") subtitle("Domestic and Foreign car type")) ///
						legend(order(1 "Mileage(mpg)" 2 "Median" 3 "Overall median") pos(5) ring(0)) ///
				|| bar max  weight_median_by_foreign, barwidth(0) lpattern(dash) color(black%90) ///
				|| bar max  weight_median, barwidth(0) lpattern(dash) color(red%90) ///
				
				
						
		}
		
**# 6. Save the  diagram
*------------------------------------------------------------------------------*

		** Saving the graph plot with specific width and height
		if ${scatter_plot} 			graph export "figures/two_way_scatter_plot_with_by_group.jpg", 	width(600) height(450) replace
		if ${line_plot} 			graph export "figures/two_way_line_plot_with_by_group.jpg", 	width(600) height(450) replace
		if ${histogram_plot} 		graph export "figures/two_way_histogram_with_by_group.jpg", 	width(600) height(450) replace
		if ${multiple_graphs} 		graph export "figures/two_way_bar_diagram_with_by_group.jpg", 	width(600) height(450) replace
	 
	
**# End of file	

	
	