# Prespecified subgroup interaction analyses.
# Benjamini-Hochberg FDR adjustment is applied jointly across the nine prespecified interaction tests.
raw_p <- c(
  icu_type = 0.00015,
  dementia = 0.00069,
  malnutrition = 0.00184,
  charlson = 0.01067,
  age = 0.01396,
  infection_source = 0.07432,
  lactate = 0.32253,
  sepsis_timing = 0.51606,
  sex = 0.78987
)
bh_q <- p.adjust(raw_p, method = "BH")
subgroup_fdr <- data.frame(
  interaction = names(raw_p),
  raw_p = unname(raw_p),
  bh_fdr_q = unname(bh_q)
)
