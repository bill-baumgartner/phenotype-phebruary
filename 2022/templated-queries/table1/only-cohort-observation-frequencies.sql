SELECT observation_concept_id, observation_concept_label, count(*) AS count
FROM (SELECT distinct obs.person_id,
                      obs.observation_concept_id AS observation_concept_id,
                      (SELECT concept_name FROM @vocabulary_database_schema.concept WHERE concept_id = obs.observation_concept_id) AS observation_concept_label
      FROM @cdm_database_schema.observation AS obs
      INNER JOIN @cdm_database_schema.cohort AS cohort ON obs.person_id = cohort.subject_id
      WHERE cohort.cohort_definition_id = @include_cohort_id AND
            obs.observation_date >= cohort.cohort_start_date AND 
            obs.observation_date <= cohort.cohort_end_date AND
            obs.person_id NOT IN (SELECT cohort.subject_id
                                  FROM @cdm_database_schema.cohort AS cohort
                                  WHERE cohort.cohort_definition_id = @exclude_cohort_id))
GROUP BY observation_concept_id, observation_concept_label
ORDER BY count DESC
LIMIT 100