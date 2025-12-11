library(tidyverse)
library(babynames)
library(bslib)
library(stringr)
library(plotly)
library(forcats)

# -------------------- PRECOMPUTE DATA ------------------------
babynames_cap <- babynames %>% 
  mutate(name = str_to_title(name))

babynames_ranked <- babynames_cap %>%
  group_by(year, sex) %>%
  mutate(rank = rank(-n, ties.method = "first")) %>%
  ungroup()

uniqueness_scale <- function(prop){
  case_when(
    prop < 0.0001 ~ "Extremely Rare",
    prop < 0.0005 ~ "Very Rare",
    prop < 0.001  ~ "Rare",
    prop < 0.005  ~ "Moderately Common",
    prop < 0.01   ~ "Common",
    TRUE          ~ "Very Common"
  )
}

uni_colors <- c(
  "Extremely Rare"       = "yellow",
  "Very Rare"            = "goldenrod",
  "Rare"                 = "chocolate",
  "Moderately Common"    = "tomato",
  "Common"               = "indianred4",
  "Very Common"          = "chartreuse3"
)
sex_colors <- c("F" = "hotpink", "M" = "skyblue")

babynames_scaled <- babynames_ranked %>%
  group_by(year, sex) %>%
  mutate(prop = n / sum(n)) %>%   # proportion of total births that year & sex
  ungroup() %>%
  mutate(
    uniqueness = uniqueness_scale(prop),
    uniqueness = factor(uniqueness, levels = names(uni_colors))
  )

# Diversity metrics
diversity <- babynames_scaled %>%
  group_by(year, sex) %>%
  summarize(
    shannon = -sum(prop * log2(prop), na.rm = TRUE),
    gini = 1 - sum(prop^2),
    .groups = "drop"
  )

max_births <- max(babynames$n, na.rm = TRUE)

