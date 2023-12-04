## ----setup, include = FALSE---------------------------------------------------
library(gert)
library(gittargets)
library(targets)
tmp <- tempfile()
dir.create(tmp)
knitr::opts_knit$set(root.dir = tmp)
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = identical(Sys.getenv("NOT_CRAN"), "true") &&
    tar_git_ok(verbose = FALSE)
)

## ----eval = FALSE-------------------------------------------------------------
#  # _targets.R
#  library(targets)
#  list(
#    tar_target(data, datasets::airquality),
#    tar_target(result, summary(data))
#  )

## ----echo = FALSE-------------------------------------------------------------
tar_script(
  list(
    tar_target(data, datasets::airquality),
    tar_target(result, summary(data))
  )
)

## -----------------------------------------------------------------------------
tar_make()

## -----------------------------------------------------------------------------
tar_read(result)

## ----message = FALSE, output = FALSE, results = "hide"------------------------
library(gert)
git_init()
git_add("_targets.R")
git_commit("Begin analyzing the airquality dataset")
git_branch_create("airquality")

## -----------------------------------------------------------------------------
tar_git_status()

## -----------------------------------------------------------------------------
tar_git_init()

## ----eval = FALSE-------------------------------------------------------------
#  tar_git_snapshot()

## ----echo = FALSE-------------------------------------------------------------
tar_git_snapshot(status = FALSE)

## ----eval = FALSE-------------------------------------------------------------
#  # _targets.R
#  library(targets)
#  list(
#    tar_target(data, datasets::UKgas), # different dataset
#    tar_target(result, summary(data))
#  )

## ----echo = FALSE-------------------------------------------------------------
tar_script(
  list(
    tar_target(data, datasets::UKgas),
    tar_target(result, summary(data))
  )
)

## -----------------------------------------------------------------------------
tar_make()

## -----------------------------------------------------------------------------
tar_read(result)

## -----------------------------------------------------------------------------
git_branch_create("UKgas")
git_add("_targets.R")
git_commit("Switch to UKgas dataset")

## ----eval = FALSE-------------------------------------------------------------
#  tar_git_snapshot()

## ----echo = FALSE-------------------------------------------------------------
tar_git_snapshot(status = FALSE)

## -----------------------------------------------------------------------------
tar_git_log()

## ----message = FALSE, output = FALSE, results = "hide"------------------------
git_branch_checkout("airquality")

## -----------------------------------------------------------------------------
tar_read(result)

## -----------------------------------------------------------------------------
tar_outdated()

## -----------------------------------------------------------------------------
tar_git_checkout()

## -----------------------------------------------------------------------------
tar_read(result)

## -----------------------------------------------------------------------------
tar_outdated()

