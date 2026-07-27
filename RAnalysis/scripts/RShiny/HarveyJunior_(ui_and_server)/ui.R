library(shiny)

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