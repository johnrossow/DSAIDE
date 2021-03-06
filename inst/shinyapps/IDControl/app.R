############################################################
#This is the Shiny file for the ID Control App
#written by Andreas Handel and Sina Solaimanpour 
#maintained by Andreas Handel (ahandel@uga.edu)
#last updated 10/13/2016
############################################################

#the server-side function with the main functionality
#this function is wrapped inside the shiny server function below to allow return to main menu when window is closed
refresh <- function(input, output){
  
  # This reactive takes the input data and sends it over to the simulator
  # Then it will get the results back and return it as the "res" variable
  res <- reactive({
    input$submitBtn
    
    # Read all the input values from the UI
    S0 = isolate(input$S0);
    I0 = isolate(input$I0);
    E0 = isolate(input$E0);
    Sv0 = isolate(input$Sv0);
    Iv0 = isolate(input$Iv0);
    tmax = isolate(input$tmax);
    
    bP = isolate(input$bP);
    bA = isolate(input$bA);
    bI = isolate(input$bI);
    bE = isolate(input$bE);
    bv = isolate(input$bv);
    bh = isolate(input$bh);
    
    gP = isolate(input$gP);
    gA = isolate(input$gA);
    gI = isolate(input$gI);
    pA = isolate(input$pA);
    pI = isolate(input$pI);
    
    c = isolate(input$c);
    f = isolate(input$f);
    d = isolate(input$d);
    w = isolate(input$w);
    
    birthh = isolate(input$birthh);
    deathh = isolate(input$deathh);
    birthv = isolate(input$birthv);
    deathv = isolate(input$deathv);
    
    # Call the ODE solver with the given parameters
    result <- simulate_idcontrol(S0 = S0, I0 = I0, E0 = E0, Sv0 = Sv0, Iv0 = Iv0, tmax = tmax, bP = bP, bA = bA, bI = bI, bE = bE, bv = bv, bh = bh, gP = gP , gA = gA, gI = gI, pA = pA, pI = pI, c = c, f = f, d = d, w = w, birthh = birthh, deathh = deathh, birthv = birthv, deathv = deathv)
    
    return(list(result)) #this is returned as the res variable
  })
  
  #if we want certain variables plotted and reported separately, we can specify them manually as a list
  #if nothing is specified, all variables are plotted and reported at once
  varlist = list(c('S','P','A','I','R','D'),c('Sv','Iv'),c('E'))
  #function that takes result saved in res and produces output
  #output (plots, text, warnings) is stored in and modifies the global variable 'output'
  generate_simoutput(input,output,res,varlist=varlist)
} #ends the 'refresh' shiny server function that runs the simulation and returns output

#main shiny server function
server <- function(input, output, session) {
  
  # Waits for the Exit Button to be pressed to stop the app and return to main menu
  observeEvent(input$exitBtn, {
    input$exitBtn
    stopApp(returnValue = 0)
  })
  
  # This function is called to refresh the content of the Shiny App
  refresh(input, output)
  
  # Event handler to listen for the webpage and see when it closes.
  # Right after the window is closed, it will stop the app server and the main menu will
  # continue asking for inputs.
  session$onSessionEnded(function(){
    stopApp(returnValue = 0)
  })
} #ends the main shiny server function


