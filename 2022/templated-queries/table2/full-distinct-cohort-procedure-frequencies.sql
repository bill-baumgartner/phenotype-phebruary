SELECT procedure_concept_id, procedure_concept_label, count(*) AS count
FROM (SELECT distinct po.person_id,
                      po.procedure_concept_id AS procedure_concept_id,
                      (SELECT concept_name FROM @vocabulary_database_schema.concept WHERE concept_id = po.procedure_concept_id) AS procedure_concept_label
      FROM @cdm_database_schema.procedure_occurrence AS po
      INNER JOIN @cdm_database_schema.cohort AS cohort ON po.person_id = cohort.subject_id
      WHERE cohort.cohort_definition_id = @include_cohort_id AND
            po.procedure_date >= cohort.cohort_start_date AND 
            po.procedure_date <= cohort.cohort_end_date AND
            -- and the procedure concept is not also associated with persons in the excluded cohort
            po.procedure_concept_id NOT IN (SELECT po2.procedure_concept_id
                                            FROM @cdm_database_schema.procedure_occurrence AS po2
                                            INNER JOIN @cdm_database_schema.cohort AS cohort2 ON po2.person_id = cohort2.subject_id
                                            WHERE cohort2.cohort_definition_id = @exclude_cohort_id AND
                                                  po2.procedure_date >= cohort2.cohort_start_date AND 
                                                  po2.procedure_date <= cohort2.cohort_end_date))
GROUP BY procedure_concept_id, procedure_concept_label
ORDER BY count DESC
LIMIT 100