# Templated queries for computing cohort concept frequencies

This folder contains templated queries for computing the most frequent concepts for a given cohort for the following domains: `condition`, `drug`, `measurement`, `observation`, & `procedure`. For each domain there are three versions of the query to return frequencies based on a single cohort (`full`), persons in only one cohort but not another (`only`), and persons in the intersection of two cohorts (`intersect`).

For all analyses, by definition, a concept is included if its time window overlaps at any point with a cohort time window, and a concept is only counted once per patient even if the concept is associated multiple times for a given patient within a cohort time window.

The SqlRender library can be used to render sql from the templates as shown below using the `condition` domain as an example:

## Frequencies of condition concepts for all persons in a single cohort (full)
```r
library(SqlRender)
library(readr)
sql_template <- read_file("full-cohort-condition-frequencies.sql")
sql <- render(sql_template, cdm_database_schema=[CDM_DATABASE_SCHEMA],
                            vocabulary_database_schema=[VOCABULARY_DATABASE_SCHEMA],
                            cohort_id=[COHORT_ID])
```
where,
* [CDM_DATABASE_SCHEMA] = the schema name for your OMOP instance, i.e. location of the CONDITION_OCCURRENCE table
* [VOCABULARY_DATABASE_SCHEMA] = the schema name for your OMOP vocabulary instance, i.e. location of the CONCEPT table
* [COHORT_ID] = the integer id of the cohort to be analyzed

## Frequencies of condition concepts for persons who are members of only one cohort but not another (only)
```r
library(SqlRender)
library(readr)
sql_template <- read_file("only-cohort-condition-frequencies.sql")
sql <- render(sql_template, cdm_database_schema=[CDM_DATABASE_SCHEMA],
                            vocabulary_database_schema=[VOCABULARY_DATABASE_SCHEMA],
                            including_cohort_id=[INCLUDING_COHORT_ID],
                            excluding_cohort_id=[EXCLUDING_COHORT_ID])
```
where,
* [CDM_DATABASE_SCHEMA] = the schema name for your OMOP instance, i.e. location of the CONDITION_OCCURRENCE table
* [VOCABULARY_DATABASE_SCHEMA] = the schema name for your OMOP vocabulary instance, i.e. location of the CONCEPT table
* [INCLUDING_COHORT_ID] = patients in the cohort referenced by the `including_cohort_id` will be included in the analysis
* [EXCLUDING_COHORT_ID] = patients in the cohort referenced by the `excluding_cohort_id` will be excluded from the analysis

## Frequencies of condition concepts for persons who are members of two cohorts (intersect)
```r
library(SqlRender)
library(readr)
sql_template <- read_file("intersect-cohort-condition-frequencies.sql")
sql <- render(sql_template, cdm_database_schema=[CDM_DATABASE_SCHEMA],
                            vocabulary_database_schema=[VOCABULARY_DATABASE_SCHEMA],
                            cohort_id1=[COHORT_ID1],
                            cohort_id2=[COHORT_ID2])
```
where,
* [CDM_DATABASE_SCHEMA] = the schema name for your OMOP instance, i.e. location of the CONDITION_OCCURRENCE table
* [VOCABULARY_DATABASE_SCHEMA] = the schema name for your OMOP vocabulary instance, i.e. location of the CONCEPT table
* [COHORT_ID1] = the integer id for one of the cohorts of which the person is a member
* [COHORT_ID2] = the integer id for another of the cohorts of which the person is a member