#This is the UI part of the shiny App
ui <- fluidPage(
  includeCSS("../shinystyle.css"),
  #add header and title
  tags$head( tags$script(src="//cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML", type = 'text/javascript') ),
  div( includeHTML("www/header.html"), align = "center"),
  #specify name of App below, will show up in title
  h1('ID Control App', align = "center", style = "background-color:#123c66; color:#fff"),
  
  #section to add buttons
  fluidRow(
    column(6,
           actionButton("submitBtn", "Run Simulation", class="submitbutton")  
    ),
    column(6,
           actionButton("exitBtn", "Exit App", class="exitbutton")
    ),
    align = "center"
  ), #end section to add buttons
  
  tags$hr(),
  
  ################################
  #Split screen with input on left, output on right
  fluidRow(
    #all the inputs in here
    column(6,
           #################################
           # Inputs section
           h2('Simulation Settings'),
           fluidRow(
             column(4,
                    sliderInput("S0", "initial number of susceptible hosts", min = 100, max = 5000, value = 1000, step = 100)
             ),
             column(4,
                    sliderInput("I0", "initial number of symptomatic hosts", min = 0, max = 100, value = 0, step = 1)
             ),
             column(4,
                    sliderInput("E0", "initial amount of environmental pathogen", min = 0, max = 5000, value = 0, step = 100)
             )
           ), #close fluidRow structure for input
           fluidRow(
             column(4,
                    sliderInput("Sv0", "initial number of susceptible vectors", min = 0, max = 5000, value = 0, step = 100)
             ),
             column(4,
                    sliderInput("Iv0", "initial number of infected vectors", min = 0, max = 100, value = 0, step = 1)
             ),
             column(4,
                    sliderInput("tmax", "Maximum simulation time (months)", min = 1, max = 1200, value = 100, step = 1)
             )
           ), #close fluidRow structure for input
           fluidRow(
             column(4,
                    sliderInput("bP", "Rate of transmission from pre-symptomatic hosts", min = 0, max = 0.01, value = 0, step = 0.0001 , sep ='')
             ),
             column(4,
                    sliderInput("bA", "Rate of transmission from asymptomatic hosts", min = 0, max = 0.01, value = 0, step = 0.0001 , sep ='')
             ),
             column(4,
                    sliderInput("bI", "Rate of transmission from symptomatic hosts", min = 0, max = 0.01, value = 0, step = 0.0001 , sep ='')
             )
           ), #close fluidRow structure for input
           fluidRow(
             column(4,
                    sliderInput("bE", "Rate of transmission from environment", min = 0, max = 0.01, value = 0, step = 0.0001 , sep ='')
             ),
             column(4,
                    sliderInput("bv", "Rate of transmission from vectors", min = 0, max = 0.01, value = 0, step = 0.0001 , sep ='')
             ),
             column(4,
                    sliderInput("bh", "Rate of transmission to vectors", min = 0, max = 0.01, value = 0, step = 0.0001 , sep ='')
             )
           ), #close fluidRow structure for input
           fluidRow(
             column(4,
                    sliderInput("gP", "Rate at which presymptomatic hosts leave compartment", min = 0, max = 5, value = 0.5, step = 0.1)
             ),
             column(4,
                    sliderInput("gA", "Rate at which asymptomatic hosts leave compartment", min = 0, max = 5, value = 0.5, step = 0.1)
             ),
             column(4,
                    sliderInput("gI", "Rate at which symptomatic hosts leave compartment", min = 0, max = 5, value = 0.5, step = 0.1)
             )
           ), #close fluidRow structure for input
           
           fluidRow(
             column(4,
                    sliderInput("pA", "Rate of pathogen shedding by asymptomatic hosts", min = 0, max = 10, value = 0, step = 0.1)
             ),
             column(4,
                    sliderInput("pI", "Rate of pathogen shedding by symptomatic hosts", min = 0, max = 10, value = 0, step = 0.1)
             ),
             column(4,
                    sliderInput("c", "Rate of environmental pathogen decay", min = 0, max = 10, value = 0, step = 0.1 , sep ='')
             )
           ), #close fluidRow structure for input
           fluidRow(
             column(4,
                    sliderInput("f", "Fraction of hosts that are asymptomatic", min = 0, max = 1, value = 0, step = 0.1)
             ),
             column(4,
                    sliderInput("w", "Rate of waning host immunity", min = 0, max = 50, value = 0, step = 0.1)
             ),
             column(4,
                    sliderInput("d", "Fraction of symptomatic hosts that die", min = 0, max = 1, value = 0, step = 0.01 , sep ='')
             )
           ), #close fluidRow structure for input
           fluidRow(
             column(6,
                    sliderInput("birthh", "birth rate of hosts", min = 0, max = 100, value = 0, step = 0.01 , sep ='')
             ),
             column(6,
                    sliderInput("deathh", "death rate of hosts", min = 0, max = 100, value = 0, step = 0.01 , sep ='')
             )
           ), #close fluidRow structure for input
           fluidRow(
             column(6,
                    sliderInput("birthv", "birth rate of vectors", min = 0, max = 5000, value = 0, step = 1 , sep ='')
             ),
             column(6,
                    sliderInput("deathv", "death rate of vectors", min = 0, max = 30, value = 0, step = 0.1 , sep ='')
             )
           ) #close fluidRow structure for input
           
    ), #end sidebar column for inputs
    #all the outcomes here
    column(6,
           
           #################################
           #Start with results on top
           h2('Simulation Results'),
           plotOutput(outputId = "plot", height = "1000px"),
           # PLaceholder for results of type text
           htmlOutput(outputId = "text"),
           #Placeholder for any possible warning or error messages (this will be shown in red)
           htmlOutput(outputId = "warn"),
           
           tags$head(tags$style("#warn{color: red;
                                font-style: italic;
                                }"))

           ) #end main panel column with outcomes
  ), #end layout with side and main panel
  
  #################################
  #Instructions section at bottom as tabs
  h2('Instructions'),
  #use external function to generate all tabs with instruction content
  do.call(tabsetPanel,generate_instruction_tabs()),
  div(includeHTML("www/footer.html"), align="center", style="font-size:small") #footer
  
) #end fluidpage function, i.e. the UI part of the app

shinyApp(ui = ui, server = server)