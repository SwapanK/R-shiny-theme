library(shiny)
library(bslib)
library(ggplot2)
library(dplyr)
library(plotly)
library(shinytoastr)
library(DT)

# Custom Glass Theme CSS with White Background Images
glass_theme <- "
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');

* {
  font-family: 'Inter', sans-serif;
}

body {
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  min-height: 100vh;
  background-attachment: fixed;
  position: relative;
}

/* Glass Navbar */
.navbar {
  background: rgba(255, 255, 255, 0.85) !important;
  backdrop-filter: blur(20px) saturate(180%);
  border-bottom: 1px solid rgba(255, 255, 255, 0.5) !important;
  box-shadow: 0 8px 32px rgba(31, 38, 135, 0.07);
  padding: 1rem 2rem !important;
}

.navbar-brand {
  font-weight: 700 !important;
  font-size: 1.5rem !important;
  background: linear-gradient(135deg, #667eea, #764ba2);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.navbar-nav > li > a {
  color: #2d3748 !important;
  font-weight: 500 !important;
  transition: all 0.3s ease !important;
}

.navbar-nav > li.active > a {
  color: #667eea !important;
  background: transparent !important;
}

.navbar-nav > li.active > a::after {
  content: '';
  position: absolute;
  bottom: -5px;
  left: 0;
  width: 100%;
  height: 2px;
  background: linear-gradient(90deg, #667eea, #764ba2);
  border-radius: 2px;
}

/* Glass Cards */
.glass-card {
  background: rgba(255, 255, 255, 0.75) !important;
  backdrop-filter: blur(15px) saturate(180%);
  border: 1px solid rgba(255, 255, 255, 0.5) !important;
  border-radius: 24px !important;
  box-shadow: 0 8px 32px rgba(31, 38, 135, 0.08);
  padding: 25px !important;
  margin-bottom: 20px;
  transition: all 0.3s ease;
  color: #2d3748 !important;
}

.glass-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 15px 45px rgba(31, 38, 135, 0.12);
}

/* Glass Stat Cards */
.stat-card {
  background: rgba(255, 255, 255, 0.7);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.5);
  border-radius: 20px;
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
  background: linear-gradient(90deg, #667eea, #764ba2, #f093fb);
}

.stat-value {
  font-size: 2.5rem;
  font-weight: 700;
  color: #1a202c;
  margin-bottom: 5px;
}

.stat-label {
  color: #4a5568;
  font-size: 0.9rem;
  text-transform: uppercase;
  letter-spacing: 1px;
  font-weight: 600;
}

.stat-icon {
  position: absolute;
  right: 20px;
  top: 50%;
  transform: translateY(-50%);
  font-size: 3rem;
  opacity: 0.15;
  color: #667eea;
}

/* Glass Buttons */
.btn-glass {
  background: rgba(102, 126, 234, 0.15);
  border: 1px solid rgba(102, 126, 234, 0.3);
  color: #667eea;
  padding: 10px 25px;
  border-radius: 50px;
  font-weight: 600;
  backdrop-filter: blur(10px);
  transition: all 0.3s ease;
}

.btn-glass:hover {
  background: rgba(102, 126, 234, 0.25);
  border-color: #667eea;
  box-shadow: 0 0 30px rgba(102, 126, 234, 0.2);
  transform: translateY(-2px);
  color: #667eea;
}

/* Form Controls */
.form-control, .selectize-input {
  background: rgba(255, 255, 255, 0.6) !important;
  border: 1px solid rgba(255, 255, 255, 0.8) !important;
  border-radius: 12px !important;
  color: #2d3748 !important;
}

.form-control:focus {
  border-color: #667eea !important;
  box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1) !important;
}

/* Typography */
h1, h2, h3, h4, h5, h6 {
  color: #1a202c !important;
  font-weight: 700 !important;
}

.gradient-text {
  background: linear-gradient(135deg, #667eea, #764ba2);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  font-weight: 800;
}

/* Progress Bar */
.progress {
  background: rgba(255, 255, 255, 0.3) !important;
  border-radius: 10px !important;
  height: 8px !important;
}

.progress-bar {
  background: linear-gradient(90deg, #667eea, #764ba2) !important;
  border-radius: 10px !important;
}

/* DT Table Styling */
.dataTables_wrapper {
  color: #2d3748 !important;
}

.dataTable {
  background: transparent !important;
}

/* Scrollbar */
::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.3);
  border-radius: 10px;
}

