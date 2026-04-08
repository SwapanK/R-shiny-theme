# App3 - GlassDash Dark
# Sci-Fi Inspired Theme with Rounded Corner Toast Notifications
# Features: 1 DT Table, 1 ggplot (converted to plotly), 1 plotly chart

library(shiny)
library(bslib)
library(ggplot2)
library(dplyr)
library(plotly)
library(shinytoastr)
library(DT)

# ================================================================
# SCI-FI GLASS THEME CSS - Inspired by Dreamlit Cyber Style
# ================================================================
sci_fi_glass_theme <- "
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Share+Tech+Mono&display=swap');

* {
  font-family: 'Inter', 'Share Tech Mono', sans-serif;
}

body {
  background: radial-gradient(ellipse at 20% 30%, #0a0a2a, #050510);
  min-height: 100vh;
  background-attachment: fixed;
  position: relative;
}

body::before {
  content: '';
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-image: 
    linear-gradient(rgba(0, 255, 255, 0.03) 1px, transparent 1px),
    linear-gradient(90deg, rgba(0, 255, 255, 0.03) 1px, transparent 1px);
  background-size: 40px 40px;
  pointer-events: none;
  z-index: 0;
}

/* ===== GLASS NAVBAR - CYBER STYLE ===== */
.navbar {
  background: rgba(10, 15, 35, 0.85) !important;
  backdrop-filter: blur(20px) saturate(180%);
  border-bottom: 1px solid rgba(0, 255, 255, 0.3) !important;
  box-shadow: 0 0 30px rgba(0, 255, 255, 0.15);
  padding: 0.8rem 2rem !important;
}

.navbar-brand {
  font-weight: 800 !important;
  font-size: 1.6rem !important;
  background: linear-gradient(135deg, #00ffff, #ff00ff, #00ffaa);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  text-shadow: 0 0 20px rgba(0, 255, 255, 0.5);
  letter-spacing: 1px;
}

.navbar-nav > li > a {
  color: rgba(200, 220, 255, 0.85) !important;
  font-weight: 600 !important;
  transition: all 0.3s ease !important;
  letter-spacing: 0.5px;
}

.navbar-nav > li.active > a {
  color: #00ffff !important;
  text-shadow: 0 0 10px rgba(0, 255, 255, 0.7);
  background: transparent !important;
}

.navbar-nav > li.active > a::after {
  content: '';
  position: absolute;
  bottom: -5px;
  left: 0;
  width: 100%;
  height: 2px;
  background: linear-gradient(90deg, #00ffff, #ff00ff);
  border-radius: 2px;
  box-shadow: 0 0 10px rgba(0, 255, 255, 0.7);
}

/* ===== GLASS CARDS - CYBER STYLE ===== */
.glass-card {
  background: rgba(15, 20, 45, 0.6) !important;
  backdrop-filter: blur(15px) saturate(180%);
  border: 1px solid rgba(0, 255, 255, 0.25) !important;
  border-radius: 20px !important;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3), 0 0 20px rgba(0, 255, 255, 0.1);
  padding: 25px !important;
  margin-bottom: 20px;
  transition: all 0.3s ease;
  color: #ffffff !important;
  position: relative;
  overflow: hidden;
}

.glass-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(0, 255, 255, 0.08), transparent);
  transition: left 0.5s ease;
}

.glass-card:hover::before {
  left: 100%;
}

.glass-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 15px 45px rgba(0, 0, 0, 0.4), 0 0 30px rgba(0, 255, 255, 0.2);
}

