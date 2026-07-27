library(shiny)

server <- shinyServer(function(input, output,session){
  
  vals <- reactiveValues()
  observe({
    vals$x                   <- input$tank_volume*1000 # convert to cells per milliliter
    vals$t                   <- input$target_cell_density # in cells per milliliter
    vals$q                   <- input$how_many_tanks
    vals$f                   <- input$flow_rate*1000 # convert to milliliters per minute
    vals$total_cells         <- vals$x*vals$t # ceoncetration targetted in cells per mL
    # vals$vol                 <- input$feed_conical
    vals$algae_mix_conc      <- (input$algae_stock) # total cell concentration of algae source in cells per mL
    vals$assumed_hourly_loss <- (vals$f*60)*vals$t  # volume in ml per hour (lost) * the cell concentration in c mL-1 = the total cells lost per hour due to flow rates
    vals$percent_loss_hourly <- (vals$assumed_hourly_loss/vals$total_cells)*100 
    vals$Liters_algae_initial <- ((vals$total_cells/vals$algae_mix_conc)/1000)
    vals$LPH_feed <- ((vals$percent_loss_hourly/100)*vals$Liters_algae_initial)
    vals$LPM_feed <- (vals$LPH_feed / 60)
    vals$Algaeheader <- vals$LPH_feed*24
  }) 
  
  output$signature <- renderText({
    paste("App created by Sam J. Gurr - last update 06/11/2026") 
    
  })
  
  output$contactinfo <- renderText({
    paste("Contact: samuel.gurr@oregonstate.edu") 
    
  })
  
  output$batchtotal <- renderText({
    paste("Start your headtank (assume no algae): total volume feed per tank (L) =", 
          vals$Liters_algae_initial)
  })
  
  output$hourly_flow_loss <- renderText({
    paste("Hourly loss from flow through (total cells) =",
          vals$assumed_hourly_loss)
  })
  
  output$replenish <- renderText({
    paste("Volume to add (L per hour): Algae source to headtank hour-1 =",
          ((vals$assumed_hourly_loss/vals$algae_mix_conc)/1000))
  })
  
  output$replenish <- renderText({
    paste("Volume to replenish header to target density (L per minute) from source to headtank",
          (((vals$assumed_hourly_loss/vals$algae_mix_conc)/1000)/60))
  })
  
  
})