# -------------------- UI ------------------------
ui <- fluidPage(
  theme = bs_theme(
    version = 5,
    bootswatch = "morph",
    primary = "#FF6F91",
    secondary = "#FFB07C",
    info = "#6EC1E4",
    base_font = font_google("Nunito"),
    heading_font = font_google("Fredoka One")
  ),
  
  titlePanel(div("👶🍼 U.S. Baby Names Explorer 🍼👶", class="kawaii-title")),
  
  sidebarLayout(
    sidebarPanel(
      width = 3,
      selectizeInput(
        "name", "Search name:",
        choices = character(0),
        multiple = FALSE,
        options = list(
          placeholder = "Type a name...",
          maxOptions = 20,
          server = TRUE
        )
      ),
      checkboxGroupInput(
        "sex", "Gender:",
        choices = c("Female" = "F", "Male" = "M"),
        selected = c("F","M")
      ),
      sliderInput("yearRange", "Year Range:",
                  min = 1880, max = 2017,
                  value = c(1880, 2017), sep = ""),
      hr(),
      helpText("Data Source: U.S. SSA Baby Names (1880–2017)")
    ),
    
    mainPanel(
      width = 9,
      tabsetPanel(
        
        # ---------------- TAB 1 ----------------
        tabPanel("Name Trends",
                 uiOutput("nameSummaryBox"),
                 fluidRow(
                   column(9,
                          h3("Popularity Over Time", style="color:#FF6F91;"),
                          plotlyOutput("popPlot", height = "420px")
                   ),
                   column(3,
                          div(class="zoom-panel",
                              h5("Zoom Controls"),
                              sliderInput("popZoomX", "X Range:", min = 1880, max = 2017, value = c(1880, 2017)),
                              sliderInput("popZoomY", "Y Range:", min = 0, max = max_births, value = c(0, 60000))
                          )
                   )
                 ),
                 fluidRow(
                   column(9,
                          h3("Rank Over Time", style="color:#FF6F91;"),
                          plotlyOutput("rankPlot", height="420px")
                   ),
                   column(3,
                          div(class="zoom-panel",
                              h5("Zoom Controls"),
                              sliderInput("rankZoomX", "X Range:", min = 1880, max = 2017, value = c(1880, 2017)),
                              sliderInput("rankZoomY", "Rank Range:", min = 1, max = 1200, value = c(1, 1200))
                          )
                   )
                 )
        ),
        
        # ---------------- TAB 2 ----------------
        tabPanel("Top Names",
                 fluidRow(
                   column(9,
                          h3("Most Popular Baby Names", style="color:#FF6F91;"),
                          plotlyOutput("topNamesPlot", height = "520px")
                   ),
                   column(3,
                          div(class="zoom-panel",
                              h5("Top Number of Names"),
                              numericInput("top_n_right", "Top names to show:", value = 25, min = 5, max = 200)
                          )
                   )
                 )
        ),
        
        # ---------------- TAB 3 ----------------
        tabPanel("Diversity",
                 h3("Shannon Entropy (Name Diversity)", style="color:#FF6F91"),
                 plotlyOutput("entropyPlot", height="400px"),
                 p("This graph shows Shannon entropy over time, a population-level measure of 
  naming diversity. Higher entropy values indicate a wider distribution of 
  baby names, meaning fewer babies share the same names."),
                 h3("Gini Coefficient (Name Concentration)", style="color:#FF6F91"),
                 plotlyOutput("giniPlot", height="400px"),
                 p("This graph displays the Gini coefficient over time, which measures how 
  concentrated baby name usage is within each year. Higher Gini values indicate 
  that a small number of names account for a large proportion of births, while 
  lower values suggest names are more evenly distributed.")
        )
        
      ) # end tabsetPanel
    ) # end mainPanel
  ) # end sidebarLayout
) # end fluidPage

# -------------------- SERVER ------------------------
server <- function(input, output, session){
  
  # Update name choices server-side
  observe({
    updateSelectizeInput(session, "name", choices = unique(babynames_scaled$name), server = TRUE)
  })
  
  corrected_name <- reactive({
    req(input$name)
    str_to_title(input$name)
  })
  
  filtered_df <- reactive({
    req(input$sex)
    req(!is.null(input$name), input$name != "")
    
    babynames_scaled %>%
      filter(
        sex %in% input$sex,
        year >= input$yearRange[1],
        year <= input$yearRange[2],
        name == corrected_name()
      )
  })
  
  # Name Summary Box
  output$nameSummaryBox <- renderUI({
    df <- filtered_df()
    req(nrow(df) > 0)
    total_births <- sum(df$n)
    years_used <- paste(min(df$year), "–", max(df$year))
    peak_row <- df[which.max(df$n), ]
    peak_year <- peak_row$year
    peak_n <- peak_row$n
    unique_levels <- paste(unique(df$uniqueness), collapse=", ")
    
    box_color <- case_when(
      length(unique(df$sex)) > 1 ~ "#FFB07C",
      unique(df$sex) == "F"      ~ "#FAC2EB",
      unique(df$sex) == "M"      ~ "#B7F9FF"
    )
    
    div(
      style = sprintf("background:%s;padding:18px;border-radius:12px;margin-bottom:20px;font-size:16px;", box_color),
      HTML(sprintf("<b>Summary for %s</b><br>Total Births: %s<br>Years Used: %s<br>Peak Year: %s (%s births)<br>Rarity Category: %s<br>Sex(es): %s",
                   unique(df$name),
                   format(total_births, big.mark=","),
                   years_used,
                   peak_year,
                   format(peak_n, big.mark=","),
                   unique_levels,
                   paste(unique(df$sex), collapse=", ")
      ))
    )
  })
  
  # Plotly outputs (popularity, rank, top names, entropy, gini)
  output$popPlot <- renderPlotly({
    df <- filtered_df(); req(nrow(df) > 0)
    p <- ggplot(df, aes(year, n, color = uniqueness, text = paste("Year:", year, "<br>Births:", n, "<br>Uniqueness:", uniqueness))) +
      geom_point(size = 3, alpha = 0.9) +
      scale_color_manual(values = uni_colors) +
      coord_cartesian(xlim = input$popZoomX, ylim = input$popZoomY) +
      theme_minimal()
    ggplotly(p, tooltip="text")
  })
  
  output$rankPlot <- renderPlotly({
    df <- filtered_df(); req(nrow(df) > 0)
    p <- ggplot(df, aes(year, rank, color=uniqueness, text=paste("Year:", year, "<br>Rank:", rank, "<br>Uniqueness:", uniqueness))) +
      geom_point(size=3, alpha=0.9) +
      scale_color_manual(values=uni_colors) +
      scale_y_reverse() +
      coord_cartesian(xlim = input$rankZoomX, ylim = input$rankZoomY) +
      theme_minimal()
    ggplotly(p, tooltip="text")
  })
  
  output$topNamesPlot <- renderPlotly({
    req(input$sex)
    top_n_use <- input$top_n_right
    df <- babynames_scaled %>%
      filter(year >= input$yearRange[1], year <= input$yearRange[2], sex %in% input$sex) %>%
      group_by(name, sex) %>%
      summarize(total_births = sum(n, na.rm=TRUE), .groups="drop") %>%
      arrange(desc(total_births)) %>%
      slice_head(n = top_n_use) %>%
      mutate(name = forcats::fct_reorder(name, total_births))
    
    p <- ggplot(df, aes(x=name, y=total_births, fill=sex, text=paste0("Name: ", name, "<br>Total births: ", total_births, "<br>Sex: ", sex))) +
      geom_col() + scale_fill_manual(values=sex_colors) + coord_flip() +
      labs(x="Baby Name", y="Total Number of Births")
    
    ggplotly(p, tooltip="text")
  })
  
  output$entropyPlot <- renderPlotly({
    df <- diversity %>% filter(sex %in% input$sex, year >= input$yearRange[1], year <= input$yearRange[2])
    p <- ggplot(df, aes(year, shannon, color=sex)) + geom_line(linewidth=1) + scale_color_manual(values=sex_colors) + labs(y="Shannon Entropy") + theme_minimal()
    ggplotly(p, tooltip=c("year","shannon","sex"))
  })
  
  output$giniPlot <- renderPlotly({
    df <- diversity %>% filter(sex %in% input$sex, year >= input$yearRange[1], year <= input$yearRange[2])
    p <- ggplot(df, aes(year, gini, color=sex)) + geom_line(linewidth=1) + scale_color_manual(values=sex_colors) + labs(y="Gini Coefficient") + theme_minimal()
    ggplotly(p, tooltip=c("year","gini","sex"))
  })
}

shinyApp(ui, server)
