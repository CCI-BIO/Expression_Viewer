## ZERO Differential Expression statistics and plots
## 
## Created by the CCI Bioinformatics team (Nisitha Jayatilleke, Pooja Venkat and Chelsea Mayoh)
## Date: 15/07/2019
## Last updated: 12/03/2021

# Import relevant libraries
library(shiny)
library(shinythemes)
library(shinyjs)
library(DT)
library(Rtsne)
library(ggplot2)
library(plotly)
library(tidyr)
library(RColorBrewer)
library(knitr)

# Increase max file size
options(shiny.maxRequestSize = 500*1024^2)

# File directory
dirLoc <- paste(getwd(), "/", sep = "")

##knit the instruction files
knit("table_stats_help.Rmd", output = "table_stats_help.md")
knit("exp_plot_help.Rmd", output = "exp_plot_help.md")
knit("sig_plot_help.Rmd", output = "sig_plot_help.md")
knit("tsne_plot_help.Rmd", output = "tsne_plot_help.md")
knit("vio_plot_help.Rmd", output = "vio_plot_help.md")
knit("gene_cor_help.Rmd", output = "gene_cor_help.md")

# Define UI for application
ui <- fluidPage(
  # Set shiny theme
  theme = shinytheme("flatly"),
  # Initialise ShinyJS
  shinyjs::useShinyjs(),
  # Navbar initialisation
  navbarPage(
    id = "tabs", 
    title = "Expression Viewer",
    ##############################
    #     Instruction Manual      #
    ##############################
    tabPanel(
      #"Help",
      "Instruction Manual",
      #navbarPage(
      #  id = "tabs1",
      #  title = "Instruction Manual",
      #  theme = "bootsrap.css",
      tabsetPanel(
        type = "tabs",
        tabPanel(
          "Table Statistics",
          includeMarkdown("table_stats_help.md")
        ),
        tabPanel(
          "Expression Plot",
          includeMarkdown("exp_plot_help.md")
        ),
        tabPanel(
          "tSNE Plot",
          includeMarkdown("tsne_plot_help.md")
        ),
        tabPanel(
          "Signature Plot",
          includeMarkdown("sig_plot_help.md")
        ), 
        tabPanel(
          "Violin Plot",
          includeMarkdown("vio_plot_help.md")
        ),
        tabPanel(
          "Pairwise Gene Correlation",
          includeMarkdown("gene_cor_help.md")
        )
      )
     ),
    ################################
    # Table viewer -- Nisitha #
    ################################
    tabPanel(
      "Table Statistics",
      # Select mode for application
      fluidRow(
        column(
          12,
          radioButtons(
            inputId = "selectOffline",
            label = h4("Select mode:"),
            choices = list("Online" = "online", "Offline" = "offline"),
            selected = "offline"
          )
        )
      ),
      fluidRow(
        column(
          12,
          radioButtons(
            inputId = "selectFolder_tableView",
            label = h4("Select Folder"),
            choices = list("ExpressionAnalysis" = "ExpressionAnalysis", "totalRNA" = "totalRNA","AGRF_trial" = "AGRF_trial" )
          )
        )
      ),
      # Select sample to view data
      fluidRow(
        column(
          6,
          uiOutput(
            "sampleSelect"
          )
        ),
        column(
          6,
          uiOutput(
            "tableSelect"
          )
        )
      ),
      # Select patient metadata and TPM counts files
      fluidRow(
        column(
          6,
          uiOutput(
            "TPMcounts"
          )
        ),
        column(
          6,
          uiOutput(
            "patientMetadata"
          )
        )
      ),
      # Select extra histology TPMs
      fluidRow(
        column(
          6,
          uiOutput("categoryChoice")
        ),
        column(
          6,
          uiOutput("histologySelect")
        )
      ),
      # Select genes to view
      fluidRow(
        column(
          12,
          radioButtons(
            inputId = "selectGeneInput",
            label = h4("Gene filter:"),
            choices = list("All genes" = "all", "Specified genes" = "specific", "Gene list" = "list")
          )
        )
      ),
      # Break
      fluidRow(
        br()
      ),
      # Allow selection of genes based on method
      fluidRow(
        column(
          12,
          uiOutput("selectGenes")
        )
      ),
      # Print table preview
      fluidRow(
        mainPanel(
          DTOutput("tablePreview")
        )
      ),
      # Download table button
      fluidRow(
        column(
          12,
          downloadButton("tableDownload")
        )
      ),
      # Break
      fluidRow(
        br()
      )
    ),
    ############################
    # Expression Plot -- Pooja #
    ############################ 
    tabPanel(
      "Expression Plot",
      fluidRow(
        column(
          12,
          radioButtons(
            inputId = "Select_plotfile_dot", 
            label = h4("Select file mode:"),
            choices = list("Online" = "online_plot", "Offline" = "offline_plot"),
            selected = "offline_plot"
          )
        )
      ),
      fluidRow(
        column(
          12,
          radioButtons(
            inputId = "selectFolder",
            label = h4("Select Folder"),
            choices = list("ExpressionAnalysis" = "ExpressionAnalysis", "totalRNA" = "totalRNA","AGRF_trial" = "AGRF_trial" )
            
          )
        )
      ),
      fluidRow(
        column(
          6,
          uiOutput("dotTPM_file")
        ),
        column(
          6,
          uiOutput("dotPatient_file")
        )
      ),
      fluidRow(
        column(
          6,
          selectizeInput(
            inputId = "selectPatient_dot", 
            label = h4("Select Sample ID:"), 
            choices = NULL, 
            multiple = F
          )
        ),  
        column(
          6,
          selectizeInput(
            inputId = "selectgenes2_dot", 
            label = h4("Select gene to plot:"), 
            choices = NULL, 
            multiple = F
          )
        )
      ),fluidRow(
        tags$style(
          "#message_2 {font-size:20px;
            font-weight:bold;
            font-style:italic;
            color:Orange}"
        ),
        #textOutput("message_1"),
        #br(),
        textOutput("message_2"),
        br()
      ),
      fluidRow(
        column(
          12, 
          # plotlyOutput("plotarea_dot", height = "800px", width = "900px")
          splitLayout(cellWidths = c("50%","50%"),
                      plotlyOutput("plotarea_dot", height = "800px", width = "700px"),
                      plotlyOutput("plotarea_dot_cat", height = "800px", width = "700px"))
        )
      ),
      # Download plot button
      fluidRow(
        column(
          12,
          # downloadButton("ExpressionDownload_dot", label = "Download as .png")
          splitLayout(cellWidths = c("50%","50%"),
                      downloadButton("ExpressionDownload_dot", label = "Download as .png"),
                      downloadButton("ExpressionDownload_dot_cat", label = "Download as .png"))
        )
      )
    ),
    ########################
    # tSNE plot -- Nisitha #
    ########################
    tabPanel(
      "tSNE Plot",
      # Select mode for application
      fluidRow(
        column(
          12,
          radioButtons(
            inputId = "tSNEselectOffline",
            label = h4("Select mode:"),
            choices = list("Online" = "online", "Offline" = "offline"),
            selected = "offline"
          )
        )
      ),
      fluidRow(
        column(
          12,
          radioButtons(
            inputId = "selectFolder_tsne",
            label = h4("Select Folder"),
            choices = list("ExpressionAnalysis" = "ExpressionAnalysis", "totalRNA" = "totalRNA","AGRF_trial" = "AGRF_trial" )
          
          )
        )
      ),
      # Select upload of TPM counts, Patient diagnosis files
      fluidRow(
        column(
          4,
          uiOutput("tSNETPMCounts")
        ),
        column(
          4,
          uiOutput("tSNEPatientMetadata")
        ),
        column(
          4,
          uiOutput("tSNEColourTable")
        )
      ),
      # Select colouring methods 
      fluidRow(
        column(
          6,
          uiOutput("tSNEColourSelect")
        ),
        column(
          6,
          uiOutput("tSNECategoryColourSelect")
        )
      ),
      # Select sample for plotting 
      fluidRow(
        column(
          6,
          uiOutput("tSNEsampleSelect")
        ),
        column(
          6,
          uiOutput("tSNEperplexitySelect")
        )
      ),
      # Output tSNE plotly
      fluidRow(
        column(
          12,
          plotlyOutput("tSNEPlot", height = "800px", width = "1200px")
        )
      ),
      # Download tSNE plot button
      fluidRow(
        column(
          12,
          downloadButton("tSNEDownload", label = "Download as .png")
        )
      )
    ),
    #############################
    # Signature plot -- Nisitha #
    #############################
    tabPanel(
      "Signature Plot",
      # Select mode for application
      fluidRow(
        column(
          12,
          radioButtons(
            inputId = "SigPlotSelectOffline",
            label = h4("Select mode:"),
            choices = list("Online" = "online", "Offline" = "offline"),
            selected = "offline"
          )
        )
      ),
      fluidRow(
        column(
          12,
          radioButtons(
            inputId = "selectFolder_sigplot",
            label = h4("Select Folder"),
            choices = list("ExpressionAnalysis" = "ExpressionAnalysis", "totalRNA" = "totalRNA","AGRF_trial" = "AGRF_trial" )
          )
        )
      ),
      # Select upload of TPM counts, Patient diagnosis and gene signature list files
      fluidRow(
        column(
          4,
          uiOutput("SigPlotTPMCounts")
        ),
        column(
          4,
          uiOutput("SigPlotPatientMetadata")
        ),
        column(
          4,
          uiOutput("SigPlotSignatureGenes")
        )
      ),
      # Select sample and signature for plotting
      fluidRow(
        column(
          6,
          uiOutput("SigPlotSampleSelect")
        ),
        column(
          6,
          uiOutput("SigPlotSignatureFile")
        )
      ),
      # Output signature plotly
      fluidRow(
        column(
          12,
          plotlyOutput("SigPlot", height = "800px", width = "1200px")
        )
      ),
      # Download signature plot button
      fluidRow(
        column(
          12,
          downloadButton("SigPlotDownload", label = "Download as .png")
        )
      )
    ),
    #############################
    # Violin plot -- Nisitha    #
    #############################
    tabPanel(
      "Violin Plot",
      # Select mode for application
      fluidRow(
        column(
          12,
          radioButtons(
            inputId = "VioPlotSelectOffline",
            label = h4("Select mode:"),
            choices = list("Online" = "online", "Offline" = "offline"),
            selected = "offline"
           
          )
        )
      ),
      fluidRow(
        column(
          12,
          radioButtons(
            inputId = "selectFolder_vioplot",
            label = h4("Select Folder"),
            choices = list("ExpressionAnalysis" = "ExpressionAnalysis", "totalRNA" = "totalRNA","AGRF_trial" = "AGRF_trial" )
            
          )
        )
      ),
      # Select upload of TPM counts and Patient diagnosis files
      fluidRow(
        column(
          4,
          uiOutput("VioPlotTPMCounts")
        ),
        column(
          4,
          uiOutput("VioPlotPatientMetadata")
        ),
        column(
          4,
          uiOutput("VioPlotSelectTPMScale")
        )
      ),
      # Select gene for plotting
      fluidRow(
        column(
          4,
          selectizeInput(
            inputId = "VioPlotGeneSelect", 
            label = h4("Select gene to plot:"), 
            choices = NULL, 
            multiple = F
          )
        ),
        column(
          4,
          uiOutput("VioPlotCategorySelect")
        ),
        column(
          4,
          uiOutput("VioPlotSpecificCategorySelect")
        )
      ),
      # Output signature plotly
      fluidRow(
        column(
           12,
          plotlyOutput("VioPlot", height = "800px", width = "1200px")
        )
      ),
      # Download signature plot button
      fluidRow(
        column(
          12,
          downloadButton("VioPlotDownload", label = "Download as .png")
        )
      )
    ),
    ###############################
    # Gene correlation -- Nisitha #
    ###############################
    tabPanel(
      "Pairwise Gene Correlation Plot",
      # Select mode for application
      fluidRow(
        column(
          12,
          radioButtons(
            inputId = "GeneCorSelectOffline",
            label = h4("Select mode:"),
            choices = list("Online" = "online", "Offline" = "offline"),
            selected = "offline"
          )
        )
      ),
      fluidRow(
        column(
          12,
          radioButtons(
            inputId = "selectFolder_genecor",
            label = h4("Select Folder"),
            choices = list("ExpressionAnalysis" = "ExpressionAnalysis", "totalRNA" = "totalRNA","AGRF_trial" = "AGRF_trial" )
          )
        )
      ),
      # Select upload of TPM counts
      fluidRow(
        column(
          4,
          uiOutput("GeneCorTPMCounts")
        )
      ),
      # Select genes for correlation 
      fluidRow(
        column(
          4,
          selectizeInput(
            inputId = "GeneCorFirstGene", 
            label = h4("Select first gene:"), 
            choices = NULL, 
            multiple = F
          )
        ),
        column(
          4,
          selectizeInput(
            inputId = "GeneCorSecondGene", 
            label = h4("Select second gene:"), 
            choices = NULL, 
            multiple = F
          )
        ),
        column(
          4,
          uiOutput("GeneCorSelectMethod")
        )
      ),
      # Print correlation statistics
      fluidRow(
        column(
          12,
          tags$style(
            "#GeneCorValues {font-size:30px;
            font-weight:bold;}"
          ),
          textOutput("GeneCorValues")
        )
      ),
      # Output signature plotly
      fluidRow(
        column(
          12,
          plotlyOutput("GeneCorPlot", height = "800px", width = "1200px")
        )
      ),
      # Download signature plot button
      fluidRow(
        column(
          12,
          downloadButton("GeneCorPlotDownload", label = "Download as .png")
        )
      )
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  # Use shinyjs
  shinyjs::useShinyjs()
  
  # Disable buttons at start
  shinyjs::disable("SigPlotSelectOffline")
  shinyjs::disable("VioPlotSelectOffline")
  
  # Hide offline buttons
  shinyjs::hide("selectOffline")
  shinyjs::hide("Select_plotfile_dot")
  shinyjs::hide("tSNEselectOffline")
  shinyjs::hide("SigPlotSelectOffline")
  shinyjs::hide("VioPlotSelectOffline")
  shinyjs::hide("GeneCorSelectOffline")
  
  # Hide folder selection buttons
  shinyjs::hide("selectFolder_tableView")
  shinyjs::hide("selectFolder")
  shinyjs::hide("selectFolder_tsne")
  shinyjs::hide("selectFolder_sigplot")
  shinyjs::hide("selectFolder_vioplot")
  shinyjs::hide("selectFolder_genecor")

  # Import table view script
  source("scripts/tableView.R", local = T)
  
  # Import expression plot script
  #source("scripts/ExpressionPlot_shiny.R", local = T)
  source("scripts/ExpressionPlot_shiny_with_cat_1.R", local = T)
  
  # Import tSNE plot script
  source("scripts/tSNEPlot_shiny.R", local = T)
  
  # Import signautre script
  source("scripts/SignaturePlot_shiny.R", local = T)
  
  # Import violin plot script
  source("scripts/violinPlot_shiny.R", local = T)
  
  # Import gene correlation script
  source("scripts/geneCorrelation_shiny.R", local = T)
  
  # Stop application (required for RInno)
  if(!interactive()){
    session$onSessionEnded(function(){
      stopApp()
      q("no")
    })
  }
}

# Run the application 
shinyApp(ui = ui, server = server)

