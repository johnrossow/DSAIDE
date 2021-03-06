#' DSAIDE: A package to learn about Dynamical Systems Approaches to Infectious
#' Disease Epidemiology
#'
#' The DSAIDE package provides a number of shiny apps that simulate various
#' infectious disease dynamics models By manipulating the models and working
#' through the instructions provided within the shiny UI, you can learn about
#' some important concepts in infectious disease epidemiology. You will also
#' learn how models can be used to study such concepts.
#'
#' @section Package Structure:
#'   The package is structured in a modular way. Each
#'   Shiny App runs a single infectious disease model. The underlying models are
#'   encoded as functions, which are called by the Shiny app. The structure of the
#'   package allows you to interact with the models in 3 ways:
#'
#'   1. Start the main menu of the package by calling dsaidemenu(). Pick a shiny
#'   app corresponding to a model, and explore the model through the
#'   corresponding shiny UI. The UI contains information about the model
#'   and a list of tasks to try. This is the main intended use of this package.
#'
#'   2. Call each simulator function directly from the R console, without going
#'   through the shiny app. Each model simulator function is called simulate_XXX
#'   and is documented. See the documentation for the package to find the names
#'   of the different simulation functions, or check the 'further information' 
#'   tab for a given shiny app. 
#'   You can call the functions with different initial condition and parameter values. 
#'   This allows you to for instance write a few
#'   lines of extra R code to loop over some model parameter, instead of the manual setting
#'   through the sliders in the shiny app. This gives you
#'   some more flexibility in what you can do with these functions, but requires
#'   being able to write a little bit of R code.
#'
#'   3. Find the code for a simulator function you are interested in and modify
#'   it to your needs. This provides the most flexibility in what you can do with 
#'   this package, and you can end up with any model you need, 
#'   but for that you need to know or learn some
#'   more R coding. To make it easy to get the source code for the simulator functions,
#'   they are located in a subdirectory called 'simulatorfunctions' inside the DSAIDE 
#'   package folder. 
#'
#' @docType package
#' @name DSAIDE
NULL
