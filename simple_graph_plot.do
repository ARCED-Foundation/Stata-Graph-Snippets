                                                                                                                                                                                                      /*
╔═══════════════════════════════════════════════════════════════════════════════╗                                                                                                                               
║               __  __  ___ __     _____          __    ___ __                  ║
║           /\ |__)/  `|__ |  \   |__/  \|  ||\ ||  \ /\ ||/  \|\ |             ║
║          /~~\|  \\__,|___|__/   |  \__/\__/| \||__//~~\||\__/| \|             ║
║         www.arced.foundation;  https://github.com/ARCED-Foundation            ║
║                                                                               ║
║-------------------------------------------------------------------------------║
║  FILE NAME:      simple_graph_plot.do  	       			                    ║                                           
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
						
	TITLE: graph plot diagram
	
	This code plots different simple graphs such as scatter diagram, line plot, histogram and bar diagram.
	The type of graph can be selected through switches.
	The type of dataset used -(csv, xlsx or dta) can also be selected through switches.

------------------------------------------------------------------------------*/

	* Install user written package
	*-------------------------------
	cap which cleanp  lots
	if _rc net install cleanplots, from("https://tdmize.github.io/data/cleanplots")

	
/**
 *************** Table of contents: ********************************
 * #1 - Define folder : This will define the folder location of dataset
 * #2 - Choose the type of graph : The type of graph will be chosen such as scatter plot, line graph, histogram or bar diagram
 * #3 - Choose dataset type : The type of the dataset will be selected whether it is a file with extension dta, csv or xlsx
 * #4 - Set graph theme (optional)
 * #5 - Plot the  diagram
 * 			#i -  Scatter plot
 * 			#ii - Line plot
 * 			#iii - Histogram
 * 			#iv - Bar diagram
 * #6 - Save the diagram
 */
	
**# 1. Define folder
*------------------------------------------------------------------------------*
		
		gl rawdatafolder = "/DROPBOX/your_path"

		
		
**# 2. Choose the type of graph
*------------------------------------------------------------------------------*
		* The type of simple diagram to be plotted
		gl scatter_plot 				0		// A simple scatter plot diagram
		gl line_plot 					0		// A simple line plot daigram
		gl histogram_plot				0		// A simple histogram plot
		gl bar_diagram					0		// A simple bar graph diagram
		
		
**# 3. Choose dataset type
*------------------------------------------------------------------------------*

		gl dataset_csv  	 			0			// For using data file with csv extension
		gl dataset_xlsx  				0			//For using data file with xlsx extension 
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
					if ${bar_diagram} 		webuse nhanes2l, clear
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
		
**# 5.  Plot the  diagram
*----------------------------------*
		
**#     i. Scatter plot
*------------------------------------------------------------------------------*
		if ${scatter_plot} {
			
			* Scatter plot for mpg verses price with custom design
			* Custom designs are:
			*1. Show markers as hollow circles with size proportional to frequency weight variable "mpg"
			*2. Colour green with 50% opacity
			*3. Adding y title in two separate lines
			*4. Suppress grid lines at y axis, showing y axis at steps of 5 and showing x axis in steps of 1000 with vertical angle
			*5. Adding title to the graph
			*6. Note is added to the graph
			scatter 	mpg price [fweight=mpg], ///
						mcolor(green%50) ///
						ytitle("Mileage(mpg)" "Miles per gallon of fuel the car can travel") ///
						ylabel(0(5)40,nogrid) xlabel(0(1000)15000, angle(vertical)) ///
						title("This is {it:scatter plot} for mpg and price") ///
						note("Simple scatter plot diagram")
		}
		

**#     ii. Line plot
*-------------------------------------------------------------------------------*
		if ${line_plot}{
			* Line plot for opening price of stock verses date with custom design
			* Custom designs are:
			*1. Dashed line style 
			*2. Purple coloured line with 30% opacity
			*3. The x-axis is plotted at steps of 10 dates and y-axis at steps of 50
			*4. Title and subtitle 
			*5. Note is added to the graph
			summarize date
			loc max_date = r(max)
			loc min_date = r(min)
			
			line 	open date, lpattern(dash) lcolor(purple%70) ///
					xlabel(`max_date'(10)`min_date', angle(vertical)) ylabel(900(50)1600) ///
					title("Daily opening stock price") ///
					subtitle("500 of the largest comapnies listed on U.S. stock echanges") ///
					note("Simple line plot diagram")
		}
		


	
**#     iii. Histogram
*-------------------------------------------------------------------------------*
		if ${histogram_plot}{
			* 
			* The histogram of frequency of price is plotted for the foreign car type
			* The custom designs are:
			* 1. The width of the bars are 500
			* 2. The color specification is red with 40% opacity
			* 3. The histogram is scaled to frequency
			* 4. In the x axis, the values are labelled in steps of 1000 ranging between 0 and max price and placed vertically
			* 5. Title and subtitle
			* 6. Note is added to the graph
			* The custom designs are:
			sum price
			local max_price = r(max)
		
			histogram 	price if foreign,  ///
						width(500) color(red%40) freq  ///
						xlabel(0(1000)`max_price', angle(vertical)) ///
						title("Frequency distribution of price") /// 
						subtitle("For foreign car type") ///
						note("Simple histogram plot diagram")
		}	

			
**#     iv. Bar diagram
*-------------------------------------------------------------------------------*
		if ${bar_diagram}{
		    *A bar chart for the five categories of hlthstat (Health status)
			* Custom designs are:
			* 1. The horizontal bar chart is used
			* 2. The title of the graph is added
			* 3. Frequency of each category is displayed using a medium-sized, black font.
			* 4. Note is added to the graph
			graph 	hbar (count), over(hlthstat)          ///
					title("Categories of health status")     ///
					blabel(bar, size(medium) color(black)) ///
					note("Simple bar diagram")
		}	
		
**# 6. Save the  diagram
*------------------------------------------------------------------------------*

		** Saving the graph plot with specific width and height
		if ${scatter_plot} 		graph export "figures/scatter_plot.jpg", 	width(600) height(450) replace
		if ${line_plot} 		graph export "figures/line_plot.jpg", 		width(600) height(450) replace
		if ${histogram_plot} 	graph export "figures/histogram_plot.jpg", 	width(600) height(450) replace
		if ${bar_diagram} 		graph export "figures/bar_diagram.jpg",		width(600) height(450) replace
	 
	
	
**# End of file	

	
	