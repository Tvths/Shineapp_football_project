# Define server logic ----
server <- function(input, output, session) {
  require(bsicons)
  require(dplyr)
  require(stringr)
  require(fmsb)
  
  data <- read.csv("datamaterial/utespelare.csv", sep = ";")
  data$average.rating <- as.numeric(gsub(",",".",data$average.rating))
  data$matchday <- str_extract(data$matchday,"S\\d+")
  data$matchday <- as.numeric(str_remove(data$matchday,"S"))
  data <- data[data$position == "GK",]
  
  aggregerad <- data %>%
    select(name,acc,agg,agi,cmd,cnt,ecc,fir,fre,han,otb,pac) %>%
    group_by(name) %>%
    summarise(across(where(is.numeric), \(x) mean(x, na.rm = TRUE)))
  
  output$max_value <- renderText({
    max(data[[input$varval]], na.rm=TRUE)
  })
  output$min_value <- renderText({
    min(data[[input$varval]], na.rm=TRUE)
  })
  output$mean_value <- renderText({
    round(mean(data[[input$varval]], na.rm=TRUE),2)
  })
  
  output$val_text <- renderText({
    paste("Du valde:", input$varval)
  })
  
  
  # Välj bara numeriska kolumner
  numeric_vars <- names(data)[sapply(data, is.numeric)]
  # Uppdatera selectInput med numeriska kolumner
  updateSelectInput(session, "varval", choices = numeric_vars)
  
  output$variable <- renderText({
    print(input$varval)
  })
  
  output$distPlot <- renderPlot({
    req(input$varval)
    x <- data[[input$varval]]
    # generate bins based on input$bins from ui.R
    bins <- seq(min(x,na.rm = TRUE), max(x, na.rm = TRUE), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = '#D9A866', border = 'white',
         xlab = input$varval,
         main = paste('Histogram of ', input$varval))
  })
  
  output$boxPlot <- renderPlot({
    boxplot(data[[input$varval]]~data$matchday,
            data = data,
            xlab = "Säsong",
            ylab = input$varval)
  })
  updateSelectInput(session, "player", choices = aggregerad$name)
  
  output$radarplot <- renderPlot({
    req(input$player)
    player_row <- aggregerad[aggregerad$name == input$player, ]
    player_stats <- player_row[ , !(names(player_row) %in% c("name"))]
    
    # Max- och minrader för att radarplotten ska fungera
    max_values <- apply(aggregerad[ , !(names(aggregerad) %in% c("name"))], 2, max)
    min_values <- apply(aggregerad[ , !(names(aggregerad) %in% c("name"))], 2, min)
    radar_data <- rbind(max_values, min_values, player_stats)
    
    radarchart(radar_data,
               pcol = rgb(0.2, 0.5, 0.5, 0.9),
               pfcol = rgb(0.2, 0.5, 0.5, 0.5),
               plwd = 2,
               cglcol = "grey",
               caxislabels = seq(0, max(max_values), 5),
               axislabcol = "grey",
               cglwd = 0.8)
  })
  
  
  output$img <- renderImage({
    list(
      src = "www/goalkeeper.jpg",
      width = 600,
      height = 400,
      alt = "Goalkeeper"
    )
  }, deleteFile = FALSE)
  output$img_author1 <- renderImage({
    list(
      src = "www/vietr933.JPG",
      width = 40,
      height = 40,
      alt = "Goalkeeper",
      style = "border-radius: 50%"
    )
  }, deleteFile = FALSE)
  output$img_author2 <- renderImage({
    list(
      src = "www/duyph635.jpg",
      width = 40,
      height = 40,
      alt = "Goalkeeper",
      style = "border-radius: 50%"
    )
  }, deleteFile = FALSE)
}
