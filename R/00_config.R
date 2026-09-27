# Shared path and database configuration for the public repository.

sofa2_project_root <- function() {
  root <- Sys.getenv("SOFA2_PROJECT_ROOT", unset = ".")
  normalizePath(root, winslash = "/", mustWork = TRUE)
}

sofa2_path <- function(...) {
  file.path(sofa2_project_root(), ...)
}

sofa2_output_dir <- function(...) {
  path <- sofa2_path("outputs", ...)
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  path
}

require_environment_variable <- function(name) {
  value <- Sys.getenv(name, unset = "")
  if (!nzchar(value)) stop("Set environment variable ", name, " before running this script.")
  value
}
