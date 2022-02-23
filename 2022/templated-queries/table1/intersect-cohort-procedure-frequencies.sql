SELECT procedure_concept_id, procedure_concept_label, count(*) AS count
FROM (SELECT distinct po.person_id,
                      po.procedure_concept_id AS procedure_concept_id,
                      (SELECT concept_name FROM @vocabulary_database_schema.concept WHERE concept_id = po.procedure_concept_id) AS procedure_concept_label
      FROM @cdm_database_schema.procedure_occurrence AS po
      INNER JOIN @cdm_database_schema.cohort AS cohort ON po.person_id = cohort.subject_id
      WHERE cohort.cohort_definition_id = @cohort_id1 AND
            po.procedure_date >= cohort.cohort_start_date AND 
            po.procedure_date <= cohort.cohort_end_date AND
            po.person_id IN (SELECT cohort.subject_id
                             FROM @cdm_database_schema.cohort AS cohort
                             WHERE cohort.cohort_definition_id = @cohort_id2))
GROUP BY procedure_concept_id, procedure_concept_label
ORDER BY count DESC
LIMIT 100