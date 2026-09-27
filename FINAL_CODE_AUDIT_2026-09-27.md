# Final public-code consistency audit — 2026-09-27

Target manuscript: **Baseline SOFA 2 and Early SOFA 2 Trajectories Stratify Mortality Risk in Older Patients With Sepsis**

## Scope

This audit was performed against the final revision logic used in the response-to-reviewers package, with special attention to places where the public code had previously contradicted claims made in the response. It is a **code/document consistency audit**. Patient-level numerical re-execution was not possible in this environment because the credentialed MIMIC-IV/eICU data and the R runtime are not available here.

## High-priority inconsistencies corrected

1. **Removed SOFA-2-based cohort exclusion** from MIMIC-IV and eICU preparation/flow logic. Missing SOFA-2 totals, SOFA-2=0, and score range are audited but are not cohort-membership criteria.
2. **Corrected final cohort-flow anchors** to:
   - MIMIC-IV: 23,174 after age/first-ICU/LOS eligibility → 10,531 not meeting Sepsis-3 within 0–48 h → 12,643 final admissions.
   - eICU-CRD: 34,481 after age/first-ICU/LOS eligibility → 21,844 not in the final adult sepsis-source cohort → 12,637 → 1,200 missing/out-of-window sepsis timing → 11,437 final admissions.
3. Removed obsolete public-flow references to **12,651, 12,834, 11,634, 8 MIMIC SOFA-2 exclusions, and 197 eICU SOFA-2 exclusions**.
4. Added a **2,000-resample patient-level paired percentile bootstrap** implementation for SOFA-2-minus-SOFA time-dependent AUC differences in both MIMIC-IV and eICU, plus the paired MIMIC-IV C-index comparisons. Markers are fixed within bootstrap resampling; models are not refitted; this is not a DeLong test or optimism correction.
5. Added **Benjamini–Hochberg FDR** calculation across the nine prespecified subgroup interaction tests.
6. Added **trajectory stability analysis** using 200 random-seed K-means runs and 200 admission-level bootstrap resamples with agreement, ARI, and NMI.
7. Updated the principal MIMIC trajectory Cox workflow to use the **full primary covariate set**, with lactate median imputation plus a lactate-missingness indicator for the full-cohort trajectory model.
8. Removed interpretive **Day-1 AUC** reporting from the revised prediction workflow; reported time-dependent AUC comparisons begin at Day 3 because the ≥48-h ICU-stay eligibility criterion creates a design-imposed event-free window.
9. Removed the former **“slightly higher/better”** prediction wording and linked the prediction scripts to paired uncertainty output.
10. Removed the circular **Day1–3 final-class prediction-accuracy** display; only Day 1 and Day 1–2 anticipation remain in the publication-figure assembly logic.
11. Removed the fixed **Day-3 septic-shock row** from the MIMIC/eICU trajectory publication tables while retaining underlying variables only where needed for source-data audit.
12. Removed unsupported eICU public assumptions that an unavailable baseline component was automatically scored 0 or that a general LOCF rule applied. The public specification now states that upstream component-default logic is not fully reconstructable from the retained eICU materials.
13. Harmonized the project/manuscript title, “older patients” terminology, cohort definitions, endpoint wording, and repository documentation.
14. Updated eICU ordinary-covariate missForest settings to **seed 2026, 20 trees, maximum five iterations**.

## Static verification completed

- YAML/CFF parsing succeeded for `analysis_spec_mimic.yml`, `analysis_spec_eicu.yml`, and `CITATION.cff`.
- A lexical balance check found no unmatched R brackets/braces/quotes across the public R scripts.
- Searches found no remaining operational SOFA-2 cohort filter and no remaining legacy 12,651/12,834/11,634 flow denominators in executable/public specification files.
- Searches found no embedded real database password, API token, or patient-level data file in the release package.
- The GitHub Actions workflow parses every R file under `R/` with R 4.4.2 when the repository contents are expanded and pushed.

## Verification still required in the authorized analysis environment

Before treating this archive as a numerically certified reproduction package, run the scripts with the authorized MIMIC-IV/eICU inputs and confirm:

1. final cohort counts = 12,643 MIMIC-IV and 11,437 eICU;
2. trajectory cohort = 12,284, with 359 unavailable Day-3 SOFA-2 values and seven also unavailable Day 2;
3. paired-bootstrap output reproduces Supplementary Table 11 within rounding;
4. BH-adjusted q values reproduce Supplementary Table 12;
5. 200-seed/200-bootstrap trajectory stability metrics reproduce the reported Supplementary Table 7/8 values;
6. full-primary-covariate trajectory HRs reproduce the reported 1.35, 1.91, and 3.50 point estimates (within manuscript rounding);
7. no removed late-event row is regenerated into the publication tables.

The code package now reflects the final revision logic rather than the earlier revision-stage cohort/filter logic; numerical equality still depends on rerunning against the authorized study data and locally derived SOFA-2 inputs.
