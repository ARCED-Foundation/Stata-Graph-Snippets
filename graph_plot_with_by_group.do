                                                                                                                                                                                                      /*
╔═══════════════════════════════════════════════════════════════════════════════╗                                                                                                                               
║               __  __  ___ __     _____          __    ___ __                  ║
║           /\ |__)/  `|__ |  \   |__/  \|  ||\ ||  \ /\ ||/  \|\ |             ║
║          /~~\|  \\__,|___|__/   |  \__/\__/| \||__//~~\||\__/| \|             ║
║         www.arced.foundation;  https://github.com/ARCED-Foundation            ║
║                                                                               ║
║-------------------------------------------------------------------------------║
║  FILE NAME:      graph_plot_with_by_group.do  	                            ║                                           
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
						
	TITLE: graph plot diagram with by group
	
	This code plots different graphs such as scatter diagram, histogram, bar diagram 
	over sub-groups of data of any variable.
	The switches is used to select the type of graph to be plotted.
	The type of dataset used -(csv, xlsx or dta) csn also be selected through switches.

------------------------------------------------------------------------------*/

  

	
/**
 *************** Table of contents: ********************************
 * #1 - Define folder : This will define the folder location of dataset
 * #2 - Choose the type of graph : The type of graph will be chosen such as scatter plot, line graph, histogram or bar diagram
 * #3 - Choose dataset type : The type of the dataset will be selected whether it is a file with entension dta, csv or xlsx
 * #4 - Set graph theme : This is used if the default scheme will be used or custom graph theme
 * #5 - Plot the  diagram
 * 			#i -  Scatter plot
 * 			#ii - Line plot
 * 			#iii - Histogram
 *	 		#iv - Bar diagram
 * #6 - Save the graph plot diagram
 */
 
 
	* Install user written package
	*-------------------------------
	cap which cleanp  lots
	if _rc net install cleanplots, from("https://tdmize.github.io/data/cleanplots")
	
**# 1. Define folder
*------------------------------------------------------------------------------*
		
		gl rawdatafolder = "/DROPBOX/your_path"

		
		
**# 2. Choose the type of graph
*------------------------------------------------------------------------------*
		* The type of scatter plot to be plotted
		gl scatter_plot 				1		// Scatter plot with grouped data
		gl line_plot 					0		// Line plot with grouped data
		gl histogram_plot				0		// Histogram plot with grouped data
		gl bar_diagram					0		// Bar Diagram with categories
		
		
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
					if ${bar_diagram} 		use "https://www.stata-press.com/data/r18/nlsw88", clear
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
			
			* Scatter plot for mpg verses price by foreign variable with custom design
			* Custom designs are:
			*1. Show markers as hollow circles with size proportional to frequency weight variable "mpg"
			*2. Colour green with 50% opacity
			*3. Adding y title in two separate lines
			*4. Suppress grid lines at y axis, showing y axis at steps of 5 and showing x axis in steps of 1000 with vertical angle
			*5. Adding title to the graph
			*6. Rescaling the x and y axis
			*7. Add note to the graph
			scatter ///
				mpg price [fweight=mpg], ///
				mcolor(green%50) ///
				ytitle("Mileage(mpg)" "Miles per gallon of fuel the car can travel") ///
				ylabel(0(5)40,nogrid) xlabel(0(1000)15000, angle(vertical)) ///
				by(foreign, title("This is {it:scatter plot} for mpg and price") rescale note("Scatter plot in subgroups of data"))
				
				
		}
		

