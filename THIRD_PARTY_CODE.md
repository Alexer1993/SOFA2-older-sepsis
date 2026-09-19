# Third-party SOFA-2 implementation

The MIMIC-IV SOFA-2 SQL implementation used locally during this study was supplied in a third-party source package. Its accompanying README states that the source belongs to the supplying platform and must not be redistributed or hosted in a public repository.

Accordingly, those SQL files are intentionally excluded from this GitHub release. They must not be copied from the local archive `sofa2_mimiciv.zip` into this repository unless the authors first obtain written permission covering public redistribution.

The repository includes:

- the study-specific MIMIC-IV cohort query;
- the expected interface to locally derived SOFA-2 fields;
- the MIMIC-IV/eICU cohort-cleaning and analysis code;
- an eICU extraction blueprint; and
- the final statistical and figure-generation scripts.

For independent reproduction, credentialed users must either obtain an authorized implementation or create an equivalent implementation from the published SOFA-2 specification. Any replacement implementation should be validated against the expected score range, component range, cohort counts, and the data contracts in `docs/variable_dictionary.md`.