::-webkit-scrollbar-thumb {
  background: rgba(102, 126, 234, 0.4);
  border-radius: 10px;
}
"

# UI
ui <- fluidPage(
  useToastr(),
  tags$head(
    tags$style(HTML(glass_theme)),
    tags$link(rel = "stylesheet", href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css")
  ),
  
  navbarPage(
    title = div(icon("cube"), "GlassDash Pro", style = "display: flex; align-items: center; gap: 10px;"),
    theme = bs_theme(version = 5),
    
    # Dashboard Tab
    tabPanel(
      title = "Dashboard",
      icon = icon("gauge-high"),
      
      div(class = "container-fluid", style = "padding: 30px;",
          
          # Header
          div(class = "row mb-4",
              div(class = "col-12",
                  h1(class = "gradient-text", "Analytics Dashboard"),
                  p(style = "color: #4a5568; font-size: 1.1rem;", "Real-time insights and performance metrics")
              )
          ),
          
          # Stats Cards
          div(class = "row mb-4",
              div(class = "col-md-3",
                  div(class = "stat-card",
                      div(class = "stat-icon", icon("dollar-sign")),
                      div(class = "stat-value", textOutput("revenue")),
                      div(class = "stat-label", "Total Revenue"),
                      div(style = "margin-top: 10px;", span(icon("trend-up"), style = "color: #10b981;", " +12.5%"))
                  )
              ),
              div(class = "col-md-3",
                  div(class = "stat-card",
                      div(class = "stat-icon", icon("users")),
                      div(class = "stat-value", textOutput("users")),
                      div(class = "stat-label", "Active Users"),
                      div(style = "margin-top: 10px;", span(icon("trend-up"), style = "color: #10b981;", " +8.1%"))
                  )
              ),
              div(class = "col-md-3",
                  div(class = "stat-card",
                      div(class = "stat-icon", icon("clock")),
                      div(class = "stat-value", textOutput("uptime")),
                      div(class = "stat-label", "Uptime"),
                      div(style = "margin-top: 10px;", span(icon("circle"), style = "color: #10b981;", " Stable"))
                  )
              ),
              div(class = "col-md-3",
                  div(class = "stat-card",
                      div(class = "stat-icon", icon("server")),
                      div(class = "stat-value", textOutput("load")),
                      div(class = "stat-label", "Server Load"),
                      div(style = "margin-top: 10px;", span(icon("gauge-high"), style = "color: #f59e0b;", " Normal"))
                  )
              )
          ),
          
          # Main Content - Plot and Table
          div(class = "row",
              div(class = "col-lg-7",
                  div(class = "glass-card",
                      div(style = "display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;",
                          h3(style = "margin: 0;", "Revenue Trend"),
                          div(actionButton("refresh", "Refresh", icon = icon("rotate-right"), class = "btn-glass"))
                      ),
                      plotlyOutput("trendChart", height = "380px")
                  )
              ),
              div(class = "col-lg-5",
                  div(class = "glass-card",
                      h3("Quick Filters"),
                      br(),
                      selectInput("period", "Select Period",
                                  choices = c("Last 7 days", "Last 30 days", "Last 90 days", "This year"),
                                  selected = "Last 30 days", width = "100%"),
                      sliderInput("threshold", "Alert Threshold", min = 0, max = 100, value = 75, step = 5, width = "100%"),
                      br(),
                      actionButton("apply", "Apply Changes", icon = icon("check"), class = "btn-glass", style = "width: 100%;")
                  )
              )
          ),
          
          # Data Table Section
          div(class = "row mt-4",
              div(class = "col-12",
                  div(class = "glass-card",
                      div(style = "display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;",
                          h3(style = "margin: 0;", "Recent Transactions"),
                          div(
                            downloadButton("downloadData", "Download CSV", icon = icon("download"), class = "btn-glass", style = "padding: 8px 20px; font-size: 0.8rem;"),
                            actionButton("refreshTable", "Refresh", icon = icon("rotate-right"), class = "btn-glass", style = "margin-left: 10px; padding: 8px 20px; font-size: 0.8rem;")
                          )
                      ),
                      DTOutput("dataTable")
                  )
              )
          ),
          
          # System Metrics Row
          div(class = "row mt-4",
              div(class = "col-md-6",
                  div(class = "glass-card",
                      h3("Recent Activity"),
                      div(style = "margin-top: 20px;",
                          div(style = "display: flex; align-items: center; padding: 12px; border-bottom: 1px solid rgba(0,0,0,0.05);",
                              div(style = "width: 40px; height: 40px; background: linear-gradient(135deg, #667eea20, #764ba220); border-radius: 12px; display: flex; align-items: center; justify-content: center; margin-right: 15px;",
                                  icon("user-plus", style = "color: #667eea;")),
                              div(div(style = "font-weight: 600;", "New user registered"), div(style = "color: #718096; font-size: 0.85rem;", "2 minutes ago"))
                          ),
                          div(style = "display: flex; align-items: center; padding: 12px; border-bottom: 1px solid rgba(0,0,0,0.05);",
                              div(style = "width: 40px; height: 40px; background: linear-gradient(135deg, #764ba220, #f093fb20); border-radius: 12px; display: flex; align-items: center; justify-content: center; margin-right: 15px;",
                                  icon("shopping-cart", style = "color: #764ba2;")),
                              div(div(style = "font-weight: 600;", "New order placed"), div(style = "color: #718096; font-size: 0.85rem;", "15 minutes ago"))
                          ),
                          div(style = "display: flex; align-items: center; padding: 12px;",
                              div(style = "width: 40px; height: 40px; background: linear-gradient(135deg, #f093fb20, #f5576c20); border-radius: 12px; display: flex; align-items: center; justify-content: center; margin-right: 15px;",
                                  icon("chart-line", style = "color: #f093fb;")),
                              div(div(style = "font-weight: 600;", "Report generated"), div(style = "color: #718096; font-size: 0.85rem;", "1 hour ago"))
                          )
                      )
                  )
              ),
              div(class = "col-md-6",
                  div(class = "glass-card",
                      h3("System Metrics"),
                      div(style = "margin-top: 20px;",
                          div(style = "margin-bottom: 20px;",
                              div(style = "display: flex; justify-content: space-between; margin-bottom: 5px;", span("CPU Usage"), span(textOutput("cpu"))),
                              div(class = "progress", div(class = "progress-bar", style = "width: 45%;"))
                          ),
                          div(style = "margin-bottom: 20px;",
                              div(style = "display: flex; justify-content: space-between; margin-bottom: 5px;", span("Memory Usage"), span(textOutput("memory"))),
                              div(class = "progress", div(class = "progress-bar", style = "width: 62%;"))
                          ),
                          div(style = "margin-bottom: 20px;",
                              div(style = "display: flex; justify-content: space-between; margin-bottom: 5px;", span("Disk Usage"), span(textOutput("disk"))),
                              div(class = "progress", div(class = "progress-bar", style = "width: 38%;"))
                          )
                      )
                  )
              )
          )
      )
    ),
    
    # Analytics Tab
    tabPanel(
      title = "Analytics",
      icon = icon("chart-pie"),
      div(class = "container-fluid", style = "padding: 30px;",
          h1(class = "gradient-text", "Advanced Analytics"),
          div(class = "row",
              div(class = "col-lg-6",
                  div(class = "glass-card",
                      h3("Correlation Heatmap"),
                      plotlyOutput("analyticsChart", height = "450px")
                  )
              ),
              div(class = "col-lg-6",
                  div(class = "glass-card",
                      h3("Category Distribution"),
                      plotlyOutput("pieChart", height = "450px")
                  )
              )
          )
      )
    ),
    
    # Settings Tab
    tabPanel(
      title = "Settings",
      icon = icon("gear"),
      div(class = "container-fluid", style = "padding: 30px;",
          h1(class = "gradient-text", "System Settings"),
          div(class = "glass-card",
              h3("Configuration"),
              checkboxInput("notifications", "Enable Notifications", value = TRUE),
              checkboxInput("whiteMode", "White Background Effect", value = TRUE),
              checkboxInput("autoRefresh", "Auto Refresh", value = TRUE),
              br(),
              actionButton("saveSettings", "Save Settings", icon = icon("save"), class = "btn-glass")
          )
      )
    )
  )
)

# Server
server <- function(input, output, session) {
  
  # Stats outputs
  output$revenue <- renderText({ "$124,589" })
  output$users <- renderText({ "2,845" })
  output$uptime <- renderText({ "99.99%" })
  output$load <- renderText({ "42%" })
  output$cpu <- renderText({ "45%" })
  output$memory <- renderText({ "62%" })
  output$disk <- renderText({ "38%" })
  
  # Generate transaction data
  transaction_data <- reactive({
    input$refreshTable
    isolate({
      set.seed(123)
      data.frame(
        Transaction_ID = paste0("TXN", sprintf("%05d", 1:15)),
        Date = seq.Date(Sys.Date() - 14, Sys.Date(), by = "day")[1:15],
        Customer = c("John Smith", "Emma Watson", "Michael Brown", "Lisa Johnson", "David Wilson",
                     "Sarah Davis", "James Martinez", "Maria Garcia", "Robert Taylor", "Jennifer Anderson",
                     "William Thomas", "Patricia Jackson", "Richard White", "Linda Harris", "Charles Martin"),
        Product = sample(c("Laptop", "Smartphone", "Tablet", "Headphones", "Monitor", "Keyboard"), 15, replace = TRUE),
        Amount = round(runif(15, 50, 1500), 2),
        Status = sample(c("Completed", "Pending", "Processing"), 15, replace = TRUE, prob = c(0.7, 0.15, 0.15))
      )
    })
  })
  
  # Render Data Table with styled header
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
        lengthMenu = c(5, 10, 15),
        columnDefs = list(
          list(className = 'dt-center', targets = c(0, 1, 2, 3, 4, 5))
        ),
        initComplete = JS(
          "function(settings, json) {",
          "$(this.api().table().header()).css({'background': 'linear-gradient(135deg, #667eea, #764ba2)', 'color': '#fff', 'font-weight': 'bold'});",
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
        background = styleColorBar(df$Amount, '#667eea'),
        backgroundSize = '100% 90%',
        backgroundRepeat = 'no-repeat',
        backgroundPosition = 'center'
      ) %>%
      formatStyle(
        'Status',
        backgroundColor = styleEqual(
          c("Completed", "Pending", "Processing"),
          c("rgba(16, 185, 129, 0.2)", "rgba(245, 158, 11, 0.2)", "rgba(59, 130, 246, 0.2)")
        )
      )
  })
  
  # Download handler
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("transactions-", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(transaction_data(), file, row.names = FALSE)
    }
  )
  
  # Generate chart data - FIXED: Use eventReactive instead of reactive with input dependency
  chart_data <- eventReactive(input$refresh, {
    dates <- seq.Date(Sys.Date() - 30, Sys.Date(), by = "day")
    values <- cumsum(runif(length(dates), -2, 5)) + 100
    data.frame(date = dates, value = values + rnorm(length(dates), 0, 2))
  }, ignoreNULL = FALSE)
  
  # Trend Chart - FIXED: Use renderPlotly with req()
  output$trendChart <- renderPlotly({
    req(chart_data())
    df <- chart_data()
    
    p <- plot_ly() %>%
      add_trace(x = df$date, y = df$value, 
                type = 'scatter', mode = 'lines+markers',
                line = list(color = '#667eea', width = 3),
                marker = list(color = '#764ba2', size = 6, symbol = 'circle'),
                fill = 'tozeroy',
                fillcolor = 'rgba(102, 126, 234, 0.15)',
                name = 'Revenue',
                hovertemplate = 'Date: %{x}<br>Revenue: $%{y:.2f}<extra></extra>') %>%
      layout(
        paper_bgcolor = 'rgba(0,0,0,0)',
        plot_bgcolor = 'rgba(0,0,0,0)',
        xaxis = list(title = "", gridcolor = 'rgba(0,0,0,0.05)', tickfont = list(color = '#4a5568')),
        yaxis = list(title = "Revenue ($)", gridcolor = 'rgba(0,0,0,0.05)', tickfont = list(color = '#4a5568'), titlefont = list(color = '#2d3748')),
        margin = list(t = 30, l = 50, r = 30, b = 30),
        hovermode = 'x unified',
        hoverlabel = list(bgcolor = 'rgba(255, 255, 255, 0.95)', font = list(color = '#2d3748', size = 12)),
        showlegend = FALSE
      ) %>%
      config(displayModeBar = TRUE, displaylogo = FALSE, modeBarButtonsToRemove = c('lasso2d', 'select2d'))
    
    p
  })
  
  # Analytics Heatmap - FIXED: Use renderPlotly with isolate
  output$analyticsChart <- renderPlotly({
    set.seed(456)
    data_matrix <- matrix(runif(100, 0, 1), 10, 10)
    colnames(data_matrix) <- paste("Var", 1:10)
    rownames(data_matrix) <- paste("Feature", 1:10)
    
    p <- plot_ly() %>%
      add_heatmap(z = data_matrix, x = colnames(data_matrix), y = rownames(data_matrix),
                  colorscale = list(c(0, '#ffffff'), c(0.5, '#667eea'), c(1, '#764ba2')),
                  hovertemplate = 'X: %{x}<br>Y: %{y}<br>Value: %{z:.3f}<extra></extra>') %>%
      layout(
        paper_bgcolor = 'rgba(0,0,0,0)',
        plot_bgcolor = 'rgba(0,0,0,0)',
        xaxis = list(title = "", tickfont = list(color = '#4a5568', size = 10), tickangle = 45),
        yaxis = list(title = "", tickfont = list(color = '#4a5568', size = 10)),
        margin = list(l = 80, r = 20, t = 20, b = 80)
      ) %>%
      config(displayModeBar = FALSE)
    
    p
  })
  
  # Pie Chart - FIXED: Use renderPlotly
  output$pieChart <- renderPlotly({
    categories <- c("Electronics", "Clothing", "Books", "Home & Garden", "Sports", "Toys")
    values <- c(35, 25, 15, 12, 8, 5)
    
    p <- plot_ly() %>%
      add_pie(labels = categories, values = values,
              textposition = 'inside',
              textinfo = 'label+percent',
              hoverinfo = 'label+value+percent',
              marker = list(colors = c('#667eea', '#764ba2', '#f093fb', '#4facfe', '#00f2fe', '#43e97b')),
              hovertemplate = '%{label}<br>Value: %{value}%<br>Percentage: %{percent}<extra></extra>') %>%
      layout(
        paper_bgcolor = 'rgba(0,0,0,0)',
        plot_bgcolor = 'rgba(0,0,0,0)',
        showlegend = TRUE,
        legend = list(font = list(color = '#4a5568'), bgcolor = 'rgba(255,255,255,0.5)'),
        margin = list(t = 30, b = 30, l = 30, r = 30)
      ) %>%
      config(displayModeBar = FALSE)
    
    p
  })
  
  # Notifications
  observeEvent(input$refresh, {
    toastr_success(message = "Data refreshed successfully", title = "Refresh Complete",
                   position = "top-right", progressBar = TRUE, closeButton = TRUE, timeOut = 3000)
  })
  
  observeEvent(input$refreshTable, {
    toastr_info(message = "Transaction table refreshed", title = "Table Updated",
                position = "top-right", progressBar = TRUE, closeButton = TRUE, timeOut = 2000)
  })
  
  observeEvent(input$apply, {
    toastr_info(message = paste("Filters applied for", input$period), title = "Filters Updated",
                position = "top-right", progressBar = TRUE, closeButton = TRUE, timeOut = 3000)
  })
  
  observeEvent(input$saveSettings, {
    toastr_success(message = "Settings have been saved successfully", title = "Settings Saved",
                   position = "top-right", progressBar = TRUE, closeButton = TRUE, timeOut = 3000)
  })
}

# Run the app
shinyApp(ui, server)


