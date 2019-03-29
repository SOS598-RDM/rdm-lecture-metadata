generate metadata
================

We will use the csvy package to add metadata to our stream chemistry
data.

``` r
library(csvy)
library(tidyverse)
```

## Iris data demo

First, let us see how this works with the `iris` data.

``` r
# create our data set
iris_subset <- head(iris) # we can use a small piece of iris for this demo

# add attributes
attr(iris_subset, "title") <- "the famous Iris data set" # add a title
attr(iris_subset, "description") <- "measurements of Iris (Iris spp.) plants" # add a description
attr(iris_subset, "format") <- "csvy" # add a (meta)data format
```

How does our iris data set look (in R)?

  - with the str() function…

<!-- end list -->

``` r
str(iris_subset)
```

    ## 'data.frame':    6 obs. of  5 variables:
    ##  $ Sepal.Length: num  5.1 4.9 4.7 4.6 5 5.4
    ##  $ Sepal.Width : num  3.5 3 3.2 3.1 3.6 3.9
    ##  $ Petal.Length: num  1.4 1.4 1.3 1.5 1.4 1.7
    ##  $ Petal.Width : num  0.2 0.2 0.2 0.2 0.2 0.4
    ##  $ Species     : Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1
    ##  - attr(*, "title")= chr "the famous Iris data set"
    ##  - attr(*, "description")= chr "measurements of Iris (Iris spp.) plants"
    ##  - attr(*, "format")= chr "csvy"

  - with the attributes() function (note that we are exluding
    `row.names` from the
output)…

<!-- end list -->

``` r
attributes(iris_subset)[!names(attributes(iris_subset)) %in% c("row.names")]
```

    ## $names
    ## [1] "Sepal.Length" "Sepal.Width"  "Petal.Length" "Petal.Width" 
    ## [5] "Species"     
    ## 
    ## $class
    ## [1] "data.frame"
    ## 
    ## $title
    ## [1] "the famous Iris data set"
    ## 
    ## $description
    ## [1] "measurements of Iris (Iris spp.) plants"
    ## 
    ## $format
    ## [1] "csvy"

How does our iris data set look outside of R?

``` r
write_csvy(x = iris_subset,
           file = '~/Desktop/iris_subset.csv',
           comment_header = F)
```

## Add metadata to our stream chemistry data

Import our stream chemistry
data

``` r
stream_chem <- read_csv(file = '/home/srearl/localRepos/rdm-lecture-metadata/data/stream_chemistry_metabolism.csv') %>% 
  mutate(Date = as.Date(Date, format = "%m/%d/%Y")) # fix date field on import
```

    ## Parsed with column specification:
    ## cols(
    ##   site_id = col_character(),
    ##   K2_20 = col_double(),
    ##   Date = col_character(),
    ##   Time = col_time(format = ""),
    ##   Temp = col_double(),
    ##   SpCond = col_double(),
    ##   DO = col_double()
    ## )

Add metadata to our stream chemistry data. We can add table- and
field-level metadata. We can loosely follow the Frictionless Data Table
schema: <https://frictionlessdata.io/specs/table-schema/>

``` r
# add table attributes
attr(stream_chem, "title") <- "stream chemistry data from southern Appalachian mountain streams, 2013" # add a title
attr(stream_chem, "description") <- "stream chemistry data for the calculation of ecosystem metabolism collected with automated data loggers from four headwater streams in the southern Appalachian mountain region during summer 2013" # add a description
attr(stream_chem, "format") <- "csvy" # add a (meta)data format

# add column attributes
attr(stream_chem$site_id, "description") <- "site-code: Greenbriar (GB), Stone Crop (SC), Hugh White Creek (HWC)"
attr(stream_chem$K2_20, "description") <- "oxygen reaeration coefficient (per day)"
attr(stream_chem$Date, "description") <- "date of observation (YYYY-MM-DD)"
attr(stream_chem$Time, "description") <- "time of observation (hh:mm:ss)"
attr(stream_chem$Temp, "description") <- "stream water temperature (degrees Celsius)"
attr(stream_chem$SpCond, "description") <- "stream water specific conductance (microSiemens per centimeter)"
attr(stream_chem$DO, "description") <- "stream water dissolved oxygen concentration (milligrams per liter)"
```

Review our stream chemistry metadata

  - with the str()
    function…

<!-- end list -->

``` r
str(stream_chem)
```

    ## Classes 'spec_tbl_df', 'tbl_df', 'tbl' and 'data.frame': 7614 obs. of  7 variables:
    ##  $ site_id: chr  "GB" "GB" "GB" "GB" ...
    ##   ..- attr(*, "description")= chr "site-code: Greenbriar (GB), Stone Crop (SC), Hugh White Creek (HWC)"
    ##  $ K2_20  : num  57.4 57.4 57.4 57.4 57.4 ...
    ##   ..- attr(*, "description")= chr "oxygen reaeration coefficient (per day)"
    ##  $ Date   : Date, format: "2003-08-13" "2003-08-13" ...
    ##  $ Time   : 'hms' num  11:15:00 11:20:00 11:25:00 11:30:00 ...
    ##   ..- attr(*, "units")= chr "secs"
    ##   ..- attr(*, "description")= chr "time of observation (hh:mm:ss)"
    ##  $ Temp   : num  18.4 18.4 18.4 18.5 18.6 ...
    ##   ..- attr(*, "description")= chr "stream water temperature (degrees Celsius)"
    ##  $ SpCond : num  139 139 139 139 140 ...
    ##   ..- attr(*, "description")= chr "stream water specific conductance (microSiemens per centimeter)"
    ##  $ DO     : num  9.06 9.01 8.98 9.02 8.91 8.82 8.83 8.82 8.89 8.87 ...
    ##   ..- attr(*, "description")= chr "stream water dissolved oxygen concentration (milligrams per liter)"
    ##  - attr(*, "title")= chr "stream chemistry data from southern Appalachian mountain streams, 2013"
    ##  - attr(*, "description")= chr "stream chemistry data for the calculation of ecosystem metabolism collected with automated data loggers from fo"| __truncated__
    ##  - attr(*, "format")= chr "csvy"

  - with the attributes() function (note that we are exluding
    `row.names` from the
output)…

<!-- end list -->

``` r
attributes(stream_chem)[!names(attributes(stream_chem)) %in% c("row.names")]
```

    ## $names
    ## [1] "site_id" "K2_20"   "Date"    "Time"    "Temp"    "SpCond"  "DO"     
    ## 
    ## $title
    ## [1] "stream chemistry data from southern Appalachian mountain streams, 2013"
    ## 
    ## $description
    ## [1] "stream chemistry data for the calculation of ecosystem metabolism collected with automated data loggers from four headwater streams in the southern Appalachian mountain region during summer 2013"
    ## 
    ## $format
    ## [1] "csvy"
    ## 
    ## $class
    ## [1] "spec_tbl_df" "tbl_df"      "tbl"         "data.frame"

Write our stream chemistry data as a csvy file with metadata.

``` r
write_csvy(x = stream_chem, 
           file = "~/Desktop/stream_chem.csv",
           comment_header = F,
           row.names = F)
```