/* ===== STAT CARDS - SCI-FI STYLE ===== */
.stat-card {
  background: rgba(10, 15, 35, 0.7);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(0, 255, 255, 0.35);
  border-radius: 16px;
  padding: 20px;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.stat-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 3px;
  background: linear-gradient(90deg, #00ffff, #ff00ff, #00ffaa);
}

.stat-card:hover {
  transform: translateY(-3px);
  border-color: rgba(0, 255, 255, 0.6);
  box-shadow: 0 0 25px rgba(0, 255, 255, 0.2);
}

.stat-value {
  font-size: 2.5rem;
  font-weight: 800;
  color: #ffffff;
  margin-bottom: 5px;
  font-family: 'Share Tech Mono', monospace;
  text-shadow: 0 0 15px rgba(0, 255, 255, 0.5);
}

.stat-label {
  color: rgba(0, 255, 255, 0.7);
  font-size: 0.85rem;
  text-transform: uppercase;
  letter-spacing: 2px;
  font-weight: 600;
}

.stat-icon {
  position: absolute;
  right: 20px;
  top: 50%;
  transform: translateY(-50%);
  font-size: 3rem;
  opacity: 0.15;
  color: #00ffff;
}

/* ===== CYBER BUTTONS ===== */
.btn-glass {
  background: linear-gradient(135deg, rgba(0, 255, 255, 0.15), rgba(255, 0, 255, 0.15));
  border: 1px solid rgba(0, 255, 255, 0.4);
  color: #ffffff;
  padding: 10px 25px;
  border-radius: 50px;
  font-weight: 600;
  letter-spacing: 0.5px;
  backdrop-filter: blur(10px);
  transition: all 0.3s ease;
}

.btn-glass:hover {
  background: linear-gradient(135deg, rgba(0, 255, 255, 0.3), rgba(255, 0, 255, 0.3));
  border-color: #00ffff;
  box-shadow: 0 0 20px rgba(0, 255, 255, 0.4);
  transform: translateY(-2px);
  color: #ffffff;
}

/* ===== FORM CONTROLS ===== */
.form-control, .selectize-input {
  background: rgba(10, 15, 35, 0.7) !important;
  border: 1px solid rgba(0, 255, 255, 0.3) !important;
  border-radius: 12px !important;
  color: #ffffff !important;
  transition: all 0.3s ease;
}

.form-control:focus {
  border-color: #00ffff !important;
  box-shadow: 0 0 0 3px rgba(0, 255, 255, 0.15) !important;
  outline: none;
}

/* ===== TYPOGRAPHY ===== */
h1, h2, h3, h4, h5, h6 {
  color: #ffffff !important;
  font-weight: 700 !important;
}

.gradient-text {
  background: linear-gradient(135deg, #00ffff, #ff00ff, #00ffaa);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  font-weight: 800;
  text-shadow: 0 0 30px rgba(0, 255, 255, 0.3);
}

/* ===== PROGRESS BAR ===== */
.progress {
  background: rgba(0, 255, 255, 0.1) !important;
  border-radius: 10px !important;
  height: 8px !important;
  overflow: hidden;
}

.progress-bar {
  background: linear-gradient(90deg, #00ffff, #ff00ff) !important;
  border-radius: 10px !important;
  box-shadow: 0 0 10px rgba(0, 255, 255, 0.5);
}

/* ===== DT TABLE - CYBER STYLE ===== */
.dataTables_wrapper {
  color: #ffffff !important;
}

.dataTables_info, .dataTables_paginate {
  color: rgba(0, 255, 255, 0.7) !important;
}

.paginate_button {
  color: #ffffff !important;
  background: rgba(0, 255, 255, 0.1) !important;
  border-radius: 8px !important;
  margin: 0 2px !important;
}

.paginate_button.current {
  background: linear-gradient(135deg, #00ffff, #ff00ff) !important;
  color: #0a0a2a !important;
  font-weight: bold !important;
}

/* ===== CUSTOM SCROLLBAR ===== */
::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

::-webkit-scrollbar-track {
  background: rgba(10, 15, 35, 0.5);
  border-radius: 10px;
}

::-webkit-scrollbar-thumb {
  background: linear-gradient(135deg, #00ffff, #ff00ff);
  border-radius: 10px;
}

::-webkit-scrollbar-thumb:hover {
  background: linear-gradient(135deg, #ff00ff, #00ffff);
}

/* ===== ACTIVITY ITEMS ===== */
.activity-item {
  display: flex;
  align-items: center;
  padding: 12px;
  border-bottom: 1px solid rgba(0, 255, 255, 0.1);
  transition: all 0.3s ease;
}

.activity-item:hover {
  background: rgba(0, 255, 255, 0.05);
  transform: translateX(5px);
}

.activity-icon {
  width: 40px;
  height: 40px;
  background: rgba(0, 255, 255, 0.1);
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 15px;
  border: 1px solid rgba(0, 255, 255, 0.3);
}

.activity-title {
  font-weight: 600;
  color: #ffffff;
}

.activity-time {
  color: rgba(0, 255, 255, 0.5);
  font-size: 0.85rem;
}
"

# ================================================================
# UI
# ================================================================
ui <- fluidPage(
  useToastr(),
  tags$head(
    tags$style(HTML(sci_fi_glass_theme)),
    tags$link(rel = "stylesheet", href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css")
  ),
  
  navbarPage(
    title = div(icon("cube"), "NOVA DASH", style = "display: flex; align-items: center; gap: 10px;"),
    theme = bs_theme(version = 5),
    
    # ===== DASHBOARD TAB =====
    tabPanel(
      title = "Dashboard",
      icon = icon("gauge-high"),
      
      div(class = "container-fluid", style = "padding: 30px;",
          
          # Header
          div(class = "row mb-4",
              div(class = "col-12",
                  h1(class = "gradient-text", icon("chart-line"), " Quantum Analytics"),
                  p(style = "color: rgba(0, 255, 255, 0.6); font-size: 1.1rem; letter-spacing: 1px;", 
                    "Real-time market intelligence | Neural metrics dashboard")
              )
          ),
          
          # Stats Cards
          div(class = "row mb-4",
              div(class = "col-md-3",
                  div(class = "stat-card",
                      div(class = "stat-icon", icon("chart-line")),
                      div(class = "stat-value", textOutput("revenue")),
                      div(class = "stat-label", "Total Value"),
                      div(style = "margin-top: 10px;", 
                          span(icon("trend-up"), style = "color: #00ffaa;", " +12.5%"))
                  )
              ),
              div(class = "col-md-3",
                  div(class = "stat-card",
                      div(class = "stat-icon", icon("users")),
                      div(class = "stat-value", textOutput("users")),
                      div(class = "stat-label", "Active Nodes"),
                      div(style = "margin-top: 10px;", 
                          span(icon("trend-up"), style = "color: #00ffaa;", " +8.1%"))
                  )
              ),
              div(class = "col-md-3",
                  div(class = "stat-card",
                      div(class = "stat-icon", icon("clock")),
                      div(class = "stat-value", textOutput("uptime")),
                      div(class = "stat-label", "System Uptime"),
                      div(style = "margin-top: 10px;", 
                          span(icon("circle-check"), style = "color: #00ffaa;", " Operational"))
                  )
              ),
              div(class = "col-md-3",
                  div(class = "stat-card",
                      div(class = "stat-icon", icon("microchip")),
                      div(class = "stat-value", textOutput("load")),
                      div(class = "stat-label", "Neural Load"),
                      div(style = "margin-top: 10px;", 
                          span(icon("gauge-high"), style = "color: #f59e0b;", " Normal"))
                  )
              )
          ),
          
          # Main Content - Plot and Controls
          div(class = "row",
              div(class = "col-lg-7",
                  div(class = "glass-card",
                      div(style = "display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;",
                          h3(style = "margin: 0;", icon("waveform"), " Neural Market Trend"),
                          div(actionButton("refresh", "Synchronize", icon = icon("rotate-right"), class = "btn-glass"))
                      ),
                      plotlyOutput("trendChart", height = "400px")
                  )
              ),
              div(class = "col-lg-5",
                  div(class = "glass-card",
                      h3(icon("sliders"), " Quantum Filters"),
                      br(),
                      selectInput("period", "Time Horizon",
                                  choices = c("Last 7 cycles", "Last 30 cycles", "Last 90 cycles", "Annual horizon"),
                                  selected = "Last 30 cycles", width = "100%"),
                      sliderInput("threshold", "Alert Threshold", min = 0, max = 100, value = 75, step = 5, width = "100%"),
                      br(),
                      actionButton("apply", "Apply Parameters", icon = icon("check"), class = "btn-glass", style = "width: 100%;")
                  )
              )
          ),
          
          # Data Table Section - DT Table
          div(class = "row mt-4",
              div(class = "col-12",
                  div(class = "glass-card",
                      div(style = "display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;",
                          h3(style = "margin: 0;", icon("table"), " Transaction Ledger"),
                          div(
                            downloadButton("downloadData", "Export CSV", icon = icon("download"), class = "btn-glass", style = "padding: 8px 20px; font-size: 0.8rem;"),
                            actionButton("refreshTable", "Refresh", icon = icon("rotate-right"), class = "btn-glass", style = "margin-left: 10px; padding: 8px 20px; font-size: 0.8rem;")
                          )
                      ),
                      DTOutput("dataTable")
                  )
              )
          ),
          
          # System Metrics Row - ggplot converted to plotly
          div(class = "row mt-4",
              div(class = "col-md-6",
                  div(class = "glass-card",
                      h3(icon("activity"), " Neural Activity Stream"),
                      div(style = "margin-top: 20px;",
                          div(class = "activity-item",
                              div(class = "activity-icon", icon("user-plus", style = "color: #00ffff;")),
                              div(div(class = "activity-title", "New node registered"), 
                                  div(class = "activity-time", "2 minutes ago"))
                          ),
                          div(class = "activity-item",
                              div(class = "activity-icon", icon("shopping-cart", style = "color: #ff00ff;")),
                              div(div(class = "activity-title", "Quantum transaction processed"), 
                                  div(class = "activity-time", "15 minutes ago"))
                          ),
                          div(class = "activity-item",
                              div(class = "activity-icon", icon("chart-line", style = "color: #00ffaa;")),
                              div(div(class = "activity-title", "Analytics report generated"), 
                                  div(class = "activity-time", "1 hour ago"))
                          ),
                          div(class = "activity-item",
                              div(class = "activity-icon", icon("shield", style = "color: #f59e0b;")),
                              div(div(class = "activity-title", "Security scan completed"), 
                                  div(class = "activity-time", "3 hours ago"))
                          )
                      )
                  )
              ),
              div(class = "col-md-6",
                  div(class = "glass-card",
                      h3(icon("chart-simple"), " System Metrics - ggplot2 Style"),
                      plotlyOutput("systemMetricsPlot", height = "320px")
                  )
              )
          )
      )
    ),
    
    # ===== ANALYTICS TAB =====
    tabPanel(
      title = "Analytics",
      icon = icon("chart-pie"),
      div(class = "container-fluid", style = "padding: 30px;",
          h1(class = "gradient-text", icon("brain"), " Neural Analytics"),
          div(class = "row",
              div(class = "col-lg-6",
                  div(class = "glass-card",
                      h3(icon("border-all"), " Correlation Matrix"),
                      plotlyOutput("analyticsChart", height = "450px")
                  )
              ),
              div(class = "col-lg-6",
                  div(class = "glass-card",
                      h3(icon("chart-pie"), " Market Distribution"),
                      plotlyOutput("pieChart", height = "450px")
                  )
              )
          )
      )
    ),
    
    # ===== SETTINGS TAB =====
    tabPanel(
      title = "Settings",
      icon = icon("gear"),
      div(class = "container-fluid", style = "padding: 30px;",
          h1(class = "gradient-text", icon("sliders"), " System Configuration"),
          div(class = "glass-card",
              h3("Quantum Parameters"),
              checkboxInput("notifications", "Enable Neural Notifications", value = TRUE),
              checkboxInput("darkMode", "Dark Matter Mode", value = TRUE),
              checkboxInput("autoRefresh", "Auto-Sync", value = TRUE),
              br(),
              actionButton("saveSettings", "Save Configuration", icon = icon("save"), class = "btn-glass")
          )
      )
    )
  )
)

# ================================================================
# SERVER
# ================================================================
server <- function(input, output, session) {
  
  # ===== STAT OUTPUTS =====
  output$revenue <- renderText({ "$124.5K" })
  output$users <- renderText({ "2,845" })
  output$uptime <- renderText({ "99.99%" })
  output$load <- renderText({ "42%" })
  
  # ===== TRANSACTION DATA =====
  transaction_data <- reactive({
    input$refreshTable
    isolate({
      set.seed(456)
      data.frame(
        Transaction_ID = paste0("TXN", sprintf("%05d", 1:15)),
        Date = seq.Date(Sys.Date() - 14, Sys.Date(), by = "day")[1:15],
        Customer = c("Alex Johnson", "Maria Garcia", "James Wilson", "Sarah Brown", "Michael Lee",
                     "Emily Davis", "David Martinez", "Lisa Rodriguez", "Robert Kim", "Jennifer White",
                     "William Chen", "Patricia Lopez", "Richard Harris", "Linda Clark", "Charles Lewis"),
        Product = sample(c("Neural Processor", "Quantum Chip", "Holo Display", "AI Core", "Memory Matrix", "Cooling Array"), 15, replace = TRUE),
        Amount = round(runif(15, 50, 1500), 2),
        Status = sample(c("Completed", "Pending", "Processing", "Shipped"), 15, replace = TRUE, prob = c(0.6, 0.1, 0.15, 0.15))
      )
    })
  })
  
  # ===== DT TABLE RENDER =====
  output$dataTable <- renderDT({
    df <- transaction_data()
    
    datatable(
      df,
      options = list(
        pageLength = 10,
        dom = 'Bfrtip',
        searching = TRUE,
        ordering = TRUE,
        paging = TRUE,
        lengthMenu = c(5, 10, 15, 20),
        columnDefs = list(
          list(className = 'dt-center', targets = '_all')
        ),
        initComplete = JS(
          "function(settings, json) {",
          "$(this.api().table().header()).css({",
          "  'background': 'linear-gradient(135deg, #00ffff, #ff00ff)',",
          "  'color': '#0a0a2a',",
          "  'font-weight': 'bold',",
          "  'border-bottom': '2px solid #00ffff'",
          "});",
          "}"
        )
      ),
      class = 'display compact stripe hover',
      rownames = FALSE,
      filter = 'top',
      extensions = 'Buttons',
      style = 'bootstrap5'
    ) %>%
      formatStyle(
        'Amount',
        background = styleColorBar(df$Amount, '#00ffff'),
        backgroundSize = '100% 90%',
        backgroundRepeat = 'no-repeat',
        backgroundPosition = 'center',
        color = '#ffffff'
      ) %>%
      formatStyle(
        'Status',
        backgroundColor = styleEqual(
          c("Completed", "Shipped", "Pending", "Processing"),
          c("rgba(0, 255, 170, 0.2)", "rgba(0, 255, 255, 0.2)", "rgba(245, 158, 11, 0.2)", "rgba(139, 92, 246, 0.2)")
        ),
        fontWeight = 'bold'
      )
  })
  
  # ===== DOWNLOAD HANDLER =====
  output$downloadData <- downloadHandler(
    filename = function() { paste("transactions-", Sys.Date(), ".csv", sep = "") },
    content = function(file) { write.csv(transaction_data(), file, row.names = FALSE) }
  )
  
  # ===== CHART DATA - PLOTLY TREND CHART =====
  chart_data <- eventReactive(input$refresh, {
    dates <- seq.Date(Sys.Date() - 30, Sys.Date(), by = "day")
    values <- cumsum(runif(length(dates), -2, 5)) + 100
    data.frame(date = dates, value = values + rnorm(length(dates), 0, 2))
  }, ignoreNULL = FALSE)
  
  output$trendChart <- renderPlotly({
    req(chart_data())
    df <- chart_data()
    
    p <- plot_ly() %>%
      add_trace(x = df$date, y = df$value, 
                type = 'scatter', mode = 'lines+markers',
                line = list(color = '#00ffff', width = 3),
                marker = list(color = '#ff00ff', size = 6, symbol = 'circle'),
                fill = 'tozeroy',
                fillcolor = 'rgba(0, 255, 255, 0.1)',
                name = 'Neural Value',
                hovertemplate = 'Date: %{x}<br>Value: $%{y:.2f}<extra></extra>') %>%
      layout(
        paper_bgcolor = 'rgba(0,0,0,0)',
        plot_bgcolor = 'rgba(0,0,0,0)',
        xaxis = list(title = "", gridcolor = 'rgba(0, 255, 255, 0.15)', 
                     tickfont = list(color = 'rgba(255,255,255,0.7)', family = 'Share Tech Mono'),
                     zerolinecolor = 'rgba(0, 255, 255, 0.2)'),
        yaxis = list(title = "Market Value ($)", gridcolor = 'rgba(0, 255, 255, 0.15)', 
                     tickfont = list(color = 'rgba(255,255,255,0.7)', family = 'Share Tech Mono'),
                     titlefont = list(color = 'rgba(0, 255, 255, 0.8)')),
        margin = list(t = 30, l = 50, r = 30, b = 30),
        hovermode = 'x unified',
        hoverlabel = list(bgcolor = 'rgba(10, 15, 35, 0.9)', 
                          bordercolor = '#00ffff',
                          font = list(color = 'white', family = 'Share Tech Mono')),
        showlegend = FALSE
      ) %>%
      config(displayModeBar = TRUE, displaylogo = FALSE)
    
    p
  })
  
  # ===== SYSTEM METRICS PLOT - GGPLOT2 STYLE CONVERTED TO PLOTLY =====
  output$systemMetricsPlot <- renderPlotly({
    metrics_data <- data.frame(
      Metric = c("CPU", "Memory", "Disk I/O", "Network", "Database", "Cache"),
      Usage = c(45, 62, 38, 54, 29, 71),
      Target = c(70, 70, 70, 70, 70, 70)
    )
    
    # Create ggplot first
    g <- ggplot(metrics_data, aes(x = Metric, y = Usage, fill = Metric)) +
      geom_bar(stat = "identity", alpha = 0.8, width = 0.7) +
      geom_hline(yintercept = 70, linetype = "dashed", color = "#ff00ff", size = 1, alpha = 0.8) +
      geom_text(aes(label = paste0(Usage, "%")), vjust = -0.5, 
                color = "white", fontface = "bold", size = 4) +
      scale_fill_manual(values = c("#00ffff", "#ff00ff", "#00ffaa", "#f59e0b", "#8b5cf6", "#ec4899")) +
      scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, 20)) +
      labs(title = "Resource Utilization Metrics",
           y = "Usage Percentage (%)",
           x = "System Component") +
      theme_minimal() +
      theme(
        plot.background = element_rect(fill = "transparent", color = NA),
        panel.background = element_rect(fill = "transparent", color = NA),
        panel.grid.major = element_line(color = "rgba(0, 255, 255, 0.15)", size = 0.3),
        panel.grid.minor = element_line(color = "rgba(0, 255, 255, 0.08)", size = 0.2),
        plot.title = element_text(color = "#00ffff", size = 14, face = "bold", hjust = 0.5),
        axis.title = element_text(color = "rgba(255,255,255,0.7)", size = 11),
        axis.text = element_text(color = "rgba(255,255,255,0.8)", size = 10, face = "bold"),
        axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "none"
      )
    
    # Convert to plotly
    ggplotly(g, tooltip = c("x", "y")) %>%
      layout(
        paper_bgcolor = 'rgba(0,0,0,0)',
        plot_bgcolor = 'rgba(0,0,0,0)',
        hoverlabel = list(bgcolor = 'rgba(10, 15, 35, 0.9)', 
                          bordercolor = '#00ffff',
                          font = list(color = 'white'))
      ) %>%
      config(displayModeBar = FALSE)
  })
  
  # ===== ANALYTICS HEATMAP - PLOTLY =====
  output$analyticsChart <- renderPlotly({
    set.seed(789)
    data_matrix <- matrix(runif(100, 0, 1), 10, 10)
    colnames(data_matrix) <- paste("Metric", 1:10)
    rownames(data_matrix) <- paste("Var", 1:10)
    
    p <- plot_ly() %>%
      add_heatmap(z = data_matrix, x = colnames(data_matrix), y = rownames(data_matrix),
                  colorscale = list(c(0, '#0a0a2a'), c(0.5, '#00ffff'), c(1, '#ff00ff')),
                  hovertemplate = 'X: %{x}<br>Y: %{y}<br>Correlation: %{z:.3f}<extra></extra>') %>%
      layout(
        paper_bgcolor = 'rgba(0,0,0,0)',
        plot_bgcolor = 'rgba(0,0,0,0)',
        xaxis = list(title = "", tickfont = list(color = 'rgba(0, 255, 255, 0.7)', size = 9), tickangle = 45),
        yaxis = list(title = "", tickfont = list(color = 'rgba(0, 255, 255, 0.7)', size = 9))
      ) %>%
      config(displayModeBar = FALSE)
    
    p
  })
  
  # ===== PIE CHART - PLOTLY =====
  output$pieChart <- renderPlotly({
    categories <- c("Quantum Core", "Neural Network", "Data Matrix", "AI Processing", "Storage Array")
    values <- c(40, 28, 18, 10, 4)
    
    p <- plot_ly() %>%
      add_pie(labels = categories, values = values,
              textposition = 'inside',
              textinfo = 'label+percent',
              hoverinfo = 'label+value+percent',
              marker = list(colors = c('#00ffff', '#ff00ff', '#00ffaa', '#f59e0b', '#8b5cf6'),
                            line = list(color = '#0a0a2a', width = 2)),
              hovertemplate = '%{label}<br>Value: %{value}%<br>Percentage: %{percent}<extra></extra>') %>%
      layout(
        paper_bgcolor = 'rgba(0,0,0,0)',
        plot_bgcolor = 'rgba(0,0,0,0)',
        showlegend = TRUE,
        legend = list(font = list(color = 'rgba(0, 255, 255, 0.7)', size = 10), 
                      bgcolor = 'rgba(10, 15, 35, 0.5)',
                      bordercolor = '#00ffff',
                      borderwidth = 1),
        margin = list(t = 30, b = 30, l = 30, r = 30)
      ) %>%
      config(displayModeBar = FALSE)
    
    p
  })
  
  # ===== ROUNDED CORNER TOAST NOTIFICATIONS =====
  observeEvent(input$refresh, {
    toastr_success(
      message = "Neural data synchronized successfully", 
      title = "Sync Complete",
      position = "top-right", 
      progressBar = TRUE, 
      closeButton = TRUE, 
      timeOut = 3000,
      newestOnTop = TRUE,
      preventDuplicates = TRUE
    )
  })
  
  observeEvent(input$refreshTable, {
    toastr_info(
      message = "Transaction ledger updated", 
      title = "Table Refreshed",
      position = "top-right", 
      progressBar = TRUE, 
      closeButton = TRUE, 
      timeOut = 2000
    )
  })
  
  observeEvent(input$apply, {
    toastr_info(
      message = paste("Applied quantum parameters for", input$period), 
      title = "Filters Updated",
      position = "top-right", 
      progressBar = TRUE, 
      closeButton = TRUE, 
      timeOut = 3000
    )
  })
  
  observeEvent(input$saveSettings, {
    toastr_success(
      message = "System configuration saved to quantum memory", 
      title = "Settings Saved",
      position = "top-right", 
      progressBar = TRUE, 
      closeButton = TRUE, 
      timeOut = 3000
    )
  })
}

# ================================================================
# RUN THE APP
# ================================================================
shinyApp(ui, server)

