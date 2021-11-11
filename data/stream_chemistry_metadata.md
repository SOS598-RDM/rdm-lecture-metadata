---
title: "generating metadata for tabular data resources"
output:
  github_document:
---

## I. overview

One of the challenges with many data repositories is the limited capacity to provide detailed metadata about data resources. A good example of this are repositories that employ the [Dublin Core](https://dublincore.org/) metadata schema. The Dublin Core schema is rich and versatile, hence why it is very widely adopted by repositories, but provides mostly for metadata about a study or dataset generally with limited capacity to describe data resources, such as tables, images, or spatial data.

We will look at three ways to generate metadata for tabular data resources to include as part of our dataset in repositories that do not otherwise provide that functionality:

- [embedded yaml](https://github.com/SOS598-RDM/rdm-lecture-metadata/blob/master/data/stream_chemistry_metadata.md#i-add-metadata-to-tabular-data-as-yaml-with-csvy)
- [frictionless](https://github.com/SOS598-RDM/rdm-lecture-metadata/blob/master/data/stream_chemistry_metadata.md#ii-frictionless)
- [README](https://github.com/SOS598-RDM/rdm-lecture-metadata/blob/master/data/stream_chemistry_metadata.md#iii-include-metadata-in-a-well-constructed-readme)

Finally, we consider providing metadata regarding non-tabular and spatial data

- [non-tabular](https://github.com/SOS598-RDM/rdm-lecture-metadata/blob/master/data/stream_chemistry_metadata.md#iv-non-tabular-data)
- [spatial data](https://github.com/SOS598-RDM/rdm-lecture-metadata/blob/master/data/stream_chemistry_metadata.md#v-non-tabular-data-spatial-data)

## II. add metadata to tabular data as yaml with csvy

We can use the [csvy](https://github.com/leeper/csvy) R package to add metadata to a tabular resource. The output is a modified version of our tabular resource with metadata about the resource included as yaml embedded within the resource itself.

#### a simple demonstration with the iris data set

First, let us see how this works with the `iris` data.


```r
# create our data set as a subset of the iris dataset that comes with R 
iris_subset <- head(iris) # we can 
```

We can add table-level metadata in the form of attributes to the iris_subset. As much as possible, we will employ the Frictionless [Data Table Schema](https://frictionlessdata.io/specs/table-schema/).


```r
attr(iris_subset, "title")       <- "the famous Iris data set" # add a title
attr(iris_subset, "description") <- "measurements of Iris (Iris spp.) plants" # add a description
attr(iris_subset, "format")      <- "csvy" # add a data- meta-data format
```

We can also add field- or column-level metadata, including a title and description using attributes. Table Schema does not support metadata for units but we can include such important metadata in the description.


```r
attr(iris_subset$Petal.Length, "label")       <- "the length of an individual petal" # label will ultimately map to title
attr(iris_subset$Petal.Length, "description") <- "the length of an individual petal in units of millimeter" # add a description
```

How does our iris data set look (in R)?

* with the str() function...


```r
str(iris_subset)
```

```
## 'data.frame':	6 obs. of  5 variables:
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
```

*  with the attributes() function (note that we are excluding `row.names` from the output)...


```r
attributes(iris_subset)[!names(attributes(iris_subset)) %in% c("row.names")]
```

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
```

How does our iris data set look outside of R? Here, I am writing our csvy object to a temporary (`/tmp`) directory, change the path as appropriate for your working environment.


```r
csvy::write_csvy(
  x = iris_subset,
  file = "/tmp/iris_subset.csv",
  comment_header = F
)
```

#### a richer example: add metadata to our stream chemistry data

Use the csvy package to add metadata to our stream chemistry data.

Import our stream chemistry data


```r
# stream_chem <- readr::read_csv(file = "stream_chemistry_metabolism.csv")
stream_chem <- read.csv(file = "stream_chemistry_metabolism.csv")
```

We can use the same approach we used with the subset of iris data for our stream chemistry data.

Add table-level metadata to our stream chemistry data.


```r
attr(stream_chem, "title")       <- "stream chemistry data from southern Appalachian mountain streams, 2013" # add a title
attr(stream_chem, "description") <- "stream chemistry data for the calculation of ecosystem metabolism collected with automated data loggers from four headwater streams in the southern Appalachian mountain region during summer 2013" # add a description
attr(stream_chem, "format")      <- "csvy" # add a (meta)data format
```

Add table-level metadata to our stream chemistry data.


```r
attr(stream_chem$site_id, "label")       <- "study site identifier"
attr(stream_chem$site_id, "description") <- "site-code: Greenbriar (GB), Stone Crop (SC), Hugh White Creek (HWC)"

attr(stream_chem$K2_20, "label")         <- "a metric of oxygen exchange across the air-water interface"
attr(stream_chem$K2_20, "description")   <- "oxygen reaeration coefficient (per day)"

attr(stream_chem$Date, "label")          <- "date of observation"
attr(stream_chem$Date, "description")    <- "date of observation (YYYY-MM-DD)"

attr(stream_chem$Time, "label")          <- "time of observation"
attr(stream_chem$Time, "description")    <- "time of observation (hh:mm:ss)"

attr(stream_chem$Temp, "label")          <- "stream water temperature"
attr(stream_chem$Temp, "description")    <- "stream water temperature (degrees Celsius)"

attr(stream_chem$SpCond, "label")        <- "stream water specific conductance"
attr(stream_chem$SpCond, "description")  <- "stream water specific conductance (microSiemens per centimeter)"

attr(stream_chem$DO, "label")            <- "stream water dissolved oxygen concentration"
attr(stream_chem$DO, "description")      <- "stream water dissolved oxygen concentration (milligrams per liter)"
```

Review our stream chemistry metadata

* with the str() function...


```r
str(stream_chem)
```

```
## 'data.frame':	6151 obs. of  7 variables:
##  $ site_id: chr  "GB" "GB" "GB" "GB" ...
##   ..- attr(*, "label")= chr "study site identifier"
##   ..- attr(*, "description")= chr "site-code: Greenbriar (GB), Stone Crop (SC), Hugh White Creek (HWC)"
##  $ K2_20  : num  57.4 57.4 57.4 57.4 57.4 ...
##   ..- attr(*, "label")= chr "a metric of oxygen exchange across the air-water interface"
##   ..- attr(*, "description")= chr "oxygen reaeration coefficient (per day)"
##  $ Date   : chr  "2003-08-13" "2003-08-13" "2003-08-13" "2003-08-13" ...
##   ..- attr(*, "label")= chr "date of observation"
##   ..- attr(*, "description")= chr "date of observation (YYYY-MM-DD)"
##  $ Time   : chr  "11:15:00" "11:20:00" "11:25:00" "11:30:00" ...
##   ..- attr(*, "label")= chr "time of observation"
##   ..- attr(*, "description")= chr "time of observation (hh:mm:ss)"
##  $ Temp   : num  18.4 18.4 18.4 18.5 18.6 ...
##   ..- attr(*, "label")= chr "stream water temperature"
##   ..- attr(*, "description")= chr "stream water temperature (degrees Celsius)"
##  $ SpCond : num  139 139 139 139 140 ...
##   ..- attr(*, "label")= chr "stream water specific conductance"
##   ..- attr(*, "description")= chr "stream water specific conductance (microSiemens per centimeter)"
##  $ DO     : num  9.06 9.01 8.98 9.02 8.91 8.82 8.83 8.82 8.89 8.87 ...
##   ..- attr(*, "label")= chr "stream water dissolved oxygen concentration"
##   ..- attr(*, "description")= chr "stream water dissolved oxygen concentration (milligrams per liter)"
##  - attr(*, "title")= chr "stream chemistry data from southern Appalachian mountain streams, 2013"
##  - attr(*, "description")= chr "stream chemistry data for the calculation of ecosystem metabolism collected with automated data loggers from fo"| __truncated__
##  - attr(*, "format")= chr "csvy"
```

*  with the attributes() function (note that we are excluding `row.names` from the output)...


```r
attributes(stream_chem)[!names(attributes(stream_chem)) %in% c("row.names")]
```

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
## [1] "data.frame"
```

Write our stream chemistry data as a csvy file with metadata. Here, I am writing our csvy object to a temporary (/tmp) directory, change the path as appropriate for your working environment.


```r
csvy::write_csvy(
  x = stream_chem, 
  file = "/tmp/stream_chem.csv",
  comment_header = F,
  row.names = F
)
```

## II. frictionless

### a. use the frictionless web-based data package creator

We can use the frictionless data package [creator](https://create.frictionlessdata.io/) to construct an entire data package. Metadata are contained in the `stream-chem-data-package.json` file in the `data` directory of this repository; this can be uploaded along with the data file `stream_chemistry_metabolism.csv` or bundled as a stand-alone data package.

### b. use frictionless tools to generate metadata or create a data package

Load an existing schema into our R environment and display output. Note that the full path to the file is required for Package.load hence use of the call to `here`.


```r
streamChemPackage <- datapackage.r::Package.load(here::here("data", "stream-chem-data-package.json"))
jsonlite::toJSON(streamChemPackage$descriptor, pretty = T)
```

```
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
```

## III. include metadata in a well-constructed README

Another less technical, though not necessarily less effective, approach is to simply document the details of a data resource in a document. A good example of such documentation is a study by [Wall et al. 2017](https://datadryad.org/stash/dataset/doi:10.5061/dryad.5vg70) that is in the Dryad repository. Note that Wall et al. provide details of the data tables by describing the content of those tables in corresponding .docx files. docx is *definitely* not the best medium for such documentation, plain text is most appropriate, but the documentation is thorough and understandable.

## IV. non-tabular data

Except for csvy, we can use similar approaches to documenting non-tabular data. For example, we could use the [frictionless data package creator](https://create.frictionlessdata.io/) to generate metadata for the image of the catchment above the Dos S Ranch along Sycamore Creek in central Arizona.

<img src="syc_ss_mapview.png" alt="sycamore_creek_catchment">

The corresponding metadata generated from frictionless is displayed below.


```r
sycamore_creek_catchment <- datapackage.r::Package.load(here::here("data", "sycamore-creek-catchment.json"))
jsonlite::toJSON(sycamore_creek_catchment$descriptor, pretty = T)
```

```
## {
##   "profile": ["data-package"],
##   "resources": [
##     {
##       "name": ["sycamorecreekwatershed"],
##       "path": ["syc_ss_mapview.png"],
##       "profile": ["data-resource"],
##       "schema": {},
##       "title": ["Sycamore_Creek_watershed"],
##       "format": ["png"],
##       "encoding": ["utf-8"]
##     }
##   ],
##   "keywords": [
##     ["desert"],
##     ["sonoran"],
##     ["stream"],
##     ["arizona"]
##   ],
##   "name": ["sycamorecreekwatershed"],
##   "title": ["Sycamore Creek, AZ watershed above Dos S Ranch"],
##   "description": ["Watershed of Sycamore Creek, AZ above the Dos S Ranch"],
##   "licenses": [
##     {
##       "name": ["CC0-1.0"],
##       "title": ["CC0 1.0"],
##       "path": ["https://creativecommons.org/publicdomain/zero/1.0/"]
##     }
##   ]
## }
```

## V. non-tabular data: spatial data

Common packages for working with spatial data, such as QGIS and ArcGIS, have their own tools for generating metadata. These metadata can be embedded in the spatial resource, such that the data file includes both the spatial data and corresponding metadata. This can be good and bad. On one hand, it is convenient and efficient to have both data and metadata in one file resource but, on the other, this means that it is possible that the software used to generate the resource (e.g., ArcGIS) is the only way to access one or both components.

If this is a concern, and it is something that the data provider should consider, the spatial data can be provided in an open format, such as kml or geojson, with the metadata generated separately. For example, below are the first few lines of the file `headwater_catchments_new_mexico.qmd` that includes metadata corresponding to the `new_mexico_ws.geojson` spatial data file in our `data` directory. `headwater_catchments_new_mexico.qmd` was generated in QGIS, hence the `qmd` extension, but this is a plain-text format that is readily accessible.


```r
readLines("headwater_catchments_new_mexico.qmd")
```

```
##  [1] "<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
##  [2] "<qgis version=\"3.22.0-Białowieża\">"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
##  [3] "  <identifier>/home/srearl/Desktop/gis/archive/new_mexico_ws.geojson</identifier>"                                                                                                                                                                                                                                                                                                                                                                                                                                                
##  [4] "  <parentidentifier></parentidentifier>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
##  [5] "  <language></language>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
##  [6] "  <type>dataset</type>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
##  [7] "  <title>New Mexico, USA catchments delineated using the USGS StreamStats tool based on the position of sampling points along headwater streams</title>"                                                                                                                                                                                                                                                                                                                                                                          
##  [8] "  <abstract>Spatial layer detailing the position and extend of catchments corresponding to sampling locations in several headwater streams of norther New Mexico, USA. Catchments were delineated using a modified version of the USGS StreamStats package.</abstract>"                                                                                                                                                                                                                                                           
##  [9] "  <keywords vocabulary=\"gmd:topicCategory\">"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
## [10] "    <keyword>Environment</keyword>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
## [11] "    <keyword>Inland Waters</keyword>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
## [12] "  </keywords>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
## [13] "  <keywords vocabulary=\"place\">"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
## [14] "    <keyword>new mexico</keyword>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
## [15] "  </keywords>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
## [16] "  <keywords vocabulary=\"theme\">"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
## [17] "    <keyword>headwater stream</keyword>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
## [18] "  </keywords>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
## [19] "  <contact>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
## [20] "    <name>Mike Trico</name>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
## [21] "    <organization>Sunday Night Football</organization>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
## [22] "    <position>analyst and commentator</position>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
## [23] "    <voice>555.555.5555</voice>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
## [24] "    <fax>555.555.5555</fax>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
## [25] "    <email>miket@nbc.com</email>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
## [26] "    <role>owner</role>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
## [27] "  </contact>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
## [28] "  <links/>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
## [29] "  <fees></fees>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
## [30] "  <license>Creative Commons CC Zero</license>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
## [31] "  <encoding></encoding>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
## [32] "  <crs>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
## [33] "    <spatialrefsys>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
## [34] "      <wkt>GEOGCRS[\"NAD83\",DATUM[\"North American Datum 1983\",ELLIPSOID[\"GRS 1980\",6378137,298.257222101,LENGTHUNIT[\"metre\",1]]],PRIMEM[\"Greenwich\",0,ANGLEUNIT[\"degree\",0.0174532925199433]],CS[ellipsoidal,2],AXIS[\"geodetic latitude (Lat)\",north,ORDER[1],ANGLEUNIT[\"degree\",0.0174532925199433]],AXIS[\"geodetic longitude (Lon)\",east,ORDER[2],ANGLEUNIT[\"degree\",0.0174532925199433]],USAGE[SCOPE[\"unknown\"],AREA[\"North America - NAD83\"],BBOX[14.92,167.65,86.46,-47.74]],ID[\"EPSG\",4269]]</wkt>"
## [35] "      <proj4>+proj=longlat +datum=NAD83 +no_defs</proj4>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
## [36] "      <srsid>3401</srsid>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
## [37] "      <srid>4269</srid>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
## [38] "      <authid>EPSG:4269</authid>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
## [39] "      <description>NAD83</description>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
## [40] "      <projectionacronym>longlat</projectionacronym>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
## [41] "      <ellipsoidacronym>EPSG:7019</ellipsoidacronym>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
## [42] "      <geographicflag>true</geographicflag>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
## [43] "    </spatialrefsys>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
## [44] "  </crs>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
## [45] "  <extent>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
## [46] "    <spatial crs=\"EPSG:4269\" minz=\"0\" miny=\"35.83109999999999928\" dimensions=\"2\" maxz=\"0\" maxx=\"-106.39010000000000389\" maxy=\"36.01979999999999649\" minx=\"-106.62069999999999936\"/>"                                                                                                                                                                                                                                                                                                                              
## [47] "    <temporal>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
## [48] "      <period>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
## [49] "        <start>2021-11-01T07:00:00Z</start>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
## [50] "        <end>2021-11-02T07:00:00Z</end>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
## [51] "      </period>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
## [52] "    </temporal>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
## [53] "  </extent>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
## [54] "</qgis>"
```
