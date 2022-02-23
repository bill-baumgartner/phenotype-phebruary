SELECT condition_concept_id, condition_concept_label, count(*) AS count
FROM (SELECT distinct co.person_id,
                      co.condition_concept_id AS condition_concept_id,
                      (SELECT concept_name FROM @vocabulary_database_schema.concept WHERE concept_id = co.condition_concept_id) AS condition_concept_label
      FROM @cdm_database_schema.condition_occurrence AS co
      INNER JOIN @cdm_database_schema.cohort AS cohort ON co.person_id = cohort.subject_id
      WHERE cohort.cohort_definition_id = @cohort_id AND
            co.condition_start_date <= cohort.cohort_end_date AND 
            co.condition_end_date >= cohort.cohort_start_date)
GROUP BY condition_concept_id, condition_concept_label
ORDER BY count DESC
LIMIT 100