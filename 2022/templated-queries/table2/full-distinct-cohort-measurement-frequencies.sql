SELECT measurement_concept_id, measurement_concept_label, count(*) AS count
FROM (SELECT distinct meas.person_id,
                      meas.measurement_concept_id AS measurement_concept_id,
                      (SELECT concept_name FROM @vocabulary_database_schema.concept WHERE concept_id = meas.measurement_concept_id) AS measurement_concept_label
      FROM @cdm_database_schema.measurement AS meas
      INNER JOIN @cdm_database_schema.cohort AS cohort ON meas.person_id = cohort.subject_id
      WHERE cohort.cohort_definition_id = @include_cohort_id AND
            meas.measurement_date >= cohort.cohort_start_date AND 
            meas.measurement_date <= cohort.cohort_end_date AND
            -- and the measurement concept is not also associated with persons in the excluded cohort
            meas.measurement_concept_id NOT IN (SELECT meas2.measurement_concept_id
                                                FROM @cdm_database_schema.measurement AS meas2
                                                INNER JOIN @cdm_database_schema.cohort AS cohort2 ON meas2.person_id = cohort2.subject_id
                                                WHERE cohort2.cohort_definition_id = @exclude_cohort_id AND
                                                      meas2.measurement_date >= cohort2.cohort_start_date AND 
                                                      meas2.measurement_date <= cohort2.cohort_end_date))
GROUP BY measurement_concept_id, measurement_concept_label
ORDER BY count DESC
LIMIT 100