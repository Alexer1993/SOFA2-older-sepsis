set.seed(2026)
invisible(try(Sys.setlocale("LC_CTYPE", "Chinese_China.936"), silent = TRUE))
invisible(try(Sys.setlocale("LC_COLLATE", "Chinese_China.936"), silent = TRUE))

project_root_env <- Sys.getenv("SOFA2_PROJECT_ROOT", unset = "")
if (nzchar(project_root_env)) {
  project_root <- gsub("\\", "/", project_root_env)
} else {
  args_file <- sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE)[1])
  if (is.na(args_file) || !nzchar(args_file)) {
    project_root <- normalizePath(file.path(getwd(), ".."), winslash = "/", mustWork = TRUE)
  } else {
    project_root <- normalizePath(file.path(dirname(normalizePath(args_file, winslash = "/", mustWork = TRUE)), ".."), winslash = "/", mustWork = TRUE)
  }
}

out_dir <- file.path(project_root, "outputs", "mimic_baseline_table_updated")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

required <- c("dplyr", "openxlsx", "officer", "flextable")
missing_pkgs <- required[!vapply(required, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing_pkgs) > 0) stop("Missing packages: ", paste(missing_pkgs, collapse = ", "))

data_path <- file.path(project_root, "data", "analysis_ready_current", "MIMIC_SOFA2_analysis_master_current.rds")
manifest_path <- file.path(project_root, "data", "analysis_ready_current", "analysis_ready_current_manifest.csv")

fmt_n <- function(x) formatC(as.integer(x), big.mark = ",", format = "d")
fmt_p <- function(p) {
  if (is.na(p)) return("")
  if (p < 0.001) return("<0.001")
  sprintf("%.3f", p)
}
fmt_num <- function(x, digits = 1) {
  if (is.na(x)) return("")
  formatC(x, format = "f", digits = digits, big.mark = ",")
}
fmt_missing <- function(x, n_total) {
  n <- sum(is.na(x))
  sprintf("%s (%.1f)", fmt_n(n), 100 * n / n_total)
}
fmt_cont <- function(x, digits = 1) {
  x <- suppressWarnings(as.numeric(x))
  x <- x[!is.na(x)]
  if (length(x) == 0) return("")
  qs <- stats::quantile(x, c(0.25, 0.5, 0.75), na.rm = TRUE, names = FALSE)
  sprintf("%s [%s-%s]", fmt_num(qs[2], digits), fmt_num(qs[1], digits), fmt_num(qs[3], digits))
}
fmt_cat <- function(x, level, denom) {
  n <- sum(x == level, na.rm = TRUE)
  if (denom == 0) return("")
  sprintf("%s (%.1f)", fmt_n(n), 100 * n / denom)
}
clean_chr <- function(x) {
  z <- as.character(x)
  z[trimws(z) %in% c("", "NA", "NaN", "NULL", "NaT")] <- NA_character_
  z
}
to_num <- function(x) suppressWarnings(as.numeric(x))
to_bin <- function(x) {
  if (is.null(x)) return(NULL)
  if (is.logical(x)) return(as.integer(x))
  if (is.numeric(x) || is.integer(x)) return(as.integer(x > 0))
  z <- tolower(trimws(as.character(x)))
  ifelse(z %in% c("1", "yes", "y", "true", "t", "male", "m"), 1L,
         ifelse(z %in% c("0", "no", "n", "false", "f", "female"), 0L, NA_integer_))
}
parse_time <- function(x) {
  if (inherits(x, "POSIXct")) return(x)
  x <- clean_chr(x)
  as.POSIXct(x, tz = "UTC", tryFormats = c(
    "%Y-%m-%d %H:%M:%S", "%Y-%m-%d %H:%M",
    "%Y-%m-%dT%H:%M:%SZ", "%Y/%m/%d %H:%M:%S",
    "%Y/%m/%d %H:%M", "%Y-%m-%d", "%Y/%m/%d"
  ))
}
has_col <- function(d, nm) nm %in% names(d)
get_col <- function(d, nm) if (has_col(d, nm)) d[[nm]] else rep(NA, nrow(d))

# Public release note:
# This long table-generation script is included verbatim from the final audited archive.
# It uses the final analysis-ready cohort and does not apply a SOFA-2-based cohort exclusion.
