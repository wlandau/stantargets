#' @title Multiple optimization runs per model with tidy output
#' @keywords internal
#' @description Internal function. Users should not invoke directly.
#' @return A list of target objects.
#'   Target objects represent skippable steps of the analysis pipeline
#'   as described at <https://books.ropensci.org/targets/>.
#'   Developers can consult the design specification at
#'   <https://books.ropensci.org/targets-design/>
#'   to learn about the structure and composition of target objects.
#' @inheritParams tar_stan_mle_rep_run
#' @inheritParams tar_stan_mcmc_rep
#' @inheritParams tar_stan_summary
#' @inheritParams cmdstanr::cmdstan_model
#' @inheritParams cmdstanr::`model-method-compile`
#' @inheritParams cmdstanr::`model-method-optimize`
#' @inheritParams cmdstanr::`fit-method-draws`
#' @inheritParams targets::tar_target
tar_stan_mle_rep <- function(
  name,
  stan_files,
  data = list(),
  output_type = c("summary", "draws"),
  batches = 1L,
  reps = 1L,
  combine = TRUE,
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
  algorithm = NULL,
  init_alpha = NULL,
  iter = NULL,
  tol_obj = NULL,
  tol_rel_obj = NULL,
  tol_grad = NULL,
  tol_rel_grad = NULL,
  tol_param = NULL,
  history_size = NULL,
  sig_figs = NULL,
  data_copy = character(0),
  variables = NULL,
  summaries = list(),
  summary_args = list(),
  tidy_eval = targets::tar_option_get("tidy_eval"),
  packages = targets::tar_option_get("packages"),
  library = targets::tar_option_get("library"),
  format = "qs",
  format_df = "fst_tbl",
  error = targets::tar_option_get("error"),
  memory = targets::tar_option_get("memory"),
  garbage_collection = targets::tar_option_get("garbage_collection"),
  deployment = targets::tar_option_get("deployment"),
  priority = targets::tar_option_get("priority"),
  resources = targets::tar_option_get("resources"),
  storage = targets::tar_option_get("storage"),
  retrieval = targets::tar_option_get("retrieval"),
  cue = targets::tar_option_get("cue")
) {
  envir <- tar_option_get("envir")
  compile <- match.arg(compile)
  targets::tar_assert_chr(stan_files)
  targets::tar_assert_unique(stan_files)
  lapply(stan_files, assert_stan_file)
  name_stan <- produce_stan_names(stan_files)
  name_file <- paste0(name, "_file")
  name_lines <- paste0(name, "_lines")
  name_batch <- paste0(name, "_batch")
  name_data <- paste0(name, "_data")
  sym_stan <- as_symbols(name_stan)
  sym_file <- as.symbol(name_file)
  sym_lines <- as.symbol(name_lines)
  sym_batch <- as.symbol(name_batch)
  sym_data <- as.symbol(name_data)
  command_batch <- substitute(seq_len(x), env = list(x = batches))
  command_rep <- targets::tar_tidy_eval(
    data,
    envir = envir,
    tidy_eval = tidy_eval
  )
  command_data <- substitute(
    purrr::map(seq_len(.targets_reps), ~.targets_command),
    env = list(.targets_reps = reps, .targets_command = command_rep)
  )
  args <- list(
    call_ns("stantargets", "tar_stan_mle_rep_run"),
    stan_file = if_any(identical(compile, "original"), sym_file, sym_lines),
    stan_name = quote(._stantargets_name_chr_50e43091),
    stan_path = quote(._stantargets_file_50e43091),
    data = sym_data,
    output_type = match.arg(output_type),
    compile = compile,
    quiet = quiet,
    stdout = stdout,
    stderr = stderr,
    dir = dir,
    pedantic = pedantic,
    include_paths = include_paths,
    cpp_options = cpp_options,
    stanc_options = stanc_options,
    force_recompile = force_recompile,
    seed = seed,
    refresh = refresh,
    init = init,
    save_latent_dynamics = save_latent_dynamics,
    output_dir = output_dir,
    algorithm = algorithm,
    init_alpha = init_alpha,
    iter = iter,
    sig_figs = sig_figs,
    tol_obj = tol_obj,
    tol_rel_obj = tol_rel_obj,
    tol_grad = tol_grad,
    tol_rel_grad = tol_rel_grad,
    tol_param = tol_param,
    history_size = history_size,
    data_copy = data_copy,
    variables = variables,
    summaries = summaries,
    summary_args = summary_args
  )
  command <- as.expression(as.call(args))
  pattern_data <- substitute(map(x), env = list(x = sym_batch))
  pattern <- substitute(map(x), env = list(x = sym_data))
  target_file <- targets::tar_target_raw(
    name = name_file,
    command = quote(._stantargets_file_50e43091),
    packages = character(0),
    format = "file",
    error = error,
    memory = memory,
    garbage_collection = garbage_collection,
    deployment = "main",
    priority = priority,
    cue = cue
  )
  target_compile <- tar_stan_compile_raw(
    name = name_file,
    stan_file = quote(._stantargets_file_50e43091),
    quiet = quiet,
    stdout = stdout,
    stderr = stderr,
    dir = dir,
    pedantic = pedantic,
    include_paths = include_paths,
    cpp_options = cpp_options,
    stanc_options = stanc_options,
    force_recompile = force_recompile,
    error = error,
    memory = memory,
    garbage_collection = garbage_collection,
    deployment = deployment,
    priority = priority,
    resources = resources,
    storage = storage,
    retrieval = retrieval,
    cue = cue
  )
  target_lines <- targets::tar_target_raw(
    name = name_lines,
    command = command_lines(sym_file),
    packages = character(0),
    error = error,
    memory = memory,
    garbage_collection = garbage_collection,
    deployment = "main",
    priority = priority,
    cue = cue
  )
  target_batch <- targets::tar_target_raw(
    name = name_batch,
    command = command_batch,
    packages = character(0),
    error = error,
    memory = memory,
    garbage_collection = garbage_collection,
    deployment = "main",
    priority = priority,
    cue = cue
  )
  target_data <- targets::tar_target_raw(
    name = name_data,
    command = command_data,
    pattern = pattern_data,
    packages = packages,
    library = library,
    format = format,
    iteration = "list",
    error = error,
    memory = memory,
    garbage_collection = garbage_collection,
    deployment = deployment,
    priority = priority,
    cue = cue
  )
  target_output <- targets::tar_target_raw(
    name = name,
    command = command,
    pattern = pattern,
    packages = character(0),
    format = format_df,
    error = error,
    memory = memory,
    garbage_collection = garbage_collection,
    deployment = deployment,
    priority = priority,
    resources = resources,
    storage = storage,
    retrieval = retrieval,
    cue = cue
  )
  tar_stan_target_list_rep(
    name = name,
    name_batch = name_batch,
    name_data = name_data,
    name_stan = name_stan,
    sym_stan = sym_stan,
    stan_files = stan_files,
    compile = compile,
    combine = combine,
    target_batch = target_batch,
    target_compile = target_compile,
    target_file = target_file,
    target_lines = target_lines,
    target_data = target_data,
    target_output = target_output,
    packages = packages,
    error = error,
    memory = memory,
    garbage_collection = garbage_collection,
    priority = priority,
    resources = resources,
    cue = cue
  )
}

