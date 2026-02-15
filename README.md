# Prison Gerrymandering Exploration for Tennessee's State Lesgislative Districts

## Overview

This project evaluates Tennessee’s legislative districts for effects of prison gerrymandering.

**Prison gerrymandering** (or **prison malapportionment**) refers to the phenomenon where the federal census records the home address of prison inmates as the prison where they are incarcerated, rather than their pre-incarceration address. Census population data is used to inform state legislative district boundaries; state law dictates that districts have roughly equal populations. This can result in an inflation of voting power in areas near large prisons (since prison inmates are disenfranchised in Tennessee) and a dilution of voting power in areas where prison inmates call home. A fantastic summary of prison gerrymandering can be found [here](https://redistrictingdatahub.org/resources/prison-gerrymandering/). 

To evaluate the effects of prison malapportionment in Tennessee, this project uses prison data from [TN.gov](tn.gov), as well as population data from [Redistricting Data Hub](redistrictingdatahub.org). 

## Motivation

Prison gerrymandering leads to inequities in the democratic process, and it can be argued that it leads to a violation of the "one person, one vote" idea put forth in the Equal Protection Clause of the Fourteenth Amendment.

Despite the serious implications when it comes to voting power, prison gerrymandering is still a fairly obscure phenomenon. I wanted to undertake this project to bring more awareness to the issue, even if no evidence for prison gerrymandering exists in Tennessee, as it does affect many states in the US. 

## Research Questions

This project addresses the following research questions:

* Given that Tennessee's state legislative districts suffer from prison malapportionment, is the effect substantially greater for certain political parties, demographics, or populations (i.e. do districts with prisons differ from districts without prisons in a statistically significant way)?
* Does the presence of one or more prisons significantly increase the "voting strength" for voters in that district?
  * A "voting strength" metric can be calculated for each district based on the ratio of district residents who are eligible to vote to the total number of residents (including the incarcerated population). Linear regression tests can tell us whether the presence of a prison has a statistically significant effect on voting strength in state legislative districts. 
* After reallocating the prison population among all districts, are the district populations still substantially equal? Is the resulting population deviation significantly greater for certain political parties, demographics, or populations?
  * Population deviation is calculated as the percent difference from an 'ideal' district's population, if each district had an equal population. Low population deviation is important for fair access to government representation. 

## Prior Work 

Prison gerrymandering has already been recognized at the county level in Tennessee. A 2016 law (Tenn. Code Ann. § 5-1-111) allows counties to exclude prison populations during their redistricting process, according to [this 2021 article](https://www.prisonersofthecensus.org/news/2021/11/04/tn_redistricting/) from prisonersofthecensus.org. However, this change is one that counties must voluntarily opt in to; it is not a requirement. No legislation preventing prison gerrymandering has been passed at the state level in Tennessee (see the graphic in [this article](https://www.prisonersofthecensus.org/news/2021/10/26/state_count/). State-level redistricting in Tennessee continues to use census population data that includes prison populations. 

There are no publicly available evaluations of prison gerrymandering for Tennessee’s state legislative districts.
	 	 	 	
## R Shiny App

The accompanying [R Shiny app](https://abigail-ezell.shinyapps.io/TN_Prison_Gerrymandering_ShinyApp/) allows users to visualize Tennessee’s current state house and state senate district boundaries. Districts that contain one or more state prisons are shaded slighly darker and are outlined in blue. The location of each of Tennessee's 14 state prison has a teardrop marker that can be clicked to reveal the prison's name, capacity, year opened, and city. Hovering over a district will outline the district's boundary and show the district number; clicking anywhere in the district will populate a sidebar panel with population statistics, partisan makeup, and race makeup for that district.

 The application is intended to be used by state lawmakers or anyone else who is interested in exploring the effects of prison malapportionment in Tennessee. 

## Data Sources

The shapefiles containing state legislative district boundaries came from [Redistricting Data Hub](redistrictingdatahub.org) (state house districts [here](https://redistrictingdatahub.org/dataset/2022-tennessee-house-of-representatives-districts-approved-plan/) and state senate districts [here](https://redistrictingdatahub.org/dataset/2022-tennessee-senate-districts-approved-plan/). 
Population numbers for TN state legislative districts are drawn from 2023 CVAP (Citizen Voting  Age Population) datasets from [Redistricting Data Hub](redistrictingdatahub.org) (state house [here](https://redistrictingdatahub.org/dataset/tennessee-2023-state-legislative-district-lower-cvap-data-2023/) and state senate [here](https://redistrictingdatahub.org/dataset/tennessee-2023-state-legislative-district-upper-cvap-data-2023/). 
Partisan breakdown of TN state legislative districts comes from voter registration data gathered during the 2024 election (dataset here). 
When necessary, precinct-level data is aggregated to state legislative district using precinct mapping information from [Dave's Redistricting](davesredistricting.org). 

Partisan data was drawn from [Dave's Redistricting](davesredistricting.org). Percentages of Democratic and Republican voters is a composite of the following races:

* President 2020
* President 2024
* Senator 2020
* Senator 2024
* Governor 2022 

Information about TN state prisons, including address, capacity, and year opened data, comes from [TN.gov](https://www.tn.gov/correction/state-prisons/state-prison-list.html). Any information not available on [TN.gov](https://www.tn.gov/correction/state-prisons/state-prison-list.html) was obtained from [Wikipedia](https://www.wikipedia.org/). 

## Limitations

Due to a lack of data on inmates’ pre-incarceration addresses, redistributing the prison population among Tennessee's districts was necessarily an approximation. The prison population was distributed among state legislative districts, weighted by population. 

This project uses prison capacity as a proxy for prison population, due to a lack of data on inmate totals per prison. 

For district population data, we used 2023 population projections based on the 2020 census, which were the most recent population projections available.

## Conclusions

The data does not support the idea that state legislative districts containing one or more prisons differ substantially from districts without prisons. Analysis was performed on the following following populations of interest, and all effects lacked statistical significance:
* Racial makeup (percent of the population that is white)
* Gender makeup (percent of the population that is male)
* Partisan lean (percent of the population that is Democratic)
* Age makeup (percent of the population that is under 30 and percent of the population that is over 65)
* Political engagement (voter turnout in the 2024 election)

Additionally, we found that the presence of a prison does not have a statistically significant effect on a district's voting strength. The effect was examined both before and after reallocating the prison population, and was not statistically significant in either case. This makes sense, given the relatively small percentage of prison inmates compared to the total population of eligible voters (the largest ratio for a state house district is 0.0698; for a state senate district it is 0.0305). For districts with smaller populations, such as county-level political offices, the effect of prisons on voting strength is more pronounced. 

Finally, we found that after reallocating the prison population, 2 of the resulting state house districts slightly exceeded the generally accepted 10% threshold for population deviation. This indicates that simply changing the way the census records inmates' addresses is not enough to remediate the issue of prison gerrymandering; at least for state house districts, our analysis suggests that district boundaries might need to be redrawn to fulfill the substantially equal population requirement. 

Furthermore, we analyzed the relationship between population deviation (after reallocating prison inmates) and the following populations of interest:
* Racial makeup (percent of the population that is white)
* Gender makeup (percent of the population that is male)
* Partisan lean (percent of the population that is Democratic)
* Age makeup (percent of the population that is under 30 and percent of the population that is over 65)
* Political engagement (voter turnout in the 2024 election)

There were a few statistically significant results:
* For state senate districts,
  * For each additional percent of population deviation, the percentage of the population that is under 30 increases by an average of 0.136%.
  * For each additional percent of population deviation, the percent of the population that is white increases by an average of 2.7%.
  * For each additional percent of population deviation, the voter turnout percentage decreases by an average of 1%.

* For state house districts,
  * For each additional percent of population deviation, the percent of the population that is 65 or older decreases by about 0.36%.
  * For each additional percent of population deviation, the percentage of the population that is male increases by 0.32, on average.

Overall, state senate districts with a population that is higher than the ideal tend to be younger, more white, and less politically active. State house districts with populations that are higher than the ideal tend to be younger and more male. This shows that the effects of prison gerrymandering are stronger for certain populations of interest. 
