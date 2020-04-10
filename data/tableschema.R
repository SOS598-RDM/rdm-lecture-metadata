# README

# frictionless workflow scratchspace

devtools::install_github("frictionlessdata/datapackage-r")

# libraries

library(tableschema.r)
library(datapackage.r)
library(future)
library(jsonlite)

# tableschema example

def <- Table.load('~/Desktop/data.csv')
table <- value(def)

toJSON(table$read(keyed = TRUE), pretty = TRUE) # function from jsonlite package

# table.headers <- table$headers 
# table.headers

toJSON(table$infer(), pretty = TRUE) # function from jsonlite package

toJSON(table$schema$descriptor, pretty = TRUE) # function from jsonlite package

table$read(keyed = TRUE) # Fails

# table$schema$descriptor['missingValues'] = 'N/A'
# table$schema$commit()

table$schema$valid # false

table$schema$errors

table$schema$descriptor[['missingValues']] = list("", 'N/A')
table$schema$commit()

table$read()
# table$read(keyed = TRUE)
toJSON(table$read(), pretty = TRUE) # function from jsonlite package

table$schema$save('~/Desktop/fromTable')
table$save(connection = '~/Desktop/fromTable/')

def = Schema.load({'~/Desktop/fromTable/Schema.json'})
schema = value(def)
schema$valid # false
schema$errors

# scratch

myschema$fields
toJSON(myschema, pretty = T)

myschema$missingValues = list("", 'N/A')
myschema$missingValues = list("NULL")

myschema[['fields']][[1]]$format <- "date"

myschema$fields[[grepl(myschema$fields)]]

# schema infer

inferSchema <- tableschema.r::infer('~/Desktop/data.csv')
toJSON(inferSchema, pretty = T, auto_unbox = T)
write(toJSON(inferSchema, pretty = TRUE, auto_unbox = T), '~/Desktop/inferSchema.json')

def = Schema.load({'~/Desktop/inferSchema.json'})
schema = value(def)
schema$valid # false
schema$errors
toJSON(schema$descriptor, pretty = TRUE) # function from jsonlite package

# data package

dataPackage <- Package.load('~/Desktop/datapackage.json')
jsonlite::toJSON(dataPackage$infer('csv'), pretty = TRUE)
dataPackage$valid

toJSON(dataPackage$descriptor, pretty = T)
toJSON(dataPackage$descriptor, pretty = T)

resource <- Resource.load('{"~/Desktop/datapkg/": "cities.csv"')
resource <- Resource.load("cities.csv")
jsonlite::toJSON(resource$read(keyed = TRUE), pretty = TRUE)
jsonlite::toJSON(resource$infer(), pretty = TRUE)
jsonlite::toJSON(resource$descriptor, pretty = TRUE)

resource$descriptor$schema[['missingValues']] <- list('', 'N/A')
resource$commit()
resource$valid
jsonlite::toJSON(resource$read( keyed = TRUE ), pretty = TRUE)
jsonlite::toJSON(resource$descriptor, pretty = TRUE)
resource$save('.csv')


jsonlite::toJSON(dataPackage$descriptor, pretty = TRUE)

dataPackage$descriptor

dataPackage$getResource('~/Desktop/datapkg/cities.csv')
dataPackage$descriptor$title <- "test title"