#' @title Run a Stan model and return only the summaries.
#' @export
#' @keywords internal
#' @description Not a user-side function. Do not invoke directly.
#' @return A data frame of posterior summaries.
#' @inheritParams cmdstanr::cmdstan_model
#' @inheritParams cmdstanr::`model-method-compile`
#' @inheritParams cmdstanr::`model-method-optimize`
#' @inheritParams cmdstanr::`fit-method-draws`
tar_stan_mle_rep_run <- function(
  stan_file,
  stan_name,
  stan_path,
  data,
  output_type,
  compile,
  quiet,
  stdout,
  stderr,
  dir,
  pedantic,
  include_paths,
  cpp_options,
  stanc_options,
  force_recompile,
  seed,
  refresh,
  init,
  save_latent_dynamics,
  output_dir,
  algorithm,
  init_alpha,
  iter,
  sig_figs,
  tol_obj,
  tol_rel_obj,
  tol_grad,
  tol_rel_grad,
  tol_param,
  history_size,
  data_copy,
  variables,
  summaries,
  summary_args
) {
  if (!is.null(stdout)) {
    withr::local_output_sink(new = stdout, append = TRUE)
  }
  if (!is.null(stderr)) {
    withr::local_message_sink(new = stderr, append = TRUE)
  }
  file <- stan_file
  if (identical(compile, "copy")) {
    tmp <- tempfile(pattern = "", fileext = ".stan")
    writeLines(stan_file, tmp)
    file <- tmp
  }
  file <- grep("*.stan$", file, value = TRUE)
  model <- cmdstanr::cmdstan_model(
    stan_file = file,
    compile = TRUE,
    quiet = quiet,
    dir = dir,
    pedantic = pedantic,
    include_paths = include_paths,
    cpp_options = cpp_options,
    stanc_options = stanc_options,
    force_recompile = force_recompile
  )
  if (is.null(seed)) {
    seed <- abs(targets::tar_seed()) + 1L
  }
  seeds <- seed + seq_along(data)
  out <- purrr::map2_dfr(
    .x = data,
    .y = seeds,
    ~tar_stan_mle_rep_run_rep(
      data = .x,
      seed = .y,
      output_type = output_type,
      model = model,
      refresh = refresh,
      init = init,
      save_latent_dynamics = save_latent_dynamics,
      output_dir = output_dir,
      algorithm = algorithm,
      init_alpha = init_alpha,
      iter = iter,
      sig_figs = sig_figs,
      tol_obj = tol_obj,
      tol_rel_obj = tol_rel_obj,
      tol_grad = tol_grad,
      tol_rel_grad = tol_rel_grad,
      tol_param = tol_param,
      history_size = history_size,
      data_copy = data_copy,
      variables = variables,
      summaries = summaries,
      summary_args = summary_args
    )
  )
  out$.file <- stan_path
  out$.name <- stan_name
  out
}

tar_stan_mle_rep_run_rep <- function(
  data,
  seed,
  output_type,
  model,
  refresh,
  init,
  save_latent_dynamics,
  output_dir,
  algorithm,
  init_alpha,
  iter,
  sig_figs,
  tol_obj,
  tol_rel_obj,
  tol_grad,
  tol_rel_grad,
  tol_param,
  history_size,
  data_copy,
  variables,
  summaries,
  summary_args
) {
  stan_data <- data
  stan_data$.join_data <- NULL
  fit <- model$optimize(
    data = stan_data,
    seed = seed,
    refresh = refresh,
    init = init,
    save_latent_dynamics = save_latent_dynamics,
    output_dir = output_dir,
    algorithm = algorithm,
    init_alpha = init_alpha,
    iter = iter,
    sig_figs = sig_figs,
    tol_obj = tol_obj,
    tol_rel_obj = tol_rel_obj,
    tol_grad = tol_grad,
    tol_rel_grad = tol_rel_grad,
    tol_param = tol_param,
    history_size = history_size
  )
  tar_stan_output(
    fit = fit,
    output_type = output_type,
    summaries = summaries,
    summary_args = summary_args,
    variables = variables,
    inc_warmup = NULL,
    data = data,
    data_copy = data_copy
  )
}
