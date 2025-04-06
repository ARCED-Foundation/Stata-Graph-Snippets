                                                                       /*
╔═══════════════════════════════════════════════════════════════════════════════╗                                                                                                                               
║               __  __  ___ __     _____          __    ___ __                  ║
║           /\ |__)/  `|__ |  \   |__/  \|  ||\ ||  \ /\ ||/  \|\ |             ║
║          /~~\|  \\__,|___|__/   |  \__/\__/| \||__//~~\||\__/| \|             ║
║         www.arced.foundation;  https://github.com/ARCED-Foundation            ║
║                                                                               ║
║-------------------------------------------------------------------------------║
║  FILE NAME:      graph_combine.do  	                            ║                                           
║-------------------------------------------------------------------------------║
║  AUTHOR:         Fabliha Anber, SoTLab                                        ║
║  CONTACT:        fabliha.anber@arced.foundation                               ║
║-------------------------------------------------------------------------------║
║  CREATED:        07 Oct 2024                                                  ║
║-------------------------------------------------------------------------------║
║-------------------------------------------------------------------------------║ 			
║ 			     * ARCED Stata code snippet template *							║
╚═══════════════════════════════════════════════════════════════════════════════╝                                                                                                                         */
                                                                                */

                         										
/*------------------------------------------------------------------------------
								PURPOSE
						------------------------
						
	TITLE: graph combine diagram
	
	This code combines different graphs in two ways:
		i) Combine distinct graphs together(e.g., foreign and domestic car price distributions) into a single window
		ii) Combine distinct graphs in a loop, grouping them by specific categories (e.g., repair record)
	The type of graph can be selected through switches.
	The type of data format (csv, xlsx or dta) can be selected through using switches.

------------------------------------------------------------------------------*/


	
/**
 *************** Table of contents: ********************************
 * #1 - Defne folder : This will define the folder location of dataset
 * #2 - Choose the type of graph : The type of graph will be chosen such whether we want to combine distinct graphs or combine graphs in a loop
 * #3 - Choose dataset type : The type of the dataset will be selected whether it is a file with entension dta, csv or xlsx
 * #4 - Combine the graphs
 * 			#i -  Combine distinct graphs: This block of code combines the histograms of prices for foreign and domestic cars into a single graph window
 * 			#ii - Combine graphs in a loop: This block of code generates and combines sub-graphs of price distributions for foreign and domestic cars, based on each repair record(rep78), into a single graph window.
 * #5 - Save the graph plot diagram
 */
	
**# 1. Define folder
*------------------------------------------------------------------------------*
		
		gl rawdatafolder = "/DROPBOX/your_path"

		
		
**# 2. Choose the type of graph
*------------------------------------------------------------------------------*
		* The type of graph combination
		gl combine_distinct_graph 		0		// Combine distinct graphs created together
		gl combine_graph_in_a_loop		1		// Combine graphs in a loop
		
		
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
			if ${dataset_example}	sysuse auto.dta, clear

			
**# 4. Combine the graphs
*------------------------------------------------------------------------------*		

		if ${combine_distinct_graph}{
				* Combining the histogram of prices for foreign and domestic type
				histogram price if foreign, width(500) start(2000) color(red%30) disc freq name(foreign, replace)
				histogram price if ~foreign, width(500) start(2000) color(green%30) disc freq name(domestic, replace)
		 
				graph combine foreign domestic, 	///
				col(1)	///
				title("Price Histogram for Foreign and Domestic Car Types") ///
				note("This graph combined histograms of prices of foreign and domestic cars.")
			
		}
		
		
		
		if ${combine_graph_in_a_loop} {
			* Each of the sub-graphs the price of domestic and foreign per repair record 1978 can be combined together as below
			levelsof rep78
			foreach level in `r(levels)'{
				di "`level'"
				twoway (histogram price if (foreign & rep78==`level'), width(500) start(2000) color(red%30) disc freq) ///
					   (histogram price if (!foreign &  rep78==`level'), width(500) start(2000) color(green%30) disc freq), ///
							   legend(order(1 "Foreign" 2 "Domestic")) name(graph_`level', replace) title("For repair record `level'")
					local graphnames `graphnames' graph_`level'
					di "graph_`level'"
			}
			graph combine 	`graphnames', ///
							col(3)		  ///
							ysize(10) xsize(16.5) ///
							title("Histogram of Prices of Domestic and Foreign Cars") ///
							subtitle("For Each Repair Record(1978)") ///
							note("This graph combines histograms in a loop")
				
		}
		
		

		
**# 5. Save the  diagram
*------------------------------------------------------------------------------*
		
		** Saving the graph plot with specific width and height
		if ${combine_distinct_graph} 		graph export "figures/combined_distinct_graph.png", width(600) height(450) replace
		if ${combine_graph_in_a_loop} 		graph export "figures/combined_graph_in_a_loop.png", width(600) height(450) replace
