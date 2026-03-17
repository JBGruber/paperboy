


# Libraries --------------------------------------------------------------

{
  library(shiny)
  library(bslib)
  library(DT)
  library(dplyr)
  library(tidyr)
  library(ggplot2)
  library(future)
  library(promises)
}

# running tests in a background process so the UI doesn't freeze
plan(multisession)


# Functions ---------------------------------------------------------------

`%||%` <- function(x, y) if (length(x) == 0 || is.na(x)) y else x

source("dashboard/helpers.R")



# Preparation -------------------------------------------------------------

# define paths
DB_PATH      <- "dashboard/paperboy_monitor.sqlite"
STATUS_CSV   <- normalizePath(file.path("inst", "status.csv"), mustWork = FALSE)
HELPERS_PATH <- normalizePath(
  if (file.exists("dashboard/helpers.R")) "dashboard/helpers.R" else "helpers.R",
  mustWork = FALSE
)

# initialize status db
init_db(DB_PATH)

# get domains from status.csv
status_info  <- read.csv(STATUS_CSV, stringsAsFactors = FALSE)
all_domains <- sort(status_info$domain)


# ── UI ────────────────────────────────────────────────────────────────────────

ui <- page_navbar(
  title = "Paperboy Monitor",
  theme = bs_theme(
    bootswatch          = "flatly",
    "navbar-bg"         = "#2c3e50",
    "navbar-dark-color" = "#ecf0f1"
  ),
  fillable = TRUE,

  # Overview -----------------------------------------------------------------
  nav_panel(
    title = "Overview",
    icon  = icon("gauge-high"),

    layout_columns(
      fill  = FALSE,
      class = "mt-3",
      value_box("Total Scrapers", textOutput("n_total", inline = TRUE),
                showcase = icon("newspaper"),          theme = "secondary"),
      value_box("OK",       textOutput("n_ok",       inline = TRUE),
                showcase = icon("circle-check"),       theme = "success"),
      value_box("Degraded", textOutput("n_degraded", inline = TRUE),
                showcase = icon("triangle-exclamation"), theme = "warning"),
      value_box("Broken",   textOutput("n_broken",   inline = TRUE),
                showcase = icon("circle-xmark"),       theme = "danger"),
      value_box("No RSS",   textOutput("n_no_rss",   inline = TRUE),
                showcase = icon("rss"),                theme = "secondary")
    ),

    tags$script(HTML("
      $(document).on('click', '#run_tests, #run_selected, #test_domain', function() {
        $('#instant_running_banner').removeClass('d-none');
      });
      $(document).on('shiny:value', function(e) {
        if (e.name === 'running_alert') $('#instant_running_banner').addClass('d-none');
      });
    ")),
    card(
      fill = TRUE,
      card_header(
        div(class = "d-flex justify-content-between align-items-center",
          div(class = "d-flex align-items-center gap-3",
            strong("Scraper Status"),
            div(id = "instant_running_banner",
                class = "d-flex d-none align-items-center gap-2 text-warning fw-semibold",
                tags$div(class = "spinner-border spinner-border-sm flex-shrink-0"),
                span("Tests are running — this may take a few minutes")
            ),
            uiOutput("running_alert")
          ),
          div(class = "d-flex align-items-center gap-3",
            textOutput("last_run_text", inline = TRUE),
            uiOutput("run_selected_button_ui"),
            uiOutput("run_button_ui")
          )
        )
      ),
      DTOutput("status_table")
    )
  ),

  # Domain detail ------------------------------------------------------------
  nav_panel(
    title = "Domain Detail",
    icon  = icon("magnifying-glass"),

    layout_sidebar(
      sidebar = sidebar(
        width = 260,
        selectInput("domain_select", "Domain:",
                    choices  = all_domains,
                    selected = all_domains[1]),
        hr(),
        strong("Current status"),
        uiOutput("domain_health_badge"),
        br(),
        uiOutput("domain_last_tested_ui"),
        uiOutput("domain_rss_ui"),
        hr(),
        uiOutput("test_domain_button_ui")
      ),

      card(
        card_header("Extraction Quality Over Time"),
        plotOutput("trend_plot", height = "300px")
      ),
      card(
        card_header("Test History"),
        DTOutput("domain_history_table")
      )
    )
  ),

  # Run history --------------------------------------------------------------
  nav_panel(
    title = "Run History",
    icon  = icon("clock-rotate-left"),
    card(
      card_header("All Test Runs"),
      DTOutput("runs_table")
    )
  )
)



# ── Server ────────────────────────────────────────────────────────────────────

server <- function(input, output, session) {

  rv <- reactiveValues(
    running        = FALSE,
    run_start      = NULL,
    current_run_id = NULL,
    completed_at   = NULL
  )

  # Latest per-domain results ------------------------------------------------
  # Only re-polls the DB while tests are actively running.
  # When idle, the table is stable and never resets.
  latest <- reactive({
    if (rv$running) invalidateLater(4000)
    get_latest_results(DB_PATH, status_info)
  })

  # Summary cards ------------------------------------------------------------
  output$n_total <- renderText(nrow(status_info))

  output$n_ok <- renderText({
    r <- latest()
    if (nrow(r) == 0) "—" else sum(r$health == "ok", na.rm = TRUE)
  })

  output$n_degraded <- renderText({
    r <- latest()
    if (nrow(r) == 0) "—" else sum(r$health == "degraded", na.rm = TRUE)
  })

  output$n_broken <- renderText({
    r <- latest()
    if (nrow(r) == 0) "—" else sum(r$health %in% c("broken", "error"), na.rm = TRUE)
  })

  output$n_no_rss <- renderText({
    r <- latest()
    if (nrow(r) == 0) "—" else sum(r$health == "no_rss", na.rm = TRUE)
  })

  output$last_run_text <- renderText({
    r  <- latest()
    ts <- r$tested_at[!is.na(r$tested_at)]
    if (length(ts) == 0) return("Never tested")
    paste("Last run:", format(max(as.POSIXct(ts)), "%Y-%m-%d %H:%M"))
  })

  # Run button ---------------------------------------------------------------
  output$run_button_ui <- renderUI({
    if (rv$running) {
      tags$button("Running...", class = "btn btn-sm btn-secondary", disabled = "disabled")
    } else {
      actionButton("run_tests", "Run All",
                   class = "btn btn-sm btn-primary", icon = icon("play"))
    }
  })

  output$run_selected_button_ui <- renderUI({
    sel <- input$status_table_rows_selected
    if (rv$running || length(sel) == 0) {
      tags$button(
        if (length(sel) == 0) "Run Selected" else paste("Run Selected", paste0("(", length(sel), ")")),
        class    = "btn btn-sm btn-outline-primary",
        disabled = "disabled"
      )
    } else {
      actionButton("run_selected", paste0("Run Selected (", length(sel), ")"),
                   class = "btn btn-sm btn-outline-primary", icon = icon("play"))
    }
  })

  output$test_domain_button_ui <- renderUI({
    domain <- req(input$domain_select)
    has_rss <- nzchar(trimws(
      status_info$rss[status_info$domain == domain] %||% ""
    ))
    if (rv$running) {
      tags$button("Running...", class = "btn btn-sm btn-secondary w-100", disabled = "disabled")
    } else if (!has_rss) {
      tags$button("No RSS — cannot test", class = "btn btn-sm btn-secondary w-100", disabled = "disabled")
    } else {
      actionButton("test_domain", "Test This Domain",
                   class = "btn btn-sm btn-outline-primary w-100", icon = icon("flask"))
    }
  })

  # Detect completion by polling the DB — more robust than promise callbacks
  observe({
    req(rv$running, rv$current_run_id)
    invalidateLater(4000)
    runs <- get_run_history(DB_PATH)
    completed <- runs$run_id == rv$current_run_id & runs$status == "completed"
    if (any(completed, na.rm = TRUE)) {
      rv$running      <- FALSE
      rv$completed_at <- Sys.time()
      showNotification(
        paste("Tests completed!", format(Sys.time(), "%H:%M")),
        type = "message", duration = 6
      )
    }
  })

  output$running_alert <- renderUI({
    invalidateLater(1000)
    if (rv$running) {
      elapsed <- as.numeric(difftime(Sys.time(), rv$run_start, units = "mins"))
      div(class = "d-flex align-items-center gap-2 text-warning fw-semibold",
        tags$div(class = "spinner-border spinner-border-sm flex-shrink-0"),
        span(sprintf("Tests running — this may take a few minutes (%.1f min elapsed)", elapsed))
      )
    } else if (!is.null(rv$completed_at) &&
               as.numeric(difftime(Sys.time(), rv$completed_at, units = "secs")) < 10) {
      div(class = "d-flex align-items-center gap-2 text-success fw-semibold",
        tags$div(class = "spinner-border spinner-border-sm flex-shrink-0"),
        span("Updating table...")
      )
    } else {
      NULL
    }
  })

  # Status table -------------------------------------------------------------
  output$status_table <- renderDT({
    r <- latest()

    display <- r %>%
      mutate(
        http_pct     = ifelse(is.na(n_articles_attempted) | n_articles_attempted == 0,
                              NA_real_,
                              round(n_http_success / n_articles_attempted * 100)),
        pct_headline = round(pct_headline * 100),
        pct_datetime = round(pct_datetime * 100),
        pct_author   = round(pct_author   * 100),
        pct_text     = round(pct_text     * 100),
        tested_at    = ifelse(is.na(tested_at), "—",
                              format(as.POSIXct(tested_at), "%Y-%m-%d %H:%M"))
      ) %>%
      select(domain, health, http_pct, pct_headline,
             pct_datetime, pct_author, pct_text, tested_at)

    health_bg  <- c(ok = "#d4edda", degraded = "#fff3cd", broken = "#f8d7da",
                    error = "#f8d7da", no_rss = "#e9ecef", untested = "#e9ecef")
    health_col <- c(ok = "#155724", degraded = "#856404", broken = "#721c24",
                    error = "#721c24", no_rss = "#495057", untested = "#495057")

    datatable(
      display,
      rownames = FALSE,
      filter   = list(position = "top", clear = FALSE),
      colnames = c("Domain", "Status", "HTTP %", "Headline %",
                   "Datetime %", "Author %", "Text %", "Last Tested"),
      options   = list(
        pageLength = 30,
        order      = list(list(1, "asc")),
        dom        = "lftip",
        initComplete = JS("function() {
          var api = this.api();
          var col = api.column(1);
          var filterCell = $(api.table().header()).find('tr').eq(1).find('th, td').eq(1);
          filterCell.empty();
          var statuses = ['ok', 'degraded', 'broken', 'error', 'no_rss', 'untested'];
          var select = $('<select class=\"form-control form-control-sm\" style=\"width:100%\"><option value=\"\">All</option></select>')
            .appendTo(filterCell)
            .on('change', function() { col.search($(this).val(), true, false).draw(); });
          $.each(statuses, function(i, d) {
            select.append('<option value=\"' + d + '\">' + d + '</option>');
          });
        }")
      ),
      selection = "multiple"
    ) %>%
      formatStyle("health",
        backgroundColor = styleEqual(names(health_bg),  unname(health_bg)),
        color           = styleEqual(names(health_col), unname(health_col)),
        fontWeight      = "bold"
      ) %>%
      formatStyle(
        c("http_pct", "pct_headline", "pct_datetime", "pct_author", "pct_text"),
        backgroundColor = styleInterval(c(49, 79), c("#f8d7da", "#fff3cd", "#d4edda"))
      )
  }, server = FALSE)

  # Shared test launcher -----------------------------------------------------
  # domains = NULL  →  run all scrapers; otherwise run the subset
  launch_tests <- function(domains = NULL) {
    run_id            <- format(Sys.time(), "%Y%m%d_%H%M%S")
    rv$running        <- TRUE
    rv$run_start      <- Sys.time()
    rv$current_run_id <- run_id

    db <- DB_PATH
    si <- status_info
    hp <- HELPERS_PATH

    future_promise({
      source(hp)
      library(paperboy)
      run_tests(db, run_id, si, domains = domains, n_articles = 3)
    }, seed = TRUE) %...!% (function(e) {
      rv$running <- FALSE
      showNotification(paste("Tests failed:", conditionMessage(e)),
                       type = "error", duration = 10)
    })
  }

  observeEvent(input$run_tests,    { req(!rv$running); launch_tests() })

  observeEvent(input$run_selected, {
    req(!rv$running)
    sel <- input$status_table_rows_selected
    req(length(sel) > 0)
    launch_tests(domains = latest()$domain[sel])
  })

  observeEvent(input$test_domain,  { req(!rv$running); launch_tests(domains = input$domain_select) })

  # Domain detail ------------------------------------------------------------
  domain_hist <- reactive({
    req(input$domain_select)
    get_domain_history(DB_PATH, input$domain_select)
  })

  output$domain_health_badge <- renderUI({
    h <- domain_hist()
    if (nrow(h) == 0) return(span(class = "badge bg-secondary fs-6", "Untested"))
    badge_class <- switch(h$health[1],
      ok       = "bg-success",
      degraded = "bg-warning text-dark",
      broken   = "bg-danger",
      error    = "bg-danger",
      "bg-secondary"
    )
    span(class = paste("badge fs-6", badge_class), toupper(h$health[1]))
  })

  output$domain_last_tested_ui <- renderUI({
    h <- domain_hist()
    if (nrow(h) == 0) return(p("Never tested", class = "text-muted small"))
    p(format(as.POSIXct(h$tested_at[1]), "%Y-%m-%d %H:%M"), class = "text-muted small mb-0")
  })

  output$domain_rss_ui <- renderUI({
    rss <- status_info$rss[status_info$domain == req(input$domain_select)]
    if (length(rss) == 0 || is.na(rss)) return(p("No RSS feed", class = "text-muted small"))
    p(a(href = rss, rss, target = "_blank", class = "small text-break"), class = "mb-0 mt-1")
  })

  output$trend_plot <- renderPlot({
    h <- domain_hist()

    if (nrow(h) == 0) {
      return(ggplot() +
        annotate("text", x = 0.5, y = 0.5, label = "No test history yet",
                 size = 6, colour = "grey60") +
        theme_void())
    }

    h %>%
      mutate(tested_at = as.POSIXct(tested_at)) %>%
      pivot_longer(
        cols      = c(pct_headline, pct_datetime, pct_author, pct_text),
        names_to  = "metric",
        values_to = "value"
      ) %>%
      mutate(
        metric = recode(metric,
          pct_headline = "Headline", pct_datetime = "Datetime",
          pct_author   = "Author",   pct_text     = "Text"
        ),
        value = value * 100
      ) %>%
      ggplot(aes(x = tested_at, y = value, colour = metric, group = metric)) +
        geom_hline(yintercept = 50, linetype = "dashed", colour = "grey70") +
        geom_line(linewidth = 1.1) +
        geom_point(size = 2.5) +
        scale_y_continuous(limits = c(0, 100), labels = \(x) paste0(x, "%")) +
        scale_colour_manual(values = c(
          Headline = "#e74c3c", Datetime = "#3498db",
          Author   = "#2ecc71", Text     = "#f39c12"
        )) +
        labs(x = NULL, y = "Extraction rate", colour = NULL) +
        theme_minimal(base_size = 13) +
        theme(legend.position = "bottom", panel.grid.minor = element_blank())
  })

  output$domain_history_table <- renderDT({
    h <- domain_hist()
    if (nrow(h) == 0) return(NULL)

    h %>%
      mutate(
        tested_at    = format(as.POSIXct(tested_at), "%Y-%m-%d %H:%M"),
        pct_headline = paste0(round(pct_headline * 100, 1), "%"),
        pct_datetime = paste0(round(pct_datetime * 100, 1), "%"),
        pct_author   = paste0(round(pct_author   * 100, 1), "%"),
        pct_text     = paste0(round(pct_text     * 100, 1), "%")
      ) %>%
      select(tested_at, health, n_articles_attempted, n_http_success,
             pct_headline, pct_datetime, pct_author, pct_text, error_msg) %>%
      datatable(
        rownames = FALSE,
        colnames = c("Tested At", "Health", "Articles", "HTTP OK",
                     "Headline%", "Datetime%", "Author%", "Text%", "Error"),
        options  = list(pageLength = 10, dom = "tip"),
        selection = "none"
      )
  })

  # Run history --------------------------------------------------------------
  output$runs_table <- renderDT({
    if (rv$running) invalidateLater(4000)
    runs <- get_run_history(DB_PATH)
    if (nrow(runs) == 0) return(NULL)

    runs %>%
      mutate(
        started_at   = format(as.POSIXct(started_at), "%Y-%m-%d %H:%M"),
        completed_at = ifelse(
          is.na(completed_at), "—",
          format(as.POSIXct(completed_at), "%Y-%m-%d %H:%M")
        )
      ) %>%
      datatable(
        rownames  = FALSE,
        colnames  = c("Run ID", "Started", "Completed", "Domains Tested", "Status"),
        options   = list(pageLength = 20, dom = "tip"),
        selection = "none"
      )
  })
}

shinyApp(ui, server)
