# Baseline SOFA 2 and Early SOFA 2 Trajectories Stratify Mortality Risk in Older Patients With Sepsis

This public repository provides the reproducibility archive for the manuscript **“Baseline SOFA 2 and Early SOFA 2 Trajectories Stratify Mortality Risk in Older Patients With Sepsis.”**

## Code archive

The complete public code package is provided as:

**`SOFA2-older-sepsis-code-FINAL.zip`**

The ZIP archive contains the study-specific R, SQL, configuration, documentation, and non-identifiable aggregate output files used to document the final analysis workflow, including:

- cohort construction and data-processing scripts;
- primary mortality and secondary-outcome analyses;
- SOFA-2 versus conventional SOFA prediction analyses;
- 2,000-resample patient-level paired bootstrap comparisons;
- Benjamini–Hochberg FDR adjustment for the nine prespecified subgroup interactions;
- SOFA-2 trajectory analyses and trajectory-stability checks;
- eICU external-validation scripts;
- figure-generation code;
- database-specific analysis specifications and reproducibility documentation.

The repository root also contains the final code-consistency audit and modification log.

## Final cohort logic

The public archive reflects the final revision logic:

- **MIMIC-IV:** 23,174 admissions after age/first-ICU/ICU-length-of-stay eligibility; 10,531 did not meet Sepsis-3 criteria within 0–48 h; final cohort **n=12,643**.
- **eICU-CRD:** 34,481 admissions after age/first-ICU/ICU-length-of-stay eligibility; 21,844 were not in the final adult sepsis-source cohort; 12,637 remained, of whom 1,200 had missing or out-of-window sepsis timing; final cohort **n=11,437**.
- **No cohort-exclusion criterion was based on baseline SOFA-2 availability, a SOFA-2 value of 0, or a study-specific baseline SOFA-2 filter.**

## Data access

MIMIC-IV v3.1 and eICU-CRD v2.0 are deidentified critical-care databases distributed through PhysioNet under credentialed access and their respective data-use requirements. Individual-level patient data are **not** redistributed in this repository.

Researchers wishing to reproduce the analyses must obtain authorized access to the source databases and create the required local analysis inputs in their own approved environment.

## SOFA-2 scoring dependency

The MIMIC-IV SOFA-2 implementation used locally during the study included third-party source code that cannot be redistributed publicly under its accompanying terms. That code is therefore not included in this repository. The archive documents the expected interfaces and the author-owned downstream reproducibility workflow.

For eICU, retained analysis materials do not permit every upstream component-level default-scoring rule to be reconstructed with certainty. The public documentation therefore does not infer an unverified general missing-component=0 or general LOCF rule.

## Reproducibility status

The archive has undergone a final code/document consistency audit against the revised manuscript and response-to-reviewers logic. Because credentialed patient-level MIMIC-IV/eICU data are not included here, independent numerical reproduction requires rerunning the archive in an authorized local environment.

See:

- `FINAL_CODE_AUDIT_2026-09-27.md`
- `MODIFICATION_LOG_2026-09-27.md`
- `FILE_MANIFEST_SHA256.txt`

## Citation

Citation metadata are provided in `CITATION.cff`.

Repository: https://github.com/Alexer1993/SOFA2-older-sepsis

## Code availability wording

Recommended manuscript wording:

> The cohort-construction, data-processing, statistical-analysis, external-validation, and figure-generation code supporting this study is publicly available as a code archive at GitHub: https://github.com/Alexer1993/SOFA2-older-sepsis. Individual-level MIMIC-IV and eICU-CRD data are not redistributed because access is governed by PhysioNet credentialing and data-use requirements.

## License

No open-source license has been applied to the author-owned code at this time. The code is made publicly available for transparency and reproducibility. Third-party code is not included and may not be redistributed without permission.
