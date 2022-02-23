SELECT drug_concept_id, drug_concept_label, count(*) AS count
FROM (SELECT distinct de.person_id,
                      de.drug_concept_id AS drug_concept_id,
                      (SELECT concept_name FROM @vocabulary_database_schema.concept WHERE concept_id = de.drug_concept_id) AS drug_concept_label
      FROM @cdm_database_schema.drug_exposure AS de
      INNER JOIN @cdm_database_schema.cohort AS cohort ON de.person_id = cohort.subject_id
      WHERE cohort.cohort_definition_id = @cohort_id1 AND
            de.drug_exposure_start_date <= cohort.cohort_end_date AND 
            de.drug_exposure_end_date >= cohort.cohort_start_date AND
            de.person_id IN (SELECT cohort.subject_id
                             FROM @cdm_database_schema.cohort AS cohort
                             WHERE cohort.cohort_definition_id = @cohort_id2))
GROUP BY drug_concept_id, drug_concept_label
ORDER BY count DESC
LIMIT 100