**#     ii. Line plot
*-------------------------------------------------------------------------------*
		if ${line_plot}{
			
			* Dividing the volume to different levels(low, medium and high) to use in by group
			
			* Find the percentiles for volume to define thresholds
			summarize volume, detail

			* Based on the percentiles, let's define:
			* - Low Volume: below the 25th percentile
			* - Medium Volume: between the 25th and 75th percentiles
			* - High Volume: above the 75th percentile
			
			* Generate a new categorical variable for volume categories
			gen volume_cat = 1 if volume < r(p25)  							/* Low Volume */
			replace volume_cat = 2 if volume >= r(p25) & volume <= r(p75)   /* Medium Volume */
			replace volume_cat = 3 if volume > r(p75)   					/* High Volume */

			* Label the new categorical variable
			label define volumelabel 1 "Low Volume" 2 "Medium Volume" 3 "High Volume"
			label values volume_cat volumelabel

			
			* The main graph code
			* Line plot for opening price of stock verses date for each trading volume level
			* Custom designs are:
			*1. Dashed line style 
			*2. Purple coloured line with 30% opacity
			*3. Changing the size of x and y graph
			*4. The x-axis design customizations: 
			*		a. The x labels are plotted at steps of 20 dates between minimum and maximum date
			*		b. The labels are plotted in vertical way
			*		c. The size of the labels is 70% of the default size
			*5. The y axis customizations:
			*		a. The y labels are plotted at steps of 100 startng from 900 and ending at 1500
			*		b. The y label is placed in horizontal way
			*		c. The size of labels is scaled t0 .55 times their original size
			*		d. The grid line is included corresponding to the y-axis tick marks
			*		e. The style of grid lines is dashed
			*4. Title and subtitle is added to the graph
			*5. Distinct x and y axis
			*6. Note is added to the graph
			summarize date
			loc max_date = r(max)
			loc min_date = r(min)
			
			line 	open date, lpattern(dash) lcolor(purple%70) ysize(7) xsize(9) ///
					xlabel(`max_date'(20)`min_date', angle(vertical) labsize(*.7)) ///
					ylabel(900(100)1500, angle(horizontal) labsize(*.55) grid gstyle(dash)) ///
						 by(volume_cat, ///
							title("Daily opening stock price") ///
							subtitle("500 of the largest comapnies listed on U.S. stock echanges") ///
							rescale note("Graph by every trading volume level" "Trading volume is an indicator of market activity."))
		}
		


	
**#     iii. Histogram
*-------------------------------------------------------------------------------*
		if ${histogram_plot}{
 
			* The histogram of frequency of price is plotted for each of the distinct foreign and domestic car type
			* The custom designs are:
			* 1. The width of the bars are 500
			* 2. The color specification is red with 40% opacity
			* 3. The histogram is scaled to frequency
			* 4. Title and subtitle is added to the graph
			* 5. Note is added to the graph
			* The custom designs are:
		
			histogram 	price,  ///
						width(500) color(red%40) freq  ///
						by(foreign, ///
						   title("Frequency distribution of price") ///
						   subtitle("For foreign car type") ///
						   note("Histogram in subgroups of data"))
		}	
			
**#     iv. Bar diagram
*-------------------------------------------------------------------------------*
		if ${bar_diagram}{
		    * The dataset contains information on 2,246 women
			* A bar graph is plotted for every married and unmarried women of college and not college graduate who lives or does not live in MSA
			
			* Custom designs are:
			* 1. The horizontal bar chart is used
			* 2. The title and subtitle of the graph is added
			* 3. Note is added to the graph
			graph 	bar (mean) wage, over(smsa) over(married) over(collgrad) ///
					title("Average hourly wage, 1988, women aged 34 to 46") ///
					subtitle("by college graduation, marital status, and SMSA residence") ///
					note("Source: 1988 data from NLS, US Dept. of Labor, Bureau of Labor Statistics") 
			
		}	
		
**# 5. Save the  diagram
*------------------------------------------------------------------------------*

		** Saving the graph plot with specific width and height
		if ${scatter_plot} 		graph export "figures/scatter_plot_with_by_group.jpg", 		width(600) height(450) replace
		if ${line_plot} 		graph export "figures/line_plot_with_by_group.jpg", 		width(600) height(450) replace
		if ${histogram_plot} 	graph export "figures/histogram_plot_with_by_group.jpg", 	width(600) height(450) replace
		if ${bar_diagram} 		graph export "figures/bar_diagram_with_by_group.jpg", 		width(600) height(450) replace
	 
	 
	
	
	
**# End of file	

	
	