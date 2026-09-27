# Modification log — final reviewer-consistency pass

This file records the principal changes made to the public code archive after the final manuscript/reviewer-response audit.

| Area | Main files | Final logic enforced |
|---|---|---|
| Cohort membership | `R/data_prep/04_*`, `15_*`, `sql/mimic/cohort_flow_counts.sql`, `sql/eicu/cohort_flow_counts.sql` | No baseline SOFA-2 availability/value filter; MIMIC final n=12,643; eICU final n=11,437 |
| Flow figure | `R/figures/assemble_manuscript_figures.R` | MIMIC 23,174→−10,531→12,643; eICU 34,481→−21,844→12,637→−1,200→11,437 |
| Prediction/AUC | `R/analysis/30_*`, `83_*`, `R/figures/figure3_*` | Day-1 AUC not interpreted; comparisons begin Day 3; no blanket SOFA-2 superiority wording |
| Paired uncertainty | `R/reviewer_analyses/paired_prediction_bootstrap.R` | 2,000 patient-level paired percentile bootstrap resamples, fixed markers, both databases; MIMIC C-index comparison included |
| Multiplicity | `R/analysis/50_subgroup_analysis.R` | BH FDR across nine prespecified interactions; q values exported |
| Trajectory stability | `R/reviewer_analyses/trajectory_stability.R` | 200 random-seed runs + 200 admission bootstrap resamples; agreement/ARI/NMI |
| MIMIC trajectory Cox | `R/analysis/70_*`, `72_*`, `84_*` | Principal model uses full primary covariates; lactate median-imputed with missingness indicator; eICU model kept separate |
| Circular trajectory prediction | `R/figures/assemble_manuscript_figures.R` | Day1–3 self-classification accuracy removed; Day1 and Day1–2 anticipation only |
| Late outcomes | `R/analysis/70_*`, `82_*` | Fixed Day-3 septic-shock publication row removed; eICU late ventilation remains omitted |
| eICU component missingness | `config/analysis_spec_eicu.yml`, `docs/reproducibility.md`, `sql/eicu/extraction_blueprint.sql` | No invented general missing=0 or LOCF rule; unresolved upstream logic explicitly documented |
| Missing-data implementation | `R/data_prep/16_clean_eicu_prediction_dataset.R` | missForest seed 2026, 20 trees, max 5 iterations |
| Public documentation | `README.md`, `CITATION.cff`, `docs/*`, `config/*` | Final title, final cohort logic, endpoint differences, revision-specific methods |

## Important interpretation

These edits synchronize the public workflow with the final revision logic. They do not retroactively regenerate patient-level numerical results in this environment. Re-run the code against the authorized analysis-ready data before treating the archive as numerically certified.
