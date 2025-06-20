library(bslib)
library(shiny)
ui <- page_sidebar(
  title = "Football interaktive applikation",
  sidebar = sidebar(
    sliderInput("bins",
                "Antal bins:",
                min = 1,
                max = 50,
                value = 30),
    selectInput("varval", "Välj numerisk variabel:", choices = NULL),
    textOutput("val_text"),
    selectInput("player", "Välj spelare:", choices = NULL),
    card(
      card_header("Författare"),
      div(
        div(
          imageOutput("img_author1"),
          style = "width: 40px; height: 40px; border-radius: 50%;"
        ),
        div(
          tags$a(href = "https://www.linkedin.com/in/tim-trinh-091889290/","LinkedIn-hemsidan", target = "_blank")
        )
      ),
      div(
        div(
          imageOutput("img_author2"),
          style = "witdh: 40px; height: 40px; border-radius: 50%;"
        ),
        div(
          tags$a(href = "https://www.linkedin.com/in/thai-pham-06a5482bb/","LinkedIn-hemsidan", target = "_blank")
        )
      ),
      style = "display: inline;"
    ),
    style = "color: white; background-color: grey; width: 100%; height: 100%;"
  ),
  layout_columns(
    value_box(
      title = "Max value",
      value = textOutput("max_value"),
      showcase = bsicons::bs_icon("bar-chart"),
      style = "height: 400px; width: 100%; background-color: #83C4D2;"
    ),
    value_box(
      title = "Min value",
      value = textOutput("min_value"),
      showcase = bsicons::bs_icon("bar-chart"),
      style = "height: 400px; width: 100%;  background-color: #83C4D2;"
    ),
    value_box(
      title = "Mean value",
      value = textOutput("mean_value"),
      showcase = bsicons::bs_icon("bar-chart"),
      style = "height: 400px; width: 100%;  background-color: #83C4D2;"
    )
  ),
  layout_columns(
    col_widths = 6,
    div(
      plotOutput("distPlot"),
      style = "max-height: 400px; max-width: 800px"
    ),
    div(
      plotOutput("boxPlot")
    )
  ),
  layout_columns(
    col_widths = 6,
    div(
      plotOutput("radarplot"),
      style = "height: 500px; width: 500px; margin-left: auto; margin-right: auto;"
    ),
    div(
      imageOutput("img"),
      style = "margin-left: auto;"
    ),
    style = "margin-top: 300px; margin-left: auto; margin-right: auto;"
  )
)