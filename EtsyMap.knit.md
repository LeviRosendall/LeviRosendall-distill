---
title: "EtsyMap"
---





<div class="layout-chunk" data-layout="l-body">
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class='co'>#installing all of the packages needed for this code to run. Much of it was added as needed.</span>
<span class='kw'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='op'>(</span><span class='va'><a href='https://readxl.tidyverse.org'>readxl</a></span><span class='op'>)</span>
<span class='kw'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='op'>(</span><span class='va'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='op'>)</span>
<span class='kw'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='op'>(</span><span class='va'><a href='https://github.com/gavinrozzi/zipcodeR/'>zipcodeR</a></span><span class='op'>)</span>
<span class='kw'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='op'>(</span><span class='va'><a href='https://github.com/UrbanInstitute/urbnmapr'>urbnmapr</a></span><span class='op'>)</span>
<span class='kw'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='op'>(</span><span class='va'><a href='https://gganimate.com'>gganimate</a></span><span class='op'>)</span>
<span class='kw'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='op'>(</span><span class='va'><a href='https://r-spatial.github.io/sf/'>sf</a></span><span class='op'>)</span>
<span class='kw'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='op'>(</span><span class='va'><a href='https://github.com/thomasp85/transformr'>transformr</a></span><span class='op'>)</span>
<span class='kw'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='op'>(</span><span class='va'><a href='https://lubridate.tidyverse.org'>lubridate</a></span><span class='op'>)</span>
<span class='kw'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='op'>(</span><span class='va'><a href='https://plotly-r.com'>plotly</a></span><span class='op'>)</span>
<span class='va'>FinalEtsy</span> <span class='op'>&lt;-</span> <span class='fu'>read_csv</span><span class='op'>(</span><span class='st'>'~/STA 518/ETSY2021/FinalEtsy.csv'</span><span class='op'>)</span>
</code></pre></div>

</div>



<div class="layout-chunk" data-layout="l-body">
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class='co'>#Using urbnmapr to get the geometry of states added to this dataset, matched using state_abbv</span>
<span class='va'>State_Ind</span> <span class='op'>&lt;-</span> <span class='fu'>right_join</span><span class='op'>(</span><span class='fu'><a href='https://rdrr.io/pkg/urbnmapr/man/get_urbn_map.html'>get_urbn_map</a></span><span class='op'>(</span>map <span class='op'>=</span> <span class='st'>"states"</span>, sf <span class='op'>=</span> <span class='cn'>TRUE</span><span class='op'>)</span>,
                          <span class='va'>FinalEtsy</span>,
                          by <span class='op'>=</span> <span class='fu'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='op'>(</span><span class='st'>"state_abbv"</span> <span class='op'>=</span> <span class='st'>"Ship State"</span><span class='op'>)</span><span class='op'>)</span>

<span class='co'>#filtering all non-US orders and Puerto Rico orders out of the dataset</span>
<span class='co'>#changing date to be a date, not char</span>
<span class='co'>#creating a numeric variable called day that is days since start that the order was placed, and arranging the data by day</span>
<span class='va'>State_Ind_Year</span> <span class='op'>&lt;-</span> <span class='va'>State_Ind</span> <span class='op'>%&gt;%</span> 
  <span class='fu'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='op'>(</span><span class='va'>`Ship Country`</span><span class='op'>==</span><span class='st'>'United States'</span> <span class='op'>&amp;</span> <span class='va'>`state_abbv`</span> <span class='op'>!=</span> <span class='st'>'PR'</span><span class='op'>)</span> <span class='op'>%&gt;%</span> 
  <span class='fu'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='op'>(</span>actualDate<span class='op'>=</span><span class='fu'><a href='https://rdrr.io/r/base/as.Date.html'>as.Date</a></span><span class='op'>(</span><span class='fu'><a href='https://lubridate.tidyverse.org/reference/ymd.html'>mdy</a></span><span class='op'>(</span><span class='va'>`Sale Date`</span><span class='op'>)</span><span class='op'>)</span><span class='op'>)</span> <span class='op'>%&gt;%</span> 
  <span class='fu'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='op'>(</span>day<span class='op'>=</span><span class='va'>actualDate</span><span class='op'>-</span><span class='fu'><a href='https://lubridate.tidyverse.org/reference/ymd.html'>mdy</a></span><span class='op'>(</span><span class='st'>'07-28-2021'</span><span class='op'>)</span><span class='op'>)</span> <span class='op'>%&gt;%</span> 
  <span class='fu'><a href='https://dplyr.tidyverse.org/reference/arrange.html'>arrange</a></span><span class='op'>(</span><span class='va'>day</span><span class='op'>)</span>
