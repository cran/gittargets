% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tar_git_snapshot.R
\name{tar_git_snapshot}
\alias{tar_git_snapshot}
\title{Snapshot the data repository (Git).}
\usage{
tar_git_snapshot(
  message = NULL,
  ref = "HEAD",
  code = getwd(),
  script = targets::tar_config_get("script"),
  store = targets::tar_config_get("store"),
  stash_gitignore = TRUE,
  reporter = targets::tar_config_get("reporter_outdated"),
  envir = parent.frame(),
  callr_function = callr::r,
  callr_arguments = NULL,
  status = interactive(),
  force = FALSE,
  pack_refs = TRUE,
  verbose = TRUE
)
}
\arguments{
\item{message}{Optional Git commit message of the data snapshot.
If \code{NULL}, then the message is the Git commit message of the
matching code commit.}

\item{ref}{Character of length 1, reference
(branch name, Git SHA1 hash, etc.) of the code commit
that will map to the new data snapshot. Defaults to the commit
checked out right now.}

\item{code}{Character of length 1, directory path to the code repository,
usually the root of the \code{targets} project.}

\item{script}{Character of length 1, path to the
target script file. Defaults to \code{tar_config_get("script")},
which in turn defaults to \verb{_targets.R}. When you set
this argument, the value of \code{tar_config_get("script")}
is temporarily changed for the current function call.
See \code{\link[targets:tar_script]{tar_script()}},
\code{\link[targets:tar_config_get]{tar_config_get()}}, and \code{\link[targets:tar_config_set]{tar_config_set()}} for details
about the target script file and how to set it
persistently for a project.}

\item{store}{Character of length 1, path to the data store of the pipeline.
If \code{NULL}, the \code{store} setting is left unchanged in the
YAML configuration file (default: \verb{_targets.yaml}).
Usually, the data store lives at \verb{_targets}.
Set \code{store} to a custom directory
to specify a path other than \verb{_targets/}. The path need not exist
before the pipeline begins, and it need not end with "_targets",
but it must be writeable.
For optimal performance, choose a storage location
with fast read/write access.
If the argument \code{NULL}, the setting is not modified.
Use \code{\link[targets:tar_config_unset]{tar_config_unset()}} to delete a setting.}

\item{stash_gitignore}{Logical of length 1, whether to temporarily
stash the \code{.gitignore} file of the data store. See the
"Stashing .gitignore" section for details.}

\item{reporter}{Character of length 1, name of the reporter to user.
Controls how messages are printed as targets are checked. Choices:
\itemize{
\item \code{"silent"}: print nothing.
\item \code{"forecast"}: print running totals of the checked and outdated
targets found so far.
}}

\item{envir}{An environment, where to run the target R script
(default: \verb{_targets.R}) if \code{callr_function} is \code{NULL}.
Ignored if \code{callr_function} is anything other than \code{NULL}.
\code{callr_function} should only be \code{NULL} for debugging and
testing purposes, not for serious runs of a pipeline, etc.

The \code{envir} argument of \code{\link[targets:tar_make]{tar_make()}} and related
functions always overrides
the current value of \code{tar_option_get("envir")} in the current R session
just before running the target script file,
so whenever you need to set an alternative \code{envir}, you should always set
it with \code{tar_option_set()} from within the target script file.
In other words, if you call \code{tar_option_set(envir = envir1)} in an
interactive session and then
\code{tar_make(envir = envir2, callr_function = NULL)},
then \code{envir2} will be used.}

\item{callr_function}{A function from \code{callr} to start a fresh clean R
process to do the work. Set to \code{NULL} to run in the current session
instead of an external process (but restart your R session just before
you do in order to clear debris out of the global environment).
\code{callr_function} needs to be \code{NULL} for interactive debugging,
e.g. \code{tar_option_set(debug = "your_target")}.
However, \code{callr_function} should not be \code{NULL} for serious
reproducible work.}

\item{callr_arguments}{A list of arguments to \code{callr_function}.}

\item{status}{Logical of length 1, whether to print the project status
with \code{\link[=tar_git_status]{tar_git_status()}} and ask whether a snapshot should be created.}

\item{force}{Logical of length 1. Force checkout the data branch
of an existing data snapshot of the current code commit?}

\item{pack_refs}{Logical of length 1, whether to run \verb{git pack-refs --all}
in the data store after taking the snapshot. Packing references
improves efficiency when the number of snapshots is large.
Learn more at \url{https://git-scm.com/docs/git-pack-refs}.}

\item{verbose}{Logical of length 1, whether to print R console messages
confirming that a snapshot was created.}
}
\description{
Snapshot the Git data repository of a \code{targets} project.
}
\details{
A Git-backed \code{gittargets} data snapshot is a special kind of
Git commit. Every data commit is part of a branch specific to
the current code commit.
That way, when you switch branches or commits in the code,
\code{tar_git_checkout()} checks out the latest data snapshot
that matches the code in your workspace.
That way, your targets can stay up to date even as you
transition among multiple branches.
}
\section{Stashing .gitignore}{

The \code{targets} package writes a \code{.gitignore} file to new data stores
in order to prevent accidental commits to the code Git repository.
Unfortunately, for \code{gittargets}, this automatic \code{.gitignore} file
interferes with proper data versioning. So by default, \code{gittargets}
temporarily stashes it to a hidden file called \code{.gittargets_gitignore}
inside the data store. If your R program crashes while the stash
is active, you can simply move it manually back to \code{.gitignore}
or run \code{tar_git_status_data()} to restore the stash automatically
if no \code{.gitignore} already exists.
}

\examples{
if (Sys.getenv("TAR_EXAMPLES") == "true" && tar_git_ok(verbose = FALSE)) {
targets::tar_dir({ # Containing code does not modify the user's filespace.
targets::tar_script(tar_target(data, 1))
targets::tar_make()
gert::git_init()
gert::git_add("_targets.R")
gert::git_commit("First commit")
tar_git_init()
tar_git_snapshot(status = FALSE)
})
}
}
\seealso{
Other git: 
\code{\link{tar_git_checkout}()},
\code{\link{tar_git_init}()},
\code{\link{tar_git_log}()},
\code{\link{tar_git_ok}()},
\code{\link{tar_git_status_code}()},
\code{\link{tar_git_status_data}()},
\code{\link{tar_git_status_targets}()},
\code{\link{tar_git_status}()}
}
\concept{git}
