# Templated queries for computing cohort concept frequencies

This folder contains templated queries for computing the most frequent concepts for a given cohort for the following domains: `condition`, `drug`, `measurement`, `observation`, & `procedure`. The templated query files are named `cohort-[domain]-frequencies.sql`. The SqlRender library can be used to render sql from the templates as shown below:

```r
library(SqlRender)
library(readr)
sql_template <- read_file("cohort-condition-frequencies.sql")
sql <- render(sql_template, cdm_database_schema=[CDM_DATABASE_SCHEMA],
                            vocabulary_database_schema=[VOCABULARY_DATABASE_SCHEMA],
                            cohort_id=[COHORT_ID])
```
where,
* [CDM_DATABASE_SCHEMA] = the schema name for your OMOP instance, i.e. location of the CONDITION_OCCURRENCE table
* [VOCABULARY_DATABASE_SCHEMA] = the schema name for your OMOP vocabulary instance, i.e. location of the CONCEPT table
* [COHORT_ID] = the integer id of the cohort to be analyzed

By definition, a concept is included if its time window overlaps at any point with a cohort time window. Also, a concept is only counted once per patient even it the concept is associated multiple times for a given patient within a cohort time window.