</code></pre></div>

</div>




<div class="layout-chunk" data-layout="l-body">
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class='co'>#Filters original data by US only</span>
<span class='co'>#creates a new data column and arranges by it</span>
<span class='co'>#duplicates state column, groups by state and date</span>
<span class='co'>#summarises to get sum of signs sold in day, keeps date and arranges by it.</span>
<span class='va'>AnimationDataTry</span> <span class='op'>&lt;-</span> <span class='va'>FinalEtsy</span> <span class='op'>%&gt;%</span> 
  <span class='fu'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='op'>(</span><span class='va'>`Ship Country`</span><span class='op'>==</span><span class='st'>"United States"</span><span class='op'>)</span> <span class='op'>%&gt;%</span> 
  <span class='fu'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='op'>(</span>date<span class='op'>=</span><span class='fu'><a href='https://lubridate.tidyverse.org/reference/ymd.html'>mdy</a></span><span class='op'>(</span><span class='va'>`Sale Date`</span><span class='op'>)</span><span class='op'>)</span> <span class='op'>%&gt;%</span> 
  <span class='fu'><a href='https://dplyr.tidyverse.org/reference/arrange.html'>arrange</a></span><span class='op'>(</span><span class='va'>date</span><span class='op'>)</span> <span class='op'>%&gt;%</span> 
  <span class='fu'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='op'>(</span>state<span class='op'>=</span><span class='va'>`Ship State`</span><span class='op'>)</span> <span class='op'>%&gt;%</span> 
  <span class='fu'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='op'>(</span><span class='va'>state</span>, <span class='va'>date</span><span class='op'>)</span> <span class='op'>%&gt;%</span> 
  <span class='fu'><a href='https://r-spatial.github.io/sf/reference/tidyverse.html'>summarise</a></span><span class='op'>(</span>Total_Sold<span class='op'>=</span><span class='fu'><a href='https://rdrr.io/r/base/sum.html'>sum</a></span><span class='op'>(</span><span class='va'>`Number of Items`</span><span class='op'>)</span>, <span class='va'>date</span><span class='op'>)</span> <span class='op'>%&gt;%</span> 
  <span class='fu'><a href='https://dplyr.tidyverse.org/reference/arrange.html'>arrange</a></span><span class='op'>(</span><span class='va'>date</span><span class='op'>)</span>

<span class='co'>#removes any duplicate rows</span>
<span class='va'>NoDup</span> <span class='op'>&lt;-</span> <span class='va'>AnimationDataTry</span> <span class='op'>%&gt;%</span> <span class='fu'><a href='https://dplyr.tidyverse.org/reference/distinct.html'>distinct</a></span><span class='op'>(</span><span class='op'>)</span>

<span class='co'>#Uses summarise and group_by to get a column with all state names</span>
<span class='va'>stateListData</span> <span class='op'>&lt;-</span> <span class='va'>State_Ind_Year</span> <span class='op'>%&gt;%</span> 
  <span class='fu'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='op'>(</span><span class='va'>state_abbv</span><span class='op'>)</span> <span class='op'>%&gt;%</span> 
  <span class='fu'><a href='https://r-spatial.github.io/sf/reference/tidyverse.html'>summarise</a></span><span class='op'>(</span>total<span class='op'>=</span><span class='fu'><a href='https://rdrr.io/r/base/sum.html'>sum</a></span><span class='op'>(</span><span class='va'>`Number of Items`</span><span class='op'>)</span><span class='op'>)</span>

<span class='co'>#stores just the state names into a dataframe</span>
<span class='co'>#did this as opposed to using an api because it was readily available</span>
<span class='va'>stateList</span> <span class='op'>&lt;-</span> <span class='va'>stateListData</span><span class='op'>$</span><span class='va'>state_abbv</span>

<span class='co'>#creates two empty vectors for states and day of sale</span>
<span class='va'>statesOver</span><span class='op'>=</span><span class='fu'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='op'>(</span><span class='op'>)</span>
<span class='va'>sellDay</span><span class='op'>=</span><span class='fu'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='op'>(</span><span class='op'>)</span>
<span class='co'>#formats start and end dates for while loop below</span>
<span class='va'>start</span> <span class='op'>&lt;-</span> <span class='fu'><a href='https://rdrr.io/r/base/as.Date.html'>as.Date</a></span><span class='op'>(</span><span class='st'>"07-31-21"</span>,format<span class='op'>=</span><span class='st'>"%m-%d-%y"</span><span class='op'>)</span>
<span class='va'>end</span>   <span class='op'>&lt;-</span> <span class='fu'><a href='https://rdrr.io/r/base/as.Date.html'>as.Date</a></span><span class='op'>(</span><span class='st'>"10-08-21"</span>,format<span class='op'>=</span><span class='st'>"%m-%d-%y"</span><span class='op'>)</span>

