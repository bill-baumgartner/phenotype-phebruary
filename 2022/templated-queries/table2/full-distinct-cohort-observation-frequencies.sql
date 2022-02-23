SELECT observation_concept_id, observation_concept_label, count(*) AS count
FROM (SELECT distinct obs.person_id,
                      obs.observation_concept_id AS observation_concept_id,
                      (SELECT concept_name FROM @vocabulary_database_schema.concept WHERE concept_id = obs.observation_concept_id) AS observation_concept_label
      FROM @cdm_database_schema.observation AS obs
      INNER JOIN @cdm_database_schema.cohort AS cohort ON obs.person_id = cohort.subject_id
      WHERE cohort.cohort_definition_id = @include_cohort_id AND
            obs.observation_date >= cohort.cohort_start_date AND 
            obs.observation_date <= cohort.cohort_end_date AND
            -- and the observation concept is not also associated with persons in the excluded cohort
            obs.observation_concept_id NOT IN (SELECT obs2.observation_concept_id
                                               FROM @cdm_database_schema.observation AS obs2
                                               INNER JOIN @cdm_database_schema.cohort AS cohort2 ON obs2.person_id = cohort2.subject_id
                                               WHERE cohort2.cohort_definition_id = @exclude_cohort_id AND
                                                     obs2.observation_date >= cohort2.cohort_start_date AND 
                                                     obs2.observation_date <= cohort2.cohort_end_date))
GROUP BY observation_concept_id, observation_concept_label
ORDER BY count DESC
LIMIT 100