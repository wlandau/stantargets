% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tar_stan_mcmc_rep_diagnostics.R
\name{tar_stan_mcmc_rep_diagnostics}
\alias{tar_stan_mcmc_rep_diagnostics}
\title{Multiple MCMCs per model with sampler diagnostics}
\usage{
tar_stan_mcmc_rep_diagnostics(
  name,
  stan_files,
  data = list(),
  batches = 1L,
  reps = 1L,
  combine = FALSE,
  compile = c("original", "copy"),
  quiet = TRUE,
  stdout = NULL,
  stderr = NULL,
  dir = NULL,
  pedantic = FALSE,
  include_paths = NULL,
  cpp_options = list(),
  stanc_options = list(),
  force_recompile = FALSE,
  seed = NULL,
  refresh = NULL,
  init = NULL,
  save_latent_dynamics = FALSE,
  output_dir = NULL,
  chains = 4,
  parallel_chains = getOption("mc.cores", 1),
  chain_ids = seq_len(chains),
  threads_per_chain = NULL,
  iter_warmup = NULL,
  iter_sampling = NULL,
  save_warmup = FALSE,
  thin = NULL,
  max_treedepth = NULL,
  adapt_engaged = TRUE,
  adapt_delta = NULL,
  step_size = NULL,
  metric = NULL,
  metric_file = NULL,
  inv_metric = NULL,
  init_buffer = NULL,
  term_buffer = NULL,
  window = NULL,
  fixed_param = FALSE,
  sig_figs = NULL,
  validate_csv = TRUE,
  show_messages = TRUE,
  inc_warmup = FALSE,
  data_copy = character(0),
  tidy_eval = targets::tar_option_get("tidy_eval"),
  packages = targets::tar_option_get("packages"),
  library = targets::tar_option_get("library"),
  format = "qs",
  format_df = "fst_tbl",
  error = targets::tar_option_get("error"),
  memory = "transient",
  garbage_collection = TRUE,
  deployment = targets::tar_option_get("deployment"),
  priority = targets::tar_option_get("priority"),
  resources = targets::tar_option_get("resources"),
  storage = targets::tar_option_get("storage"),
  retrieval = targets::tar_option_get("retrieval"),
  cue = targets::tar_option_get("cue")
)
}
\arguments{
\item{name}{Symbol, base name for the collection of targets.
Serves as a prefix for target names.}

\item{stan_files}{Character vector of paths to known existing Stan model
files created before running the pipeline.}

\item{data}{Code to generate a single replication of a simulated dataset.
The workflow simulates multiple datasets, and each
model runs on each dataset. To join data on to the model
summaries, include a \code{.join_data}
element of your Stan data list with names and dimensions corresponding
to those of the model. For details, read
\url{https://docs.ropensci.org/stantargets/articles/mcmc_rep.html}.}

\item{batches}{Number of batches. Each batch is a sequence
of branch targets containing multiple reps. Each rep
generates a dataset and runs the model on it.}

\item{reps}{Number of replications per batch.}

\item{combine}{Logical, whether to create a target to
combine all the model results
into a single data frame downstream. Convenient, but
duplicates data.}

\item{compile}{(logical) Do compilation? The default is \code{TRUE}. If \code{FALSE}
compilation can be done later via the \code{\link[cmdstanr:model-method-compile]{$compile()}}
method.}

\item{quiet}{(logical) Should the verbose output from CmdStan during
compilation be suppressed? The default is \code{TRUE}, but if you encounter an
error we recommend trying again with \code{quiet=FALSE} to see more of the
output.}

\item{stdout}{Character of length 1, file path to write the stdout stream
of the model when it runs. Set to \code{NULL} to print to the console.
Set to \code{R.utils::nullfile()} to suppress stdout.
Does not apply to messages, warnings, or errors.}

\item{stderr}{Character of length 1, file path to write the stderr stream
of the model when it runs. Set to \code{NULL} to print to the console.
Set to \code{R.utils::nullfile()} to suppress stderr.
Does not apply to messages, warnings, or errors.}

\item{dir}{(string) The path to the directory in which to store the CmdStan
executable (or \code{.hpp} file if using \verb{$save_hpp_file()}). The default is the
same location as the Stan program.}

\item{pedantic}{(logical) Should pedantic mode be turned on? The default is
\code{FALSE}. Pedantic mode attempts to warn you about potential issues in your
Stan program beyond syntax errors. For details see the \href{https://mc-stan.org/docs/reference-manual/pedantic-mode.html}{\emph{Pedantic mode} chapter} in
the Stan Reference Manual. \strong{Note:} to do a pedantic check for a model
that is already compiled use the
\code{\link[cmdstanr:model-method-check_syntax]{$check_syntax()}} method instead.}

\item{include_paths}{(character vector) Paths to directories where Stan
should look for files specified in \verb{#include} directives in the Stan
program.}

\item{cpp_options}{(list) Any makefile options to be used when compiling the
model (\code{STAN_THREADS}, \code{STAN_MPI}, \code{STAN_OPENCL}, etc.). Anything you would
otherwise write in the \code{make/local} file.}

\item{stanc_options}{(list) Any Stan-to-C++ transpiler options to be used
when compiling the model. See the \strong{Examples} section below as well as the
\code{stanc} chapter of the CmdStan Guide for more details on available options:
https://mc-stan.org/docs/cmdstan-guide/stanc.html.}

\item{force_recompile}{(logical) Should the model be recompiled even if was
not modified since last compiled. The default is \code{FALSE}.}

\item{seed}{(positive integer(s)) A seed for the (P)RNG to pass to CmdStan.
In the case of multi-chain sampling the single \code{seed} will automatically be
augmented by the the run (chain) ID so that each chain uses a different
seed. The exception is the transformed data block, which defaults to
using same seed for all chains so that the same data is generated for all
chains if RNG functions are used. The only time \code{seed} should be specified
as a vector (one element per chain) is if RNG functions are used in
transformed data and the goal is to generate \emph{different} data for each
chain.}

\item{refresh}{(non-negative integer) The number of iterations between
printed screen updates. If \code{refresh = 0}, only error messages will be
printed.}

\item{init}{(multiple options) The initialization method to use for the
variables declared in the parameters block of the Stan program:
\itemize{
\item A real number \code{x>0}. This initializes \emph{all} parameters randomly between
\verb{[-x,x]} (on the \emph{unconstrained} parameter space);
\item The number \code{0}. This initializes \emph{all} parameters to \code{0};
\item A character vector of paths (one per chain) to JSON or Rdump files
containing initial values for all or some parameters. See
\code{\link[cmdstanr:write_stan_json]{write_stan_json()}} to write \R objects to JSON files compatible with
CmdStan.
\item A list of lists containing initial values for all or some parameters. For
MCMC the list should contain a sublist for each chain. For optimization and
variational inference there should be just one sublist. The sublists should
have named elements corresponding to the parameters for which you are
specifying initial values. See \strong{Examples}.
\item A function that returns a single list with names corresponding to the
parameters for which you are specifying initial values. The function can
take no arguments or a single argument \code{chain_id}. For MCMC, if the function
has argument \code{chain_id} it will be supplied with the chain id (from 1 to
number of chains) when called to generate the initial values. See
\strong{Examples}.
}}

\item{save_latent_dynamics}{(logical) Should auxiliary diagnostic information
about the latent dynamics be written to temporary diagnostic CSV files?
This argument replaces CmdStan's \code{diagnostic_file} argument and the content
written to CSV is controlled by the user's CmdStan installation and not
CmdStanR (for some algorithms no content may be written). The default
is \code{FALSE}, which is appropriate for almost every use case. To save the
temporary files created when \code{save_latent_dynamics=TRUE} see the
\code{\link[cmdstanr:fit-method-save_output_files]{$save_latent_dynamics_files()}}
method.}

\item{output_dir}{(string) A path to a directory where CmdStan should write
its output CSV files. For interactive use this can typically be left at
\code{NULL} (temporary directory) since CmdStanR makes the CmdStan output
(posterior draws and diagnostics) available in \R via methods of the fitted
model objects. The behavior of \code{output_dir} is as follows:
\itemize{
\item If \code{NULL} (the default), then the CSV files are written to a temporary
directory and only saved permanently if the user calls one of the \verb{$save_*}
methods of the fitted model object (e.g.,
\code{\link[cmdstanr:fit-method-save_output_files]{$save_output_files()}}). These temporary
files are removed when the fitted model object is
\link[base:gc]{garbage collected} (manually or automatically).
\item If a path, then the files are created in \code{output_dir} with names
corresponding to the defaults used by \verb{$save_output_files()}.
}}

\item{chains}{(positive integer) The number of Markov chains to run. The
default is 4.}

\item{parallel_chains}{(positive integer) The \emph{maximum} number of MCMC chains
to run in parallel. If \code{parallel_chains} is not specified then the default
is to look for the option \code{"mc.cores"}, which can be set for an entire \R
session by \code{options(mc.cores=value)}. If the \code{"mc.cores"} option has not
been set then the default is \code{1}.}

\item{chain_ids}{(integer vector) A vector of chain IDs. Must contain
\code{chains} unique positive integers. If not set, the default chain IDs are
used (integers starting from \code{1}).}

\item{threads_per_chain}{(positive integer) If the model was
\link[cmdstanr:model-method-compile]{compiled} with threading support, the number of
threads to use in parallelized sections \emph{within} an MCMC chain (e.g., when
using the Stan functions \code{reduce_sum()} or \code{map_rect()}). This is in
contrast with \code{parallel_chains}, which specifies the number of chains to
run in parallel. The actual number of CPU cores used use is
\code{parallel_chains*threads_per_chain}. For an example of using threading see
the Stan case study \href{https://mc-stan.org/users/documentation/case-studies/reduce_sum_tutorial.html}{Reduce Sum: A Minimal Example}.}

\item{iter_warmup}{(positive integer) The number of warmup iterations to run
per chain. Note: in the CmdStan User's Guide this is referred to as
\code{num_warmup}.}

\item{iter_sampling}{(positive integer) The number of post-warmup iterations
to run per chain. Note: in the CmdStan User's Guide this is referred to as
\code{num_samples}.}

\item{save_warmup}{(logical) Should warmup iterations be saved? The default
is \code{FALSE}. If \code{save_warmup=TRUE} then you can use
\link[cmdstanr:fit-method-draws]{$draws(inc_warmup=TRUE)} to include warmup when
accessing the draws.}

\item{thin}{(positive integer) The period between saved samples. This should
typically be left at its default (no thinning) unless memory is a problem.}

\item{max_treedepth}{(positive integer) The maximum allowed tree depth for
the NUTS engine. See the \emph{Tree Depth} section of the CmdStan User's Guide
for more details.}

\item{adapt_engaged}{(logical) Do warmup adaptation? The default is \code{TRUE}.
If a precomputed inverse metric is specified via the \code{inv_metric} argument
(or \code{metric_file}) then, if \code{adapt_engaged=TRUE}, Stan will use the
provided inverse metric just as an initial guess during adaptation. To turn
off adaptation when using a precomputed inverse metric set
\code{adapt_engaged=FALSE}.}

\item{adapt_delta}{(real in \verb{(0,1)}) The adaptation target acceptance
statistic.}

\item{step_size}{(positive real) The \emph{initial} step size for the discrete
approximation to continuous Hamiltonian dynamics. This is further tuned
during warmup.}

\item{metric}{(string) One of \code{"diag_e"}, \code{"dense_e"}, or \code{"unit_e"},
specifying the geometry of the base manifold. See the \emph{Euclidean Metric}
section of the CmdStan User's Guide for more details. To specify a
precomputed (inverse) metric, see the \code{inv_metric} argument below.}

\item{metric_file}{(character vector) The paths to JSON or
Rdump files (one per chain) compatible with CmdStan that contain
precomputed inverse metrics. The \code{metric_file} argument is inherited from
CmdStan but is confusing in that the entry in JSON or Rdump file(s) must be
named \code{inv_metric}, referring to the \emph{inverse} metric. We recommend instead
using CmdStanR's \code{inv_metric} argument (see below) to specify an inverse
metric directly using a vector or matrix from your \R session.}

\item{inv_metric}{(vector, matrix) A vector (if \code{metric='diag_e'}) or a
matrix (if \code{metric='dense_e'}) for initializing the inverse metric. This
can be used as an alternative to the \code{metric_file} argument. A vector is
interpreted as a diagonal metric. The inverse metric is usually set to an
estimate of the posterior covariance. See the \code{adapt_engaged} argument
above for details about (and control over) how specifying a precomputed
inverse metric interacts with adaptation.}

\item{init_buffer}{(nonnegative integer) Width of initial fast timestep
adaptation interval during warmup.}

\item{term_buffer}{(nonnegative integer) Width of final fast timestep
adaptation interval during warmup.}

\item{window}{(nonnegative integer) Initial width of slow timestep/metric
adaptation interval.}

\item{fixed_param}{(logical) When \code{TRUE}, call CmdStan with argument
\code{"algorithm=fixed_param"}. The default is \code{FALSE}. The fixed parameter
sampler generates a new sample without changing the current state of the
Markov chain; only generated quantities may change. This can be useful
when, for example, trying to generate pseudo-data using the generated
quantities block. If the parameters block is empty then using
\code{fixed_param=TRUE} is mandatory. When \code{fixed_param=TRUE} the \code{chains} and
\code{parallel_chains} arguments will be set to \code{1}.}

\item{sig_figs}{(positive integer) The number of significant figures used
when storing the output values. By default, CmdStan represent the output
values with 6 significant figures. The upper limit for \code{sig_figs} is 18.
Increasing this value will result in larger output CSV files and thus an
increased usage of disk space.}

\item{validate_csv}{(logical) When \code{TRUE} (the default), validate the
sampling results in the csv files. Disable if you wish to manually read in
the sampling results and validate them yourself, for example using
\code{\link[cmdstanr:read_cmdstan_csv]{read_cmdstan_csv()}}.}

\item{show_messages}{(logical) When \code{TRUE} (the default), prints all
informational messages, for example rejection of the current proposal.
Disable if you wish silence these messages, but this is not recommended
unless you are very sure that the model is correct up to numerical error.
If the messages are silenced then the \verb{$output()} method of the resulting
fit object can be used to display all the silenced messages.}

\item{inc_warmup}{(logical) Should warmup draws be included? Defaults to
\code{FALSE}. Ignored except when used with \link[cmdstanr]{CmdStanMCMC} objects.}

\item{data_copy}{Character vector of names of scalars in \code{data}.
These values will be inserted as columns in the output data frame
for each rep. To join more than just scalars, include a \code{.join_data}
element of your Stan data list with names and dimensions corresponding
to those of the model. For details, read
\url{https://docs.ropensci.org/stantargets/articles/mcmc_rep.html}.}

\item{tidy_eval}{Logical, whether to enable tidy evaluation
when interpreting \code{command} and \code{pattern}. If \code{TRUE}, you can use the
"bang-bang" operator \verb{!!} to programmatically insert
the values of global objects.}

\item{packages}{Character vector of packages to load right before
the target builds. Use \code{tar_option_set()} to set packages
globally for all subsequent targets you define.}

\item{library}{Character vector of library paths to try
when loading \code{packages}.}

\item{format}{Character of length 1, storage format of the data frame
of posterior summaries. We recommend efficient data frame formats
such as \code{"feather"} or \code{"aws_parquet"}. For more on storage formats,
see the help file of \code{targets::tar_target()}.}

\item{format_df}{Character of length 1, storage format of the data frame
targets such as posterior draws. We recommend efficient data frame formats
such as \code{"feather"} or \code{"aws_parquet"}. For more on storage formats,
see the help file of \code{targets::tar_target()}.}

\item{error}{Character of length 1, what to do if the target
runs into an error. If \code{"stop"}, the whole pipeline stops
and throws an error. If \code{"continue"}, the error is recorded,
but the pipeline keeps going. \code{error = "workspace"} is just like
\code{error = "stop"} except \code{targets} saves a special workspace file
to support interactive debugging outside the pipeline.
(Visit \url{https://books.ropensci.org/targets/debugging.html}
to learn how to debug targets using saved workspaces.)}

\item{memory}{Character of length 1, memory strategy.
If \code{"persistent"}, the target stays in memory
until the end of the pipeline (unless \code{storage} is \code{"worker"},
in which case \code{targets} unloads the value from memory
right after storing it in order to avoid sending
copious data over a network).
If \code{"transient"}, the target gets unloaded
after every new target completes.
Either way, the target gets automatically loaded into memory
whenever another target needs the value.
For cloud-based dynamic files such as \code{format = "aws_file"},
this memory policy applies to
temporary local copies of the file in \verb{_targets/scratch/"}:
\code{"persistent"} means they remain until the end of the pipeline,
and \code{"transient"} means they get deleted from the file system
as soon as possible. The former conserves bandwidth,
and the latter conserves local storage.}

\item{garbage_collection}{Logical, whether to run \code{base::gc()}
just before the target runs.}

\item{deployment}{Character of length 1, only relevant to
\code{\link[targets:tar_make_clustermq]{tar_make_clustermq()}} and \code{\link[targets:tar_make_future]{tar_make_future()}}. If \code{"worker"},
the target builds on a parallel worker. If \code{"main"},
the target builds on the host machine / process managing the pipeline.}

\item{priority}{Numeric of length 1 between 0 and 1. Controls which
targets get deployed first when multiple competing targets are ready
simultaneously. Targets with priorities closer to 1 get built earlier
(and polled earlier in \code{\link[targets:tar_make_future]{tar_make_future()}}).}

\item{resources}{Object returned by \code{tar_resources()}
with optional settings for high-performance computing
functionality, alternative data storage formats,
and other optional capabilities of \code{targets}.
See \code{tar_resources()} for details.}

\item{storage}{Character of length 1, only relevant to
\code{\link[targets:tar_make_clustermq]{tar_make_clustermq()}} and \code{\link[targets:tar_make_future]{tar_make_future()}}.
If \code{"main"}, the target's return value is sent back to the
host machine and saved locally. If \code{"worker"}, the worker
saves the value.}

\item{retrieval}{Character of length 1, only relevant to
\code{\link[targets:tar_make_clustermq]{tar_make_clustermq()}} and \code{\link[targets:tar_make_future]{tar_make_future()}}.
If \code{"main"}, the target's dependencies are loaded on the host machine
and sent to the worker before the target builds.
If \code{"worker"}, the worker loads the targets dependencies.}

\item{cue}{An optional object from \code{tar_cue()} to customize the
rules that decide whether the target is up to date.}
}
\value{
\code{tar_stan_mcmc_rep_diagnostics()} returns
a list of target objects. See the "Target objects" section for
background.
The target names use the \code{name} argument as a prefix, and the individual
elements of \code{stan_files} appear in the suffixes where applicable.
As an example, the specific target objects returned by
\code{tar_stan_mcmc_rep_diagnostics(name = x, stan_files = "y.stan")}
are as follows.
\itemize{
\item \code{x_file_y}: reproducibly track the Stan model file. Returns
a character vector with the paths to the
model file and compiled executable.
\item \code{x_lines_y}: read the Stan model file for safe transport to
parallel workers. Omitted if \code{compile = "original"}.
Returns a character vector of lines in the model file.
\item \code{x_data}: use dynamic branching to generate multiple datasets
by repeatedly running the R expression in the \code{data} argument.
Each dynamic branch returns a batch of Stan data lists that \code{x_y}
supplies to the model.
\item \code{x_y}: dynamic branching target to run MCMC once per dataset.
Each dynamic branch returns a tidy data frames of HMC diagnostics
corresponding to a batch of Stan data from \code{x_data}.
\item \code{x}: combine all branches of \code{x_y} into a single non-dynamic target.
Suppressed if \code{combine} is \code{FALSE}.
Returns a long tidy data frame of HMC diagnostics.
}
}
\description{
\code{tar_stan_mcmc_rep_diagnostics()} creates targets
to run MCMC multiple times per model and save only the sampler
diagnostics from each run.
}
\details{
Saved diagnostics could get quite large in storage,
so please use thinning if necessary.

Most of the arguments are passed to the \verb{$compile()}
and \verb{$generate_quantities()} methods of the \code{CmdStanModel} class. If you
previously compiled the model in an upstream \code{\link[=tar_stan_compile]{tar_stan_compile()}}
target, then the model should not recompile.
}
\section{Target objects}{

Most \code{stantargets} functions are target factories,
which means they return target objects
or lists of target objects.
Target objects represent skippable steps of the analysis pipeline
as described at \url{https://books.ropensci.org/targets/}.
Please read the walkthrough at
\url{https://books.ropensci.org/targets/walkthrough.html}
to understand the role of target objects in analysis pipelines.

For developers,
\url{https://wlandau.github.io/targetopia/contributing.html#target-factories}
explains target factories (functions like this one which generate targets)
and the design specification at
\url{https://books.ropensci.org/targets-design/}
details the structure and composition of target objects.
}

\examples{
if (Sys.getenv("TAR_LONG_EXAMPLES") == "true") {
targets::tar_dir({ # tar_dir() runs code from a temporary directory.
targets::tar_script({
library(stantargets)
# Do not use temporary storage for stan files in real projects
# or else your targets will always rerun.
path <- tempfile(pattern = "", fileext = ".stan")
tar_stan_example_file(path = path)
list(
  tar_stan_mcmc_rep_diagnostics(
    your_model,
    stan_files = path,
    data = tar_stan_example_data(),
    batches = 2,
    reps = 2,
    stdout = R.utils::nullfile(),
    stderr = R.utils::nullfile()
  )
)
}, ask = FALSE)
targets::tar_make()
})
}
}
\seealso{
Other MCMC: 
\code{\link{tar_stan_mcmc_rep_draws}()},
\code{\link{tar_stan_mcmc_rep_summary}()},
\code{\link{tar_stan_mcmc}()}
}
\concept{MCMC}