<span class='co'>#stores start in variable called theDate and checks to make sure it ran properly</span>
<span class='va'>theDate</span> <span class='op'>&lt;-</span> <span class='va'>start</span>
<span class='va'>theDate</span>
</code></pre></div>

```
[1] "2021-07-31"
```

<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class='co'>#this for loop interates through each state and possible sell day, creating two populated vectors</span>
<span class='kw'>for</span><span class='op'>(</span><span class='va'>state</span> <span class='kw'>in</span> <span class='va'>stateList</span><span class='op'>)</span><span class='op'>{</span>
  <span class='kw'>while</span> <span class='op'>(</span><span class='va'>theDate</span> <span class='op'>&lt;=</span> <span class='va'>end</span><span class='op'>)</span>
  <span class='op'>{</span>
    <span class='va'>statesOver</span> <span class='op'>&lt;-</span> <span class='fu'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='op'>(</span><span class='va'>statesOver</span>, <span class='va'>state</span><span class='op'>)</span>
    <span class='va'>sellDay</span> <span class='op'>&lt;-</span> <span class='fu'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='op'>(</span><span class='va'>sellDay</span>, <span class='fu'><a href='https://lubridate.tidyverse.org/reference/as_date.html'>as_date</a></span><span class='op'>(</span><span class='va'>theDate</span><span class='op'>)</span><span class='op'>)</span>
    <span class='va'>theDate</span> <span class='op'>&lt;-</span> <span class='va'>theDate</span> <span class='op'>+</span> <span class='fl'>1</span>                    
  <span class='op'>}</span>
  <span class='va'>theDate</span> <span class='op'>&lt;-</span> <span class='va'>start</span>
<span class='op'>}</span>
<span class='co'>#changes sellDay into a date again</span>
<span class='va'>sellDay</span> <span class='op'>&lt;-</span> <span class='fu'><a href='https://rdrr.io/r/base/as.Date.html'>as.Date</a></span><span class='op'>(</span><span class='fu'><a href='https://rdrr.io/r/base/as.POSIXlt.html'>as.POSIXct</a></span><span class='op'>(</span><span class='va'>sellDay</span><span class='op'>*</span><span class='fl'>24</span><span class='op'>*</span><span class='fl'>60</span><span class='op'>*</span><span class='fl'>60</span>, origin <span class='op'>=</span> <span class='st'>"1970-01-01"</span>, tz<span class='op'>=</span><span class='st'>"UTC"</span><span class='op'>)</span><span class='op'>)</span>

<span class='co'>#joins the two populated vectors to start a dataset</span>
<span class='va'>emptyTable</span> <span class='op'>&lt;-</span> <span class='fu'><a href='https://rdrr.io/r/base/data.frame.html'>data.frame</a></span><span class='op'>(</span><span class='va'>sellDay</span>, <span class='va'>statesOver</span><span class='op'>)</span>

<span class='co'>#left_joins emptyTable and the population data from NoDup</span>
<span class='va'>fullTable</span> <span class='op'>&lt;-</span> <span class='fu'>left_join</span><span class='op'>(</span><span class='va'>emptyTable</span>, <span class='va'>NoDup</span>, by<span class='op'>=</span><span class='fu'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='op'>(</span><span class='st'>"sellDay"</span><span class='op'>=</span><span class='st'>"date"</span>, <span class='st'>"statesOver"</span><span class='op'>=</span><span class='st'>"state"</span><span class='op'>)</span><span class='op'>)</span>

<span class='co'>#makes a new items variable, replacing NA in Total_Sold with 0</span>
<span class='co'>#group_by statesOver and adds a cumulative sum by state</span>
<span class='va'>fullTable</span> <span class='op'>&lt;-</span> <span class='va'>fullTable</span> <span class='op'>%&gt;%</span> 
  <span class='fu'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='op'>(</span>items<span class='op'>=</span><span class='fu'><a href='https://rdrr.io/r/base/ifelse.html'>ifelse</a></span><span class='op'>(</span><span class='fu'><a href='https://rdrr.io/r/base/NA.html'>is.na</a></span><span class='op'>(</span><span class='va'>Total_Sold</span><span class='op'>)</span>, <span class='fl'>0</span>,<span class='va'>Total_Sold</span><span class='op'>)</span><span class='op'>)</span> <span class='op'>%&gt;%</span> 
  <span class='fu'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='op'>(</span><span class='va'>statesOver</span><span class='op'>)</span> <span class='op'>%&gt;%</span> 
  <span class='fu'><a href='https://r-spatial.github.io/sf/reference/tidyverse.html'>summarise</a></span><span class='op'>(</span><span class='va'>sellDay</span>, <span class='va'>statesOver</span>, <span class='va'>items</span>, cumulative <span class='op'>=</span> <span class='fu'><a href='https://rdrr.io/r/base/cumsum.html'>cumsum</a></span><span class='op'>(</span><span class='va'>items</span><span class='op'>)</span><span class='op'>)</span>

