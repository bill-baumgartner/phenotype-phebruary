# Templated queries for computing concept frequencies of Atlas and Aphrodite cohorts that are distinct from the other cohort (Table 2 of blog post)

This folder contains templated queries for computing the most frequent unique concepts for a given cohort for the following domains: `condition`, `drug`, `measurement`, `observation`, & `procedure`. For each domain there are two versions of the query to return frequencies based on a single cohort (`full`) and persons in only one cohort but not another (`only`).

For all analyses, by definition, a concept is included if its time window overlaps at any point with a cohort time window, and a concept is only counted once per patient even if the concept is associated multiple times for a given patient within a cohort time window.

The SqlRender library can be used to render sql from the templates as shown below using the `condition` domain as an example:

## Frequencies of condition concepts for all persons in a single cohort where the concepts do not also appear in the other cohort (full) 
```r
library(SqlRender)
library(readr)
sql_template <- read_file("full-distinct-cohort-condition-frequencies.sql")
sql <- render(sql_template, cdm_database_schema=[CDM_DATABASE_SCHEMA],
                            vocabulary_database_schema=[VOCABULARY_DATABASE_SCHEMA],
                            include_cohort_id=[INCLUDE_COHORT_ID],
                            exclude_cohort_id=[EXCLUDE_COHORT_ID])
```
where,
* [CDM_DATABASE_SCHEMA] = the schema name for your OMOP instance, i.e. location of the CONDITION_OCCURRENCE table
* [VOCABULARY_DATABASE_SCHEMA] = the schema name for your OMOP vocabulary instance, i.e. location of the CONCEPT table
* [INCLUDE_COHORT_ID] = concepts from patients in the cohort referenced by the `include_cohort_id` will be included in the analysis
* [EXCLUDE_COHORT_ID] = concepts from patients in the cohort referenced by the `exclude_cohort_id` will be excluded from the analysis

## Frequencies of condition concepts for persons who are members of only one cohort but not another where the concepts do not also appear in the other cohort (only)
```r
library(SqlRender)
library(readr)
sql_template <- read_file("only-distinct-cohort-condition-frequencies.sql")
sql <- render(sql_template, cdm_database_schema=[CDM_DATABASE_SCHEMA],
                            vocabulary_database_schema=[VOCABULARY_DATABASE_SCHEMA],
                            include_cohort_id=[INCLUDE_COHORT_ID],
                            exclude_cohort_id=[EXCLUDE_COHORT_ID])
```
where,
* [CDM_DATABASE_SCHEMA] = the schema name for your OMOP instance, i.e. location of the CONDITION_OCCURRENCE table
* [VOCABULARY_DATABASE_SCHEMA] = the schema name for your OMOP vocabulary instance, i.e. location of the CONCEPT table
* [INCLUDE_COHORT_ID] = patients in the cohort referenced by the `include_cohort_id` will be included in the analysis
* [EXCLUDE_COHORT_ID] = patients in the cohort referenced by the `exclude_cohort_id` will be excluded from the analysis
