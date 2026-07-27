rm(list = ls())
library(shiny)
# rsconnect::setAccountInfo(name='sam-geoduck',
rsconnect::setAccountInfo(name='sam-geoduck',
                          token='340A1FE56E654C48A346EDD10D0CC45F',
                          secret='hmitiSg16pfLx0ckLCu/1+/GByjPw/sdhcjzw4N/')
rsconnect::deployApp('C:/Users/gurrs/Documents/6_Github_repositories/GurrLab/Predictive_phenomics/RAnalysis/scripts/RShiny/HarveyJunior_(ui_and_server)')


ui <- shinyUI(fluidPage(
  mainPanel(
    numericInput("tank_volume", "tank_volume (L) from what you intend to feed", 100 ,min = 0, max = 5000),
    numericInput("how_many_tanks", "how_many_tanks of the same volume are you feeding?", 1,min = 1, max = 10),
    numericInput("flow_rate", "flow_rate of seawater to each tank (LPM)", 8,min = 0.00, max = 20.00),
    numericInput("target_cell_density", "target_cell_density (cells per mL)", 40000,min = 0, max = 1000000),
    # numericInput("feed_conical", "target mL per hour continuous feed", 1000 ,min = 0, max = 1000),
    numericInput("algae_stock", "Algae stock concentration from Harvey Sr. in cells mL-1 (pav, iso, tet, nano, etc.)", 5000000,min = 0, max = 10000000),
    textOutput("signature"),
    textOutput("contactinfo"),
    textOutput("batchtotal"),
    textOutput("batch_algae1"),
    textOutput("batch_algae2"),
    textOutput("batch_algae3"),
    textOutput("hourly_flow_loss"),
    textOutput("replenish"),
    textOutput("total_continuous"),
    textOutput("cont_algae1"),
    textOutput("cont_algae2"),
    textOutput("cont_algae3"),
    textOutput("dilution"))
))

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


shinyApp(ui = ui, server = server)