<span class='co'>#creates several ways to shade a choropleth map</span>
<span class='co'>#This was done because shading with the raw value makes states with less than 50 signs barely change color due to California (over 200 signs shipped there) </span>
<span class='co'>#makes a new day variable that will be iterable to plotly</span>
<span class='va'>plotTable</span> <span class='op'>&lt;-</span> <span class='va'>fullTable</span> <span class='op'>%&gt;%</span> 
  <span class='fu'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='op'>(</span>numSold <span class='op'>=</span> <span class='fu'><a href='https://rdrr.io/r/base/ifelse.html'>ifelse</a></span><span class='op'>(</span><span class='va'>cumulative</span><span class='op'>==</span><span class='fl'>0</span>, <span class='fl'>0</span>,
                    <span class='fu'><a href='https://rdrr.io/r/base/ifelse.html'>ifelse</a></span><span class='op'>(</span><span class='va'>cumulative</span><span class='op'>&lt;</span><span class='fl'>5</span>, <span class='fl'>1</span>,
                    <span class='fu'><a href='https://rdrr.io/r/base/ifelse.html'>ifelse</a></span><span class='op'>(</span><span class='va'>cumulative</span><span class='op'>&lt;</span><span class='fl'>10</span>, <span class='fl'>2</span>,
                    <span class='fu'><a href='https://rdrr.io/r/base/ifelse.html'>ifelse</a></span><span class='op'>(</span><span class='va'>cumulative</span><span class='op'>&lt;</span><span class='fl'>20</span>, <span class='fl'>3</span>,
                    <span class='fu'><a href='https://rdrr.io/r/base/ifelse.html'>ifelse</a></span><span class='op'>(</span><span class='va'>cumulative</span><span class='op'>&lt;</span><span class='fl'>50</span>, <span class='fl'>4</span>,
                    <span class='fu'><a href='https://rdrr.io/r/base/ifelse.html'>ifelse</a></span><span class='op'>(</span><span class='va'>cumulative</span><span class='op'>&lt;</span><span class='fl'>100</span>, <span class='fl'>5</span>,
                    <span class='fu'><a href='https://rdrr.io/r/base/ifelse.html'>ifelse</a></span><span class='op'>(</span><span class='va'>cumulative</span><span class='op'>&lt;</span><span class='fl'>200</span>, <span class='fl'>6</span>, <span class='fl'>7</span><span class='op'>)</span><span class='op'>)</span><span class='op'>)</span><span class='op'>)</span><span class='op'>)</span><span class='op'>)</span><span class='op'>)</span><span class='op'>)</span> <span class='op'>%&gt;%</span> 
  <span class='fu'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='op'>(</span>logSold<span class='op'>=</span><span class='fu'><a href='https://rdrr.io/r/base/ifelse.html'>ifelse</a></span><span class='op'>(</span><span class='va'>cumulative</span><span class='op'>&gt;</span><span class='fl'>0</span>, <span class='fu'><a href='https://rdrr.io/r/base/Log.html'>log</a></span><span class='op'>(</span><span class='va'>cumulative</span><span class='op'>+</span><span class='fl'>1</span><span class='op'>)</span>, <span class='fl'>0</span><span class='op'>)</span><span class='op'>)</span> <span class='op'>%&gt;%</span> 
  <span class='fu'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='op'>(</span>day <span class='op'>=</span> <span class='op'>(</span><span class='fu'><a href='https://lubridate.tidyverse.org/reference/month.html'>month</a></span><span class='op'>(</span><span class='va'>sellDay</span><span class='op'>)</span><span class='op'>*</span><span class='fl'>100</span><span class='op'>+</span><span class='fu'><a href='https://lubridate.tidyverse.org/reference/day.html'>day</a></span><span class='op'>(</span><span class='va'>sellDay</span><span class='op'>)</span><span class='op'>)</span> <span class='op'>)</span>

