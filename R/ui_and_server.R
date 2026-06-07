#' Launch the ViSAGEjr R Shiny app
#'
#' @description
#' The`run_visagejr()` function launches the ViSAGEjr R Shiny app.
#' The app is designed to simulate and visualize multi-generation selection of breeding populations.
#' 
#' @returns A Shiny app object that launches the ViSAGEjr application.
#' @export
#'
run_visagejr <- function(){
  
  shiny::addResourcePath(
    prefix = "www",
    directoryPath = system.file("www", package = "ViSAGEjr")
  )
  
  #### Set some parameters
  # canvas.width.gbl = 1650
  # canvas.height.gbl =700
  # Illini.blue <- "#13294B"
  # Illini.orange <- "#FF5F05"
  # Royal.blue <- "#001489"
  
  ########################################################################################################################
  ######################------- User Interface of the app ---------- #####################################################
  ########################################################################################################################
  ui <- shiny::fluidPage(
    shiny::tags$head(
      shiny::tags$link(rel = "stylesheet", type = "text/css", href = "www/layout.css")
      ),
    
    ### Setting the theme of the app
    theme = bslib::bs_theme(bootswatch = "united"),
    
    # shiny::tags$head(
    #   shiny::tags$style(shiny::HTML("
    #     body, html {
    #       margin: 0;
    #       padding: 0;
    #       overflow: auto;
    #     }
    #     
    #     .scroll-col {
    #     height: 95vh;
    #     overflow-y: auto;
    #     }
    #   "))
    # ),
    
    shiny::tabsetPanel(
      #### Introduction panel ###################
      shiny::tabPanel("Introduction", shiny::includeMarkdown(
        system.file("www", "Introduction.md",  package = "ViSAGEjr"))
      ),# End of Introduction panel
      
      ######### Standard panel ####################======================= 
      shiny::tabPanel("Standard", 
                      shiny::fluidRow(
                        class = "vh-95",
                        
                        # LEFT COLUMN: Fixed layout
                        shiny::column(
                          width = 2,
                          shiny::div(class = "scroll-col", #class = "scroll-col",
                                     bslib::card(class = "height: 35vh; overflow-y: hidden;", bslib::card_header("Selection decisions"),
                                                 shiny::selectInput("choosetrait", label = "Select a trait", 
                                                                    choices = c("PlantHeight", "StemDiameter", "TasselLength")),
                                                 shiny::selectInput(inputId = "direction", label = "How do you want to select?",
                                                                    choices = c("Higher values", "Lower values")),
                                                 shiny::sliderInput(inputId = "intensity", "What percentage would you like to select?",
                                                                    min = 0, max = 100, step = 5, value = 10),
                                                 shiny::actionButton(inputId = "simulate", "Simulate", class = "btn btn-success")),
                                     bslib::card(class = "height: 25vh; overflow-y: auto;", bslib::card_header("Recycle a generation for new simulations"),
                                                 shiny::sliderInput(inputId = "genNumber", "Select the generation",
                                                                    min = 1, max = 20, step = 1, value = 4),
                                                 shiny::actionButton(inputId = "recycle", "Recycle"),
                                                 shinyWidgets::progressBar(id = "pb", value = 0, display_pct = T, title = "Ready to recycle")),
                                     bslib::card(class = "height: 20vh; overflow-y: auto;", bslib::card_header("Genetic gain metric"),
                                                 shiny::sliderInput(inputId = "quantile", "Choose a quartile for comparing generations",
                                                                    min = 0, max = 100, step = 25, value = 50),
                                                 shiny::actionButton(inputId = "metric", "Update metric")),
                                     bslib::card(class = "height: 6vh;", bslib::card_header("Reset the app"), 
                                                 shiny::actionButton(inputId = "reset", "Reset the app", class = "btn btn-warning"))
                          )
                        ), #End Left column
                        
                        # RIGHT COLUMN: Scrollable with nested grid
                        shiny::column(
                          width = 10,
                          shiny::div(class = "scroll-col",#class = "scroll-col",
                                     
                                     shiny::fluidRow(
                                       shiny::column(12,
                                                     bslib::card(height = 400,#class = "height: 30vh; overflow-y: auto;",
                                                                 bslib::card_header("Genetic gain plot"), full_screen = T,
                                                                 shiny::plotOutput(outputId = "dotplot"))
                                       )
                                     ),
                                     
                                     shiny::fluidRow(
                                       shiny::column(8,
                                                     bslib::card( height = 500, #class = "height: 40vh; overflow-y: hidden;", 
                                                                  bslib::card_header("Phenotypic changes"), full_screen = T,
                                                                  shinyjs::useShinyjs(),
                                                                  shiny::tags$head(shiny::tags$script(src = "www/maize.js")),
                                                                  shiny::tags$canvas(id = "myCanvas", width = 1650,
                                                                                     height = 700, style = "border:1px solid black;"))
                                       ),
                                       shiny::column(4,
                                                     bslib::card(height = 500,# class = "height: 30vh; overflow-y: hidden;", 
                                                                 bslib::card_header("Phenotypic distribution"), full_screen = T,
                                                                 shiny::fluidRow(shiny::column(6, 
                                                                                               shiny::selectInput(inputId = "selectGen", 
                                                                                                                  label = "Select a generation", 
                                                                                                                  choices = c(1:20))),
                                                                                 shiny::column(6, shiny::selectInput(inputId = "selectTrait", 
                                                                                                                     label = "Select a trait", 
                                                                                                                     choices = c("PlantHeight", "StemDiameter", "TasselLength")))),
                                                                 shiny::actionButton(inputId = "plotHist", "Plot histogram"),
                                                                 shiny::plotOutput(outputId = "histplot"))
                                       )
                                       # shiny::column(4,
                                       #               bslib::card(height = 500,# class = "height: 30vh; overflow-y: hidden;", 
                                       #                           bslib::card_header("Phenotypic distribution"), full_screen = T,
                                       #                           shiny::selectInput(inputId = "selectGen", 
                                       #                                              label = "Select a generation", choices = c(1:20)),
                                       #                           shiny::selectInput(inputId = "selectTrait", label = "Select a trait", 
                                       #                                              choices = unique(SP$traitNames)),
                                       #                           shiny::actionButton(inputId = "plotHist", "Plot histogram"),
                                       #                           shiny::plotOutput(outputId = "histplot"))
                                       # )
                                     ),
                                     
                                     bslib::card(bslib::card_header("Download outputs"),
                                                 shiny::fluidRow(class = "height: 10vh;", #Download buttons
                                                                 shiny::column(4, shiny::downloadButton("downloadData", "Download simulated phenotypes")),
                                                                 shiny::column(4, shiny::downloadButton("downloadGainPlot", "Download genetic gain plot")),
                                                                 # shiny::column(3, shiny::downloadButton("downloadPhenoPlot", "Download phenotypic changes plot")),
                                                                 shiny::column(4, shiny::downloadButton("downloadPhenoDistPlot", "Download phenotypic distribution plot"))
                                                 )#End of fluidrow download buttons
                                     )#End of Card Download outputs
                          ))#End of right column,
                      )#Standard fluidRow
      ),#End Standard tabPanel
      ######################-------------------  End of STANDARD Panel--------------------################################
      
      
      ############################################------- Beginning of Fun Panel ------------##########################################
      shiny::tabPanel("Fun", 
                      shiny::fluidRow(
                        class = "vh-95",
                        
                        ### LEFT COLUMN: Fixed layout
                        shiny::column(
                          width = 2,
                          shiny::div(class = "scroll-col",
                                     bslib::card(class = "height: 37vh; overflow-y: hidden;", bslib::card_header("Selection decisions"),
                                                 shiny::selectInput("crop", label = "Select a crop", choices = c("Maize" , "Avocado" , "Strawberry")),
                                                 shiny::uiOutput("choosetrait2"),
                                                 shiny::selectInput(inputId = "direction2", label = "How do you want to select?",
                                                                    choices = c("Higher values", "Lower values")),
                                                 shiny::sliderInput(inputId = "intensity2", "What percentage would you like to select?",
                                                                    min = 0, max = 100, step = 5, value = 10),
                                                 shiny::actionButton(inputId = "simulate2", "Simulate", class = "btn btn-success")),
                                     bslib::card(class = "height: 24vh;", bslib::card_header("Recycle a generation for new simulation"),
                                                 shiny::sliderInput(inputId = "genNumber2", "Select the generation",
                                                                    min = 1, max = 20, step = 1, value = 4),
                                                 shiny::actionButton(inputId = "recycle2", "Recycle"),
                                                 shinyWidgets::progressBar(id = "pb2", value = 0, display_pct = T, title = "Ready to recycle")),
                                     bslib::card(class = "height: 19vh;", bslib::card_header("Genetic gain metric"),
                                                 shiny::sliderInput(inputId = "quantile2", "Choose a quartile for comparing generations",
                                                                    min = 0, max = 100, step = 25, value = 50),
                                                 shiny::actionButton(inputId = "metric2", "Update metric")),
                                     bslib::card(class = "height: 6vh;", bslib::card_header("Reset the app"),
                                                 shiny::actionButton(inputId = "reset", "Reset the app", class = "btn btn-warning"))
                          )
                        ),
                        
                        # RIGHT COLUMN: Scrollable with nested grid
                        shiny::column(
                          width = 10,
                          shiny::div(class = "scroll-col",
                                     shiny::fluidRow(
                                       shiny::column(12,
                                                     bslib::card(height = 400,#class = "height: 40vh; overflow-y: hidden;", 
                                                                 bslib::card_header("Genetic gain plot"),
                                                                 shiny::plotOutput(outputId = "dotplot2"))
                                       )
                                     ), #End column gain plot
                                     
                                     shiny::fluidRow(
                                       shiny::column(8,
                                                     bslib::card(height = 500, #class = "height: 40vh; overflow-y: hidden;", 
                                                                 bslib::card_header("Phenotypic changes"),
                                                                 shinyjs::useShinyjs(),
                                                                 shiny::tags$head(shiny::tags$script(src = "www/fun.js")),
                                                                 shiny::tags$canvas(id = "myCanvas2", width = 1650,
                                                                                    height = 700, style = "border:1px solid black;"))
                                       ),
                                       shiny::column(4,
                                                     bslib::card(height = 500, # class = "height: 40vh; overflow-y: hidden;", 
                                                                 bslib::card_header("Phenotypic distribution"),
                                                                 shiny::fluidRow(shiny::column(6,
                                                                                               shiny::selectInput(inputId = "selectGen2", 
                                                                                                                  label = "Select a generation", 
                                                                                                                  choices = c(1:20))),
                                                                                 shiny::column(6, shiny::uiOutput("selectTrait2")
                                                                                 )),
                                                                 shiny::actionButton(inputId = "plotHist2", "Plot histogram"),
                                                                 shiny::plotOutput(outputId = "histplot2"))
                                       ) #End of column plot histogram
                                     ),#End fluidRow pheno changes + histogram
                                     
                                     bslib::card(bslib::card_header("Download outputs"),
                                                 shiny::fluidRow(class = "height: 10vh;", #Download buttons
                                                                 shiny::column(4, shiny::downloadButton("downloadData2", "Download simulated phenotypes")),
                                                                 shiny::column(4, shiny::downloadButton("downloadGainPlot2", "Download genetic gain plot")),
                                                                 # shiny::column(3, shiny::downloadButton("downloadPhenoPlot2", "Download phenotypic changes plot")),
                                                                 shiny::column(4, shiny::downloadButton("downloadPhenoDistPlot2", "Download phenotypic distribution plot"))
                                                 ))#End of card download buttons
                                     
                          )# End of Right column div
                        )# End of Right column of Fun
                        
                      ))# End of FUN tabpanel
    )#End of TabSetPanel
    
  )#End of the overall fluidPage.
  
  ####################################### End of Fun Panel ######################################################
  ######################------- Server function of the app ---------- ####################################################
  ########################################################################################################################
  server <- function(input, output, session) {
    ## Run the simulation function based on user-defined parameters and the click of the simulate button
    maize_lst <- sim_maize_pop()
    pop.maize <- shiny::reactiveVal(maize_lst$pop.maize)
    SP <- shiny::reactiveVal(maize_lst$SP)
    pop.maize.fun <- shiny::reactiveVal(maize_lst$pop.maize.fun)
    
    simulation.results <- shiny::eventReactive(input$simulate, {
      shiny::withProgress(message = "Simulation in progress ...", value = 0, {
        multi.gener.sim(pop = pop.maize(), trait = input$choosetrait, direction = input$direction, 
                        intensity = input$intensity, crop = "Maize", SP.crop = SP())
      })
    })## Output a list of 4 elements, including GVs and phenotype
    
    ##### Download simulation results
    output$downloadStandard <- shiny::downloadHandler(
      filename = function(){
        paste0("simulation_data_standard_maize_", Sys.Date(), ".csv")
      },
      content = function(file){
        shiny::req(simulation.results())
        utils::write.csv(simulation.results()[["pheno"]], file, row.names = FALSE)
      }
    ) # For the Standard panel
    
    avocado_sim <- sim_avocado_pop()
    pop.avocado <- shiny::reactiveVal(avocado_sim$pop.avocado)
    SP.avocado <- shiny::reactiveVal(avocado_sim$SP.avocado)
    
    strawb_sim <- sim_strawb_pop()
    pop.strawberry <- shiny::reactiveVal(strawb_sim$pop.strawberry)
    SP.strawberry <- shiny::reactiveVal(strawb_sim$SP.strawberry)
    ## List of choices for crops. For the Fun panel, user first selects the crop of choice
    output$choosetrait2 <- shiny::renderUI({
      shiny::req(input$crop)  # Ensure input$crop is available before execution
      
      trait_choices <- switch(input$crop,
                              # "Maize" = c("PlantHeight", "StemDiameter", "TasselLength"),
                              "Maize" = unique(SP()$traitNames),
                              "Avocado" = unique(SP.avocado()$traitNames),
                              "Strawberry" = unique(SP.strawberry()$traitNames),
                              character(0))  # Default empty vector if no match
      
      shiny::selectInput("choosetrait2", label = "Select a trait", choices = trait_choices)
    })
    
    
    
    ## Now the Fun panel can run the simulation function for the selected crop
    simulation.results2 <- shiny::eventReactive(input$simulate2, {
      shiny::req(input$crop, input$choosetrait2, input$direction2, input$intensity2)  # Ensure inputs exist
      shiny::withProgress(message = "Simulation in progress ...", value = 0, {
        pop_data <- switch(input$crop,
                           "Maize" = pop.maize.fun(),
                           "Avocado" = pop.avocado(),
                           "Strawberry" = pop.strawberry(),
                           NULL)
        SP.crop <- switch(input$crop,
                          "Maize" = SP(),
                          "Avocado" = SP.avocado(),
                          "Strawberry" = SP.strawberry(),
                          SP)
        
        shiny::req(pop_data)  # Ensure population data exists
        multi.gener.sim(pop = pop_data, trait = input$choosetrait2,  # Use choosetrait2 instead of dynamic_input
                        direction = input$direction2, intensity = input$intensity2, 
                        crop = input$crop, SP.crop = SP.crop)
      })
    })## Output a list of 4 elements, including GVs and phenotype
    
    shiny::observeEvent(input$simulate, {
      shinyWidgets::updateProgressBar(session, id = "pb", value = 0, title = "Ready to recycle")
    })
    
    shiny::observeEvent(input$simulate2, {
      shinyWidgets::updateProgressBar(session, id = "pb2", value = 0, title = "Ready to recycle")
    }) # For the fun panel
    
    ###################################################################################################
    ## Plot the phenotypic distribution as a histogram
    # For the standard panel--------------------------------------------------------------------
    histogram <- shiny::eventReactive(input$plotHist, {
      shiny::req(input$selectGen, input$selectTrait, simulation.results())  # Ensure input$selectGen is available before execution
      ggplot2::ggplot( data = dplyr::filter(simulation.results()[["pheno"]], Generation == input$selectGen),
                       mapping = ggplot2::aes(x = .data[[input$selectTrait]])) +
        ggplot2::geom_histogram(color = "white", fill = "steelblue", bins = 10) +
        ggplot2::labs(x = base::paste0(input$selectTrait, " (cm)"), y = "Count",
                      title = base::paste0("Histogram for ",input$selectTrait," at generation ",input$selectGen)) +
        boris_theme() +
        ggplot2::theme(panel.grid = ggplot2::element_line(), title = ggplot2::element_text(size = 14))
    }) # For the Standard panel
    
    output$histplot <- shiny::renderPlot({
      shiny::req(histogram())  # Ensure input$selectGen is available before execution
      print(histogram())
    }) # For the Standard panel
    
    # For the Fun panel -----------------------------------------------------------------------
    ## List of choices for traits for the histogram
    output$selectTrait2 <- shiny::renderUI({
      shiny::req(input$crop, simulation.results2())  # Ensure input$crop is available before execution
      trait_choices <- switch(input$crop,
                              "Maize" = c("PlantHeight", "StemDiameter", "TasselLength"),
                              "Avocado" = unique(SP.avocado()$traitNames),
                              "Strawberry" = unique(SP.strawberry()$traitNames),
                              character(0))  # Default empty vector if no match
      
      shiny::selectInput("selectTrait3", label = "Select a trait", choices = trait_choices)
    })
    
    histogram2 <- shiny::eventReactive(input$plotHist2, {
      shiny::req(input$selectGen2, input$selectTrait3, simulation.results2())
      ggplot2::ggplot(data = dplyr::filter(simulation.results2()[["pheno"]], Generation == input$selectGen2),
                      mapping = ggplot2::aes(x = .data[[input$selectTrait3]])) +
        ggplot2::geom_histogram(color = "white", fill = "steelblue", bins = 10) +
        ggplot2::labs(x = base::paste0(input$selectTrait3, " (cm)"),
                      y = "Count", title = base::paste0("Histogram for ", input$selectTrait3,
                                                        " at generation ", input$selectGen2)) +
        boris_theme() +
        ggplot2::theme(panel.grid = ggplot2::element_line(), title = ggplot2::element_text(size = 14))
    }) # For the Fun panel
    
    output$histplot2 <- shiny::renderPlot({
      shiny::req(histogram2()) 
      print(histogram2())
    }) # For the Fun panel
    
    ####################################################################################################
    # Create a summarized table using user-defined percentile
    summary.sim.results <- shiny::eventReactive(c(simulation.results(), input$metric), {
      summary.simulation(data = simulation.results()[["pheno"]], 
                         quartile = input$quantile, pivot = T)
    })
    summary.sim.results2 <- shiny::eventReactive(c(simulation.results2(), input$metric2),{
      summary.simulation(data = simulation.results2()[["pheno"]], 
                         quartile = input$quantile2, pivot = T)
    })
    
    # #################################################################################################################
    ## ###### (Top panel: Create a multi-generation dot and line plots showing genetic progress #####################
    dotplot_temp <- shiny::eventReactive(c(simulation.results(), input$metric), {
      sum_sim_res <- summary.sim.results()
      ggpubr::ggarrange(
        ggplot2::ggplot(data = dplyr::filter(sum_sim_res, variate == "PlantHeight"), ggplot2::aes(x = Generation, y = values)) +
          ggplot2::geom_line(linewidth = 1, color = "#001489") + ggplot2::geom_point(size =4, color = "#001489") +
          ggplot2::coord_cartesian(ylim = c(-10, 300), xlim = c(0,20)) +
          boris_theme() + ggplot2::labs(y = "Plant height (cm)", x = "Generation")+
          ggplot2::annotate(geom ="segment",x = 3, y = -8, xend = 17, yend = -8, linewidth = 2, color = "black", arrow = grid::arrow())+
          ggplot2::annotate(geom = "text", x= 10, y = 5, label = "Time", size = 8, color = "black", fontface = "bold")+
          ggplot2::annotate(geom = "text", x = 2, y = 15, label = "Short", size =8, color = "#001489", fontface = "bold")+
          ggplot2::annotate(geom = "text", x = 2, y = 295, label = "Tall", size =9, color = "#001489", fontface = "bold"),
        
        ggplot2::ggplot(data = dplyr::filter(sum_sim_res, variate == "StemDiameter"), ggplot2::aes(x = Generation, y = values)) +
          ggplot2::geom_line(linewidth = 1, color = "#FF5F05") + ggplot2::geom_point(size =4, color = "#FF5F05") +
          ggplot2::coord_cartesian(ylim = c(0, 60), xlim = c(0,20)) +
          boris_theme() + ggplot2::labs(y = "Stem diameter (mm)", x = "Generation") +
          ggplot2::annotate(geom = "text", x = 2, y = 1, label = "Thin", size =8, color = "#FF5F05", fontface = "bold")+
          ggplot2::annotate(geom = "text", x = 2, y = 58, label = "Thick", size =8, color = "#FF5F05", fontface = "bold"),
        
        ggplot2::ggplot(data = dplyr::filter(sum_sim_res, variate == "TasselLength"), ggplot2::aes(x = Generation, y = values)) +
          ggplot2::geom_line(linewidth = 1) + ggplot2::geom_point(size = 4) +
          ggplot2::coord_cartesian(ylim = c(0, 30), xlim = c(0,20)) +
          boris_theme() + ggplot2::labs(y = "Tassel length (cm)", x = "Generation")+
          ggplot2::annotate(geom = "text", x = 2, y = 1, label = "Short", size =8, color = "black", fontface = "bold") +
          ggplot2::annotate(geom = "text", x = 2, y = 29, label = "Long", size =9, color = "black", fontface = "bold")
        
        , ncol = 3, nrow = 1)
    })
    
    output$dotplot <- shiny::renderPlot({
      shiny::req(dotplot_temp())  
      print(dotplot_temp())
    }) # For the Standard tab
    
    dotplot_temp2 <- shiny::eventReactive(c(summary.sim.results2(), input$metric2),{
      summary.sim <- summary.sim.results2()
      trait_choices <- switch(input$crop,
                              "Avocado" = unique(SP.avocado()$traitNames),
                              "Maize" = unique(SP()$traitNames),
                              "Strawberry" = unique(SP.strawberry()$traitNames),
                              character(0))
      annot <- switch(input$crop,
                      "Avocado" = c("Narrow", "Wide", "Short", "Tall", "Small", "Big"),
                      "Maize" = c("Short", "Tall", "Thin", "Thick", "Short", "Long"),
                      "Strawberry" = c("Short", "Tall", "Thin", "Thick", "Small", "Big"),
                      character(0))
      ggpubr::ggarrange(
        draw.genetic.gain.plot(dt = summary.sim, trait = trait_choices[1], col = "#001489",
                               annotate.bottom = annot[1], annotate.top = annot[2], draw.arrow = T),
        draw.genetic.gain.plot(summary.sim, trait = trait_choices[2], col = "black",
                               annotate.bottom = annot[3], annotate.top = annot[4], draw.arrow = F),
        draw.genetic.gain.plot(summary.sim, trait = trait_choices[3], col = "#FF5F05",
                               annotate.bottom = annot[5], annotate.top = annot[6], draw.arrow = F),
        ncol = 3, nrow = 1)
    })
    output$dotplot2 <- shiny::renderPlot({
      shiny::req(dotplot_temp2())
      print(dotplot_temp2())
    }) # For the fun tab
    
    
    ############### Integration of JavaScript code ###########################################################
    ### 1. Prepare and format simulation data for JavaScript
    plot_values <- shiny::eventReactive(c(simulation.results(), input$metric),{
      dt <- summary.simulation(data = simulation.results()[["pheno"]], 
                               quartile = input$quantile, pivot = F)
      dt[seq(1,21,5),]
    })
    
    
    plot_values2 <- shiny::eventReactive(c(simulation.results2(), input$metric2), {
      dt2 <- summary.simulation(data = simulation.results2()[["pheno"]], 
                                quartile = input$quantile2, pivot = F)
      dt2[seq(1,21,5),]
    })#For fun Panel
    
    ### 2. Input the data into the javascript file
    shiny::observeEvent(plot_values(), {
      plt_values <- plot_values()
      js_code <- sprintf("
      const canvas = document.getElementById('myCanvas');
      const ctx = canvas.getContext('2d');
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      drawBackground(ctx, canvas.width, canvas.height);
      drawMultipleMaizePlants(ctx, 50 + canvas.width/5, canvas.height, [%s], [%s], [%s])
      ", paste(2.5*plt_values[[2]], collapse = ","), paste(3*plt_values[[4]], collapse = ","),
                         paste(.4*plt_values[[3]], collapse = ","))
      # drawMultipleMaizePlants(ctx, x, y, heightArray, tasselLengthArray, StemDiameterArray)
      shinyjs::runjs(js_code)
    }) # For the Standard panel
    
    
    ### Use if else statement to draw the three alternative crops from the fun.js JavaScript file
    shiny::observeEvent(plot_values2(), {
      plt_values2 <- plot_values2()
      if(input$crop == "Maize"){
        js_code2 <- sprintf("
      const canvas2 = document.getElementById('myCanvas2');
      const ctx2 = canvas2.getContext('2d');
      ctx2.clearRect(0, 0, canvas2.width, canvas2.height);
      drawBackground(ctx2, canvas2.width, canvas2.height);
      drawThreshold(ctx=ctx2, xthresh=canvas2.width, ythresh=canvas2.height, margin = 100);
      drawMultipleFunCorn(ctx2, 50 + canvas2.width/5, canvas2.height, [%s], [%s], [%s])
      ", paste(2*plt_values2[[2]], collapse = ","), paste(1.5*plt_values2[[4]], collapse = ","),
                            paste(0.4*plt_values2[[3]], collapse = ","))
        # drawMultipleFunCorn(ctx, x, y, heightArray, tasselLengthArray, StemDiameterArray)
      }else if (input$crop == "Avocado") {
        js_code2 <- sprintf("
      const canvas2 = document.getElementById('myCanvas2');
      const ctx2 = canvas2.getContext('2d');
      ctx2.clearRect(0, 0, canvas2.width, canvas2.height);
      drawBackground(ctx2, canvas2.width, canvas2.height);
      drawSun(ctx = ctx2, xsun = canvas2.width, ysun =canvas2.height);
      drawMultipleAvocados(ctx2, 50 + canvas2.width/5, canvas2.height, [%s], [%s], [%s])
      ", paste(18*plt_values2[[3]], collapse = ","), paste(10*plt_values2[[2]], collapse = ","),
                            paste(5*plt_values2[[4]], collapse = ","))
        # drawMultipleAvocados(ctx, x, y, heightArray, widthArray, pitArray)
        
      } else if(input$crop == "Strawberry"){
        js_code2 <- sprintf("
      const canvas2 = document.getElementById('myCanvas2');
      const ctx2 = canvas2.getContext('2d');
      ctx2.clearRect(0, 0, canvas2.width, canvas2.height);
      drawBackground(ctx2, canvas2.width, canvas2.height);
      drawMultipleStrawberries(ctx2, 50 + canvas2.width/5, canvas2.height, [%s], [%s], [%s])
      ", paste(25*plt_values2[[2]], collapse = ","), paste(12*plt_values2[[3]], collapse = ","),
                            paste(2*plt_values2[[4]], collapse = ","))
        # drawMultipleStrawberries(ctx, x, y, heightArray, widthArray, seedSizeArray)
      }
      shinyjs::runjs(js_code2)
    }) # For the Fun panel
    
    ##########################---------- DOWNLOAD Buttons--------##################################
    ####------ Simulation data
    output$downloadData <- shiny::downloadHandler(
      filename = function(){
        paste0("Simulation_Data_Standard_maize_", Sys.Date(), ".csv")
      },
      content = function(file){
        shiny::req(simulation.results())  # Ensure simulation.results() is available before execution
        utils::write.csv(simulation.results()[["pheno"]], file, row.names = FALSE)
      }
    ) # For the Standard panel
    
    output$downloadData2 <- shiny::downloadHandler(
      filename = function(){
        paste0("Simulation_Data_Fun_", input$crop,"_", Sys.Date(), ".csv")
      },
      content = function(file){
        shiny::req(simulation.results2())  # Ensure simulation.results2() is available before execution
        utils::write.csv(simulation.results2()[["pheno"]], file, row.names = FALSE)
      }
    ) # For the fun panel
    
    ####------ Genetic gain
    output$downloadGainPlot <- shiny::downloadHandler(
      filename = function() {
        paste0("Genetic_Gain_Plot_Standard_", Sys.Date(), ".jpeg")
      },
      content = function(file) {
        shiny::req(dotplot_temp())
        ggplot2::ggsave(file, plot = dotplot_temp(), device = "jpeg", width = 12, height = 4, dpi = 300)
      }
    ) # For the Standard panel
    
    output$downloadGainPlot2 <- shiny::downloadHandler(
      filename = function() {
        paste0("Genetic_Gain_Plot_Fun_", input$crop, "_", Sys.Date(), ".jpeg")
      },
      content = function(file) {
        shiny::req(dotplot_temp2())
        ggplot2::ggsave(file, plot = dotplot_temp2(), device = "jpeg", width = 12, height = 4, dpi = 300)
      }
    ) # For the Fun panel
    
    ####------ Pheno Distribution
    output$downloadPhenoDistPlot <- shiny::downloadHandler(
      filename = function(){
        paste0("Histogram_Standard_", input$selectTrait, "_Generation_", input$selectGen, "_", Sys.Date(), ".jpeg")
      },
      content = function(file){
        shiny::req(histogram())
        ggplot2::ggsave(file, plot = histogram(), device = "jpeg", width = 6, height = 4, dpi = 300)
      }
    )# For the Standard panel
    
    output$downloadPhenoDistPlot2 <- shiny::downloadHandler(
      filename = function(){
        paste0("Histogram_Fun_", input$selectTrait3,"_Generation_", input$selectGen2, "_", Sys.Date(), ".jpeg")
      },
      content = function(file){
        shiny::req(histogram2())
        ggplot2::ggsave(file, plot = histogram(), device = "jpeg", width = 6, height = 4, dpi = 300)
      }
    )# For the Fun panel
    
    ####------ Pheno changes
    
    
    ##########################---------- RECYCLE GENERATION---------##################################
    ## Recycle the a user-defined generation for a new simulation cycle #################
    shiny::observeEvent(input$recycle, {
      shiny::req(simulation.results(), input$genNumber)
      pop.maize(simulation.results()[["popList"]][[input$genNumber]])
    }) # For the Standard panel
    
    
    shiny::observeEvent(input$recycle2, {
      shiny::req(simulation.results2(), input$genNumber2)
      sim_res2 <- simulation.results2()
      if(input$crop == "Maize"){
        pop.maize.fun(sim_res2[["popList"]][[input$genNumber2]])
      }else if(input$crop == "Avocado"){
        pop.avocado(sim_res2[["popList"]][[input$genNumber2]])
      }else if(input$crop == "Strawberry"){
        pop.strawberry(sim_res2[["popList"]][[input$genNumber2]])
      }
    }) # For the Fun panel
    
    shiny::observeEvent(input$recycle,{
      shinyWidgets::updateProgressBar(session = session, id = "pb", value = 100, title ="Reclycling done!")
    })
    shiny::observeEvent(input$recycle2,{
      shinyWidgets::updateProgressBar(session = session, id = "pb2", value = 100, title ="Reclycling done!")
    })
    ##########################---------- RESET APP---------##################################
    shiny::observeEvent(input$reset, {
      rm(list = ls())
      source("R/Load_shiny_simulation_parameters.R")
      session$reload()
    })
    
  }
  
  ########################################################################################################################
  ######################### ---------- The End! Let us run the app! --------- ############################################
  # Run the application
  shiny::shinyApp(ui = ui, server = server)
}
