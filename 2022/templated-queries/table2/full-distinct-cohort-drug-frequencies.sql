SELECT drug_concept_id, drug_concept_label, count(*) AS count
FROM (SELECT distinct de.person_id,
                      de.drug_concept_id AS drug_concept_id,
                      (SELECT concept_name FROM @vocabulary_database_schema.concept WHERE concept_id = de.drug_concept_id) AS drug_concept_label
      FROM @cdm_database_schema.drug_exposure AS de
      INNER JOIN @cdm_database_schema.cohort AS cohort ON de.person_id = cohort.subject_id
      WHERE cohort.cohort_definition_id = @include_cohort_id AND
            de.drug_exposure_start_date <= cohort.cohort_end_date AND 
            de.drug_exposure_end_date >= cohort.cohort_start_date AND
            -- and the drug concept is not also associated with persons in the excluded cohort
            de.drug_concept_id NOT IN (SELECT de2.drug_concept_id
                                       FROM @cdm_database_schema.drug_exposure AS de2
                                       INNER JOIN @cdm_database_schema.cohort AS cohort2 ON de2.person_id = cohort2.subject_id
                                       WHERE cohort2.cohort_definition_id = @exclude_cohort_id AND
                                             de2.drug_exposure_start_date <= cohort2.cohort_end_date AND 
                                             de2.drug_exposure_end_date >= cohort2.cohort_start_date))
GROUP BY drug_concept_id, drug_concept_label
ORDER BY count DESC
LIMIT 100