<span class='co'>#only needed once</span>
<span class='co'>#write_csv(plotTable, here::here("plotTable.csv"))</span>
</code></pre></div>

</div>


<div class="layout-chunk" data-layout="l-body">
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class='co'>#creates a choropleth using states as outlines, shading with logsold for best shading, a scale that is just above the highest logsold value to make cumulative shading look better, hovering gives the number of signs shipped to that state, frame is the day variable created above</span>
<span class='va'>USMAP</span> <span class='op'>&lt;-</span> <span class='va'>plotTable</span> <span class='op'>%&gt;%</span> 
  <span class='fu'><a href='https://rdrr.io/pkg/plotly/man/plot_ly.html'>plot_ly</a></span><span class='op'>(</span>
    type <span class='op'>=</span> <span class='st'>'choropleth'</span>,
    locations<span class='op'>=</span> <span class='op'>~</span><span class='va'>statesOver</span>,
    locationmode <span class='op'>=</span> <span class='st'>'USA-states'</span> , 
    colorscale<span class='op'>=</span><span class='st'>'tempo'</span>, z<span class='op'>=</span><span class='op'>~</span><span class='va'>logSold</span>,
    zmin<span class='op'>=</span><span class='fl'>0</span>, zmax<span class='op'>=</span><span class='fl'>6</span>,
    text<span class='op'>=</span><span class='op'>~</span><span class='va'>cumulative</span>,
    hoverinfo<span class='op'>=</span><span class='st'>'text'</span>,
    showscale<span class='op'>=</span><span class='cn'>FALSE</span>,
    frame<span class='op'>=</span><span class='op'>~</span><span class='fu'><a href='https://rdrr.io/r/base/as.Date.html'>as.Date</a></span><span class='op'>(</span><span class='va'>sellDay</span><span class='op'>)</span><span class='op'>)</span> <span class='op'>%&gt;%</span> 
  <span class='fu'><a href='https://rdrr.io/pkg/plotly/man/layout.html'>layout</a></span><span class='op'>(</span>geo<span class='op'>=</span><span class='fu'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='op'>(</span> scope <span class='op'>=</span> <span class='st'>'usa'</span> <span class='op'>)</span><span class='op'>)</span> 

<span class='co'>#saves the above </span>
<span class='kw'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='op'>(</span><span class='va'><a href='https://github.com/ramnathv/htmlwidgets'>htmlwidgets</a></span><span class='op'>)</span>
<span class='fu'><a href='https://rdrr.io/pkg/htmlwidgets/man/saveWidget.html'>saveWidget</a></span><span class='op'>(</span><span class='va'>USMAP</span>, <span class='st'>"USMAP.html"</span>, selfcontained <span class='op'>=</span> <span class='cn'>F</span>, libdir <span class='op'>=</span> <span class='st'>"lib"</span><span class='op'>)</span>
</code></pre></div>

</div>


#This map is a gif. If you would like to view an interactive version, go to the "Map" tab.
<div class="layout-chunk" data-layout="l-body">
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class='fu'>knitr</span><span class='fu'>::</span><span class='fu'><a href='https://rdrr.io/pkg/knitr/man/include_graphics.html'>include_graphics</a></span><span class='op'>(</span><span class='st'>"USCumul.gif"</span><span class='op'>)</span>
</code></pre></div>
![](USCumul.gif)<!-- -->

</div>


<div class="layout-chunk" data-layout="l-body">
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class='fu'>htmltools</span><span class='fu'>::</span><span class='va'><a href='https://rdrr.io/pkg/htmltools/man/builder.html'>tags</a></span><span class='op'>$</span><span class='fu'>iframe</span><span class='op'>(</span>
  width <span class='op'>=</span> <span class='st'>"1024"</span>,
  height <span class='op'>=</span> <span class='st'>"768"</span>,
  src <span class='op'>=</span> <span class='st'>"USMAP.html"</span>, 
  scrolling <span class='op'>=</span> <span class='st'>"no"</span>, 
  seamless <span class='op'>=</span> <span class='st'>"seamless"</span>,
  frameBorder <span class='op'>=</span> <span class='st'>"0"</span><span class='co'>#,</span>
  <span class='co'>#style="-webkit-transform:scale(0.5);-moz-transform-scale(0.5);"</span>
<span class='op'>)</span>
</code></pre></div>
`<iframe width="1024" height="768" src="USMAP.html" scrolling="no" seamless="seamless" frameBorder="0"></iframe>`{=html}

</div>






```{.r .distill-force-highlighting-css}
```
