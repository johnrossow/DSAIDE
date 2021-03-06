# This function is used in the solver function and has no independent usages
heterogeneityeq <- function(t, y, parms)
{
  with(
    as.list(c(y,parms)), #lets us access variables and parameters stored in y and pars by name
    {
      
      #the ordinary differential equations
      dS1 =  - S1 * (b11 * I1 + b12 * I2) + w1 * R1; #susceptibles
      dI1 =  S1 * (b11 * I1 + b12 * I2)  - g1 * I1 #infected, symptomatic
      dR1 =   g1 * I1 - w1 * R1 #recovered, immune

      dS2 =  - S2 * (b21 * I1 + b22 * I2) + w2 * R2; #susceptibles type 2
      dI2 =  S2 * (b21 * I1 + b22 * I2)  - g2 * I2 #infected, symptomatic type 2
      dR2 =   g2 * I2 - w2 * R2 #recovered, immune type 2
      

      list(c(dS1, dI1, dR1, dS2, dI2, dR2))
    }
  ) #close with statement
} #end function specifying the ODEs

 
  
#' Simulation of a compartmental infectious disease transmission model with 2 types of hosts
#'
#' @description  This model allows for the simulation of an ID with 2 types of hosts
#' 
#'
#' @param S10 initial total number of type 1 hosts 
#' @param I10 initial number of infected type 1 hosts
#' @param S20 initial total number of type 2 hosts 
#' @param I20 initial number of infected type 2 hosts
#' @param tmax maximum simulation time, units of months
#' @param b11 rate of transmission from infected type 1 host to susceptible type 1 host
#' @param b12 rate of transmission from infected type 2 host to susceptible type 1 host
#' @param b21 rate of transmission from infected type 1 host to susceptible type 2 host
#' @param b22 rate of transmission from infected type 2 host to susceptible type 2 host
#' @param g1 the rate at which infected type 1 hosts recover
#' @param g2 the rate at which infected type 2 hosts recover
#' @param w1 the rate at which type 1 host immunity wanes
#' @param w2 the rate at which type 2 host immunity wanes
#' @return This function returns the simulation result as obtained from a call
#'   to the deSolve ode solver
#' @details A compartmental ID model with several states/compartments
#'   is simulated as a set of ordinary differential
#'   equations. The function returns the output from the odesolver as a matrix,
#'   with one column per compartment/variable. The first column is time.
#' @section Warning:
#'   This function does not perform any error checking. So if you try to do
#'   something nonsensical (e.g. any negative values or fractions > 1),
#'   the code will likely abort with an error message
#' @examples
#'   # To run the simulation with default parameters just call this function
#'   result <- simulate_heterogeneity()
#'   # To choose parameter values other than the standard one, specify them e.g. like such
#'   result <- simulate_heterogeneity(S10 = 100, S20 = 1e3,  tmax = 100)
#'   # You should then use the simulation result returned from the function, e.g. like this:
#'   plot(result[,1],result[,2],xlab='Time',ylab='Number Susceptible',type='l')
#' @seealso The UI of the shiny app 'Host Heterogeneity', which is part of this package, contains more details on the model
#' @author Andreas Handel
#' @references See e.g. Keeling and Rohani 2008 for SIR models and the
#'   documentation for the deSolve package for details on ODE solvers
#' @export


simulate_heterogeneity <- function(S10 = 1e3, I10 = 1, S20 = 1e3, I20 = 0, tmax = 120, b11 = 0.01, b12 = 0, b21 = 0, b22 = 0, g1 = 1, g2 = 1, w1 = 0, w2 = 0)
{
  ############################################################
  Y0 = c(S1 = S10, I1 = I10, R1 = 0, S2 = S20, I2 = I20, R2 = 0);  #combine initial conditions into a vector
  dt = min(0.1, tmax / 1000); #time step for which to get results back
  timevec = seq(0, tmax, dt); #vector of times for which solution is returned (not that internal timestep of the integrator is different)
  
  
  ############################################################
  #vector of parameters which is sent to the ODE function  
  pars=c(b11 = b11, b12 = b12, b21 = b21, b22 = b22, g1 = g1, w1 = w1, g2 = g2, w2 = w2); 

  #this line runs the simulation, i.e. integrates the differential equations describing the infection process
  #the result is saved in the odeoutput matrix, with the 1st column the time, the 2nd, 3rd, 4th column the variables S, I, R
  #This odeoutput matrix will be re-created every time you run the code, so any previous results will be overwritten
  odeoutput = deSolve::lsoda(Y0, timevec, func = heterogeneityeq, parms=pars, atol=1e-12, rtol=1e-12);

  return (odeoutput)
}
