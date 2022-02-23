SELECT measurement_concept_id, measurement_concept_label, count(*) AS count
FROM (SELECT distinct meas.person_id,
                      meas.measurement_concept_id AS measurement_concept_id,
                      (SELECT concept_name FROM @vocabulary_database_schema.concept WHERE concept_id = meas.measurement_concept_id) AS measurement_concept_label
      FROM @cdm_database_schema.measurement AS meas
      INNER JOIN @cdm_database_schema.cohort AS cohort ON meas.person_id = cohort.subject_id
      WHERE cohort.cohort_definition_id = @cohort_id AND
            meas.measurement_date >= cohort.cohort_start_date AND 
            meas.measurement_date <= cohort.cohort_end_date)
GROUP BY measurement_concept_id, measurement_concept_label
ORDER BY count DESC
LIMIT 100