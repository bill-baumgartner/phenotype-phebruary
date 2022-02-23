SELECT condition_concept_id, condition_concept_label, count(*) AS count
FROM (SELECT distinct co.person_id,
                      co.condition_concept_id AS condition_concept_id,
                      (SELECT concept_name FROM @vocabulary_database_schema.concept WHERE concept_id = co.condition_concept_id) AS condition_concept_label
      FROM @cdm_database_schema.condition_occurrence AS co
      INNER JOIN @cdm_database_schema.cohort AS cohort ON co.person_id = cohort.subject_id
      WHERE cohort.cohort_definition_id = @include_cohort_id AND
            co.condition_start_date <= cohort.cohort_end_date AND 
            co.condition_end_date >= cohort.cohort_start_date AND
            co.person_id NOT IN (SELECT cohort.subject_id
                                 FROM @cdm_database_schema.cohort AS cohort
                                 WHERE cohort.cohort_definition_id = @exclude_cohort_id) AND
            -- and the condition concept is not also associated with persons in the excluded cohort
            co.condition_concept_id NOT IN (SELECT co2.condition_concept_id
                                            FROM @cdm_database_schema.condition_occurrence AS co2
                                            INNER JOIN @cdm_database_schema.cohort AS cohort2 ON co2.person_id = cohort2.subject_id
                                            WHERE cohort2.cohort_definition_id = @exclude_cohort_id AND
                                                  co2.condition_start_date <= cohort2.cohort_end_date AND 
                                                  co2.condition_end_date >= cohort2.cohort_start_date))
GROUP BY condition_concept_id, condition_concept_label
ORDER BY count DESC
LIMIT 100