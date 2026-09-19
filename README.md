# Baseline and Dynamic SOFA-2 Profiles in Older Patients With Sepsis

This repository contains cohort-extraction, data-processing, statistical-analysis, and figure-generation code for the study **Baseline and Dynamic SOFA-2 Profiles in Older Patients With Sepsis**.

The development cohort comprised 12,643 ICU admissions from 11,138 patients in MIMIC-IV v3.1. The external validation cohort comprised 11,437 ICU admissions in eICU-CRD v2.0. Individual-level clinical data are not distributed in this repository.

## Repository contents

```text
SOFA2-older-sepsis/
├── R/
│   ├── data_prep/          # Database connections, cohort construction, cleaning
│   ├── analysis/           # Primary, prediction, subgroup, sensitivity, trajectory analyses
│   ├── figures/            # Publication figure assembly
│   └── reviewer_analyses/  # Patient-cluster MaxStat bootstrap
├── sql/
│   ├── mimic/              # Cohort flow-count query
│   └── eicu/               # eICU extraction blueprint and flow-count query
├── config/                 # Analysis specifications and environment template
├── data/                   # Documentation only; no patient-level data
├── outputs/                # Non-identifiable aggregate results included with the release
└── docs/                   # Reproduction notes, variable dictionary, and release checklist
```

## Data access

MIMIC-IV and eICU-CRD are credentialed, deidentified databases distributed through PhysioNet. Researchers must obtain access independently and comply with the corresponding data-use agreements. Do not commit raw, intermediate, or analysis-ready patient-level files to this repository.

Expected local input locations are documented in [`data/README.md`](data/README.md). The `.gitignore` file excludes those locations by default.

## Important SOFA-2 scoring dependency

The MIMIC-IV SOFA-2 SQL implementation used during the study was supplied as third-party code whose accompanying terms prohibit public redistribution. It is therefore not included here. The public code begins from the authorized locally derived SOFA-2 tables and documents the expected fields and cohort-processing interface.

See [`THIRD_PARTY_CODE.md`](THIRD_PARTY_CODE.md) before public release. If the authors obtain written redistribution permission, the authorized SQL may be added in a later version. Otherwise, users must create an equivalent local SOFA-2 implementation from the published specification.

## Software environment

- R 4.4.2 was used for the final study analyses.
- PostgreSQL was used for database extraction.
- The analysis seed was 2026 unless a script states a prespecified sensitivity-analysis seed.

Install the R dependencies with:

```r
source("R/install_dependencies.R")
```

Copy `config/.Renviron.example` to a private `.Renviron` file outside version control and provide the local database settings. Never commit database passwords.

```text
SOFA2_PROJECT_ROOT=/absolute/path/to/SOFA2-older-sepsis
MIMIC_DB_HOST=localhost
MIMIC_DB_PORT=5432
MIMIC_DB_NAME=mimiciv
MIMIC_DB_USER=mimic_readonly
MIMIC_DB_PASSWORD=change-me
EICU_DB_HOST=localhost
EICU_DB_PORT=5432
EICU_DB_NAME=eicu
EICU_DB_USER=eicu_readonly
EICU_DB_PASSWORD=change-me
```

Run scripts from the repository root, or set `SOFA2_PROJECT_ROOT` explicitly.

## Reproduction workflow

1. Obtain authorized access to MIMIC-IV v3.1 and eICU-CRD v2.0.
2. Create the required SOFA-2 derived inputs locally. See `THIRD_PARTY_CODE.md` and the expected fields in `docs/variable_dictionary.md`.
3. Run the MIMIC data-preparation scripts in numerical order under `R/data_prep/01_*` through `09_*`.
4. Run the eICU data-preparation scripts in numerical order under `R/data_prep/11_*` through `16_*` after preparing the required local source files.
5. Place the two final analysis-ready RDS files in `data/analysis_ready_current/` as described in `data/README.md`.
6. Run the scripts under `R/analysis/` in numerical order for the analysis modules needed.
7. Run `R/figures/` after the corresponding analysis outputs have been generated.

The complete script-to-result map and database-specific outcome definitions are provided in [`docs/reproducibility.md`](docs/reproducibility.md).

## Key implementation decisions

- The analysis unit was the ICU admission. Patient-level resampling retained all admissions from each sampled MIMIC-IV patient.
- The baseline SOFA-2 score used the first 24 hours after ICU admission.
- The operational baseline SOFA-2 filter excluded missing totals, totals equal to 0, and totals outside 0-24. A score of 0 was a study-specific exclusion, not an intrinsically invalid value.
- The MIMIC-IV primary endpoint was all-cause death within 28 days after ICU admission (`icu_28d_death`). The eICU endpoint was in-hospital death within the same fixed horizon (`mortality_28`) because post-discharge dates were unavailable.
- The final patient-cluster bootstrap selected cutoffs 8, 9, and 10 in 40.4%, 17.0%, and 42.6% of 500 resamples, respectively. The optimism-corrected C-index was 0.5702, and the optimism-corrected **unadjusted** hazard ratio was 1.8492.

## Included aggregate results

The `outputs/` directory contains only non-identifiable summary results from the patient-cluster bootstrap. Bootstrap resample-level rows and all patient-level data are excluded from the public release.

## Citation

Citation metadata are provided in [`CITATION.cff`](CITATION.cff). The public repository is available at https://github.com/Alexer1993/SOFA2-older-sepsis. The manuscript code-availability wording is provided in [`docs/code_availability_statement.md`](docs/code_availability_statement.md).

## License

No open-source license has been applied to the author-owned code at this time. The code is made publicly available for transparency and reproducibility. Third-party code is not included and may not be redistributed without permission.
