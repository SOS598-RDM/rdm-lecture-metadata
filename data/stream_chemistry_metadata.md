generate metadata
================

## I. add metadata to tabular data as yaml with csvy

#### a simple demonstration with the iris data set

First, let us see how this works with the `iris` data.

``` r
# create our data set
iris_subset <- head(iris) # we can use a small piece of iris for this demo
```

We can add table-level metadata in the form of attributes to the
iris\_subset. As much as possible, we will employ the Frictionless [Data
Table Schema](https://frictionlessdata.io/specs/table-schema/).

``` r
attr(iris_subset, "title") <- "the famous Iris data set" # add a title
attr(iris_subset, "description") <- "measurements of Iris (Iris spp.) plants" # add a description
attr(iris_subset, "format") <- "csvy" # add a (meta)data format
```

We can also add field-level metadata, including a title and description
using attributes. Table Schema does not support units metadata for
fields but we can include this important metadata in the
description.

``` r
attr(iris_subset$Petal.Length, "label") <- "the length of an individual petal" # label will ultimately map to title
attr(iris_subset$Petal.Length, "description") <- "the length of an individual petal in units of millimeter" # add a description
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
    ##   ..- attr(*, "label")= chr "the length of an individual petal"
    ##   ..- attr(*, "description")= chr "the length of an individual petal in units of millimeter"
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
    ## [1] "Sepal.Length" "Sepal.Width"  "Petal.Length" "Petal.Width"  "Species"     
    ## 
    ## $title
    ## [1] "the famous Iris data set"
    ## 
    ## $description
    ## [1] "measurements of Iris (Iris spp.) plants"
    ## 
    ## $format
    ## [1] "csvy"
    ## 
    ## $class
    ## [1] "data.frame"

How does our iris data set look outside of R?

``` r
write_csvy(x = iris_subset,
           file = '~/Desktop/iris_subset.csv',
           comment_header = F)
```

#### a richer example: add metadata to our stream chemistry data

Use the csvy package to add metadata to our stream chemistry data.

Import our stream chemistry data

``` r
stream_chem <- read_csv(file = 'stream_chemistry_metabolism.csv')
```

    ## Parsed with column specification:
    ## cols(
    ##   site_id = col_character(),
    ##   K2_20 = col_double(),
    ##   Date = col_date(format = ""),
    ##   Time = col_time(format = ""),
    ##   Temp = col_double(),
    ##   SpCond = col_double(),
    ##   DO = col_double()
    ## )

We can use the same approach we used with the subset of iris data for
our stream chemsitry data.

Add table-level metadata to our stream chemistry
data.

``` r
attr(stream_chem, "title") <- "stream chemistry data from southern Appalachian mountain streams, 2013" # add a title
attr(stream_chem, "description") <- "stream chemistry data for the calculation of ecosystem metabolism collected with automated data loggers from four headwater streams in the southern Appalachian mountain region during summer 2013" # add a description
attr(stream_chem, "format") <- "csvy" # add a (meta)data format
```

Add table-level metadata to our stream chemistry data.

``` r
attr(stream_chem$site_id, "label") <- "study site identifier"
attr(stream_chem$site_id, "description") <- "site-code: Greenbriar (GB), Stone Crop (SC), Hugh White Creek (HWC)"

attr(stream_chem$K2_20, "label") <- "a metric of oxygen exchange across the air-water interface"
attr(stream_chem$K2_20, "description") <- "oxygen reaeration coefficient (per day)"

attr(stream_chem$Date, "label") <- "date of observation"
attr(stream_chem$Date, "description") <- "date of observation (YYYY-MM-DD)"

attr(stream_chem$Time, "label") <- "time of observation"
attr(stream_chem$Time, "description") <- "time of observation (hh:mm:ss)"

attr(stream_chem$Temp, "label") <- "stream water temperature"
attr(stream_chem$Temp, "description") <- "stream water temperature (degrees Celsius)"

attr(stream_chem$SpCond, "label") <- "stream water specific conductance"
attr(stream_chem$SpCond, "description") <- "stream water specific conductance (microSiemens per centimeter)"

attr(stream_chem$DO, "label") <- "stream water dissolved oxygen concentration"
attr(stream_chem$DO, "description") <- "stream water dissolved oxygen concentration (milligrams per liter)"
```

Review our stream chemistry metadata

  - with the str() function…

<!-- end list -->

``` r
str(stream_chem)
```

    ## tibble [6,151 × 7] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
    ##  $ site_id: chr [1:6151] "GB" "GB" "GB" "GB" ...
    ##   ..- attr(*, "label")= chr "study site identifier"
    ##   ..- attr(*, "description")= chr "site-code: Greenbriar (GB), Stone Crop (SC), Hugh White Creek (HWC)"
    ##  $ K2_20  : num [1:6151] 57.4 57.4 57.4 57.4 57.4 ...
    ##   ..- attr(*, "label")= chr "a metric of oxygen exchange across the air-water interface"
    ##   ..- attr(*, "description")= chr "oxygen reaeration coefficient (per day)"
    ##  $ Date   : Date[1:6151], format: "2003-08-13" "2003-08-13" ...
    ##  $ Time   : 'hms' num [1:6151] 11:15:00 11:20:00 11:25:00 11:30:00 ...
    ##   ..- attr(*, "units")= chr "secs"
    ##   ..- attr(*, "label")= chr "time of observation"
    ##   ..- attr(*, "description")= chr "time of observation (hh:mm:ss)"
    ##  $ Temp   : num [1:6151] 18.4 18.4 18.4 18.5 18.6 ...
    ##   ..- attr(*, "label")= chr "stream water temperature"
    ##   ..- attr(*, "description")= chr "stream water temperature (degrees Celsius)"
    ##  $ SpCond : num [1:6151] 139 139 139 139 140 ...
    ##   ..- attr(*, "label")= chr "stream water specific conductance"
    ##   ..- attr(*, "description")= chr "stream water specific conductance (microSiemens per centimeter)"
    ##  $ DO     : num [1:6151] 9.06 9.01 8.98 9.02 8.91 8.82 8.83 8.82 8.89 8.87 ...
    ##   ..- attr(*, "label")= chr "stream water dissolved oxygen concentration"
    ##   ..- attr(*, "description")= chr "stream water dissolved oxygen concentration (milligrams per liter)"
    ##  - attr(*, "spec")=
    ##   .. cols(
    ##   ..   site_id = col_character(),
    ##   ..   K2_20 = col_double(),
    ##   ..   Date = col_date(format = ""),
    ##   ..   Time = col_time(format = ""),
    ##   ..   Temp = col_double(),
    ##   ..   SpCond = col_double(),
    ##   ..   DO = col_double()
    ##   .. )
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
    ## $spec
    ## cols(
    ##   site_id = col_character(),
    ##   K2_20 = col_double(),
    ##   Date = col_date(format = ""),
    ##   Time = col_time(format = ""),
    ##   Temp = col_double(),
    ##   SpCond = col_double(),
    ##   DO = col_double()
    ## )
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

## II. frictionless

### IIa. use the frictionless web-based data package creator

We can use the frictionless data package
[creator](https://create.frictionlessdata.io/) to construct an entire
data package. Metadata are contained in the
`stream-chem-data-package.json` file in the `data` directory of this
repository; this can be uploaded along with the data file
`stream_chemistry_metabolism.csv` or bundled as a stand-along data
package.

### IIb. use frictionless tools to generate metadata or create a data package

Load an existing schema into our R environment and display output

    ## {
    ##   "profile": ["tabular-data-package"],
    ##   "resources": [
    ##     {
    ##       "name": ["stream-chemistry-southern-appalachian-mountain-streams-2013"],
    ##       "path": ["stream_chemistry_metabolism.csv"],
    ##       "profile": ["tabular-data-resource"],
    ##       "schema": {
    ##         "fields": [
    ##           {
    ##             "name": ["site_id"],
    ##             "type": ["string"],
    ##             "format": ["default"],
    ##             "title": ["study site identifier"],
    ##             "description": ["site-code: Greenbriar (GB), Stone Crop (SC)"]
    ##           },
    ##           {
    ##             "name": ["K2_20"],
    ##             "type": ["number"],
    ##             "format": ["default"],
    ##             "title": ["a metric of oxygen exchange across the air-water interface"],
    ##             "description": ["a metric of oxygen exchange across the air-water interface"]
    ##           },
    ##           {
    ##             "name": ["Date"],
    ##             "type": ["date"],
    ##             "format": ["default"],
    ##             "title": ["date of observation"],
    ##             "description": ["date of observation (YYYY-MM-DD)"]
    ##           },
    ##           {
    ##             "name": ["Time"],
    ##             "type": ["time"],
    ##             "format": ["default"],
    ##             "title": ["time of observation"],
    ##             "description": ["time of observation (hh:mm:ss)"]
    ##           },
    ##           {
    ##             "name": ["Temp"],
    ##             "type": ["number"],
    ##             "format": ["default"],
    ##             "title": ["stream water temperature"],
    ##             "description": ["stream water temperature (degrees Celsius)"]
    ##           },
    ##           {
    ##             "name": ["SpCond"],
    ##             "type": ["number"],
    ##             "format": ["default"],
    ##             "title": ["stream water specific conductance"],
    ##             "description": ["stream water specific conductance (microSiemens per centimeter)"]
    ##           },
    ##           {
    ##             "name": ["DO"],
    ##             "type": ["integer"],
    ##             "format": ["default"],
    ##             "title": ["stream water dissolved oxygen concentration"],
    ##             "description": ["stream water dissolved oxygen concentration (milligrams per liter)"]
    ##           }
    ##         ],
    ##         "missingValues": [
    ##           [""]
    ##         ]
    ##       },
    ##       "title": ["stream chemistry data from southern Appalachian mountain streams, 2013"],
    ##       "description": ["stream chemistry data for the calculation of ecosystem metabolism collected with automated data loggers from two headwater streams in the southern Appalachian mountain region during summer 2013"],
    ##       "format": ["csv"],
    ##       "encoding": ["utf-8"]
    ##     }
    ##   ],
    ##   "title": ["High-frequency water-quality measurements for metabolic analyses from stream in the Newport, Virginia area, 2003"],
    ##   "name": ["appalachian-mountain-stream-study"],
    ##   "description": ["Stream chemistry data for the calculation of ecosystem metabolism collected with automated data loggers from two headwater streams in the southern Appalachian mountain region during summer 2013."],
    ##   "contributors": [
    ##     {
    ##       "title": ["John T. Chance"],
    ##       "role": ["author"]
    ##     }
    ##   ],
    ##   "licenses": [
    ##     {
    ##       "name": ["CC0-1.0"],
    ##       "title": ["CC0 1.0"],
    ##       "path": ["https://creativecommons.org/publicdomain/zero/1.0/"]
    ##     }
    ##   ]
    ## }

## III. include metadata in a well-constructed README

[Wall et
al. 2017](https://datadryad.org/stash/dataset/doi:10.5061/dryad.5vg70)
