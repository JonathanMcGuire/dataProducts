library(shiny)
library(ggplot2)
library(plotly)
library(dplyr)
library(broom)
shinyServer(function(input, output) {
  set.seed(999)
  proper=function(x) paste0(toupper(substr(x, 1, 1)), tolower(substring(x, 2)))
  names(diamonds) <- proper(names(diamonds))
  diamonds$`Price ($Thousands)` <- diamonds$Price/1000
  output$plot <- renderPlot({
    p <- ggplot(data = diamonds[sample(nrow(diamonds), input$n), ], 
                aes(x = Carat, y = `Price ($Thousands)`)) +
      geom_point(size = 2, alpha = .5)+
      theme_bw()
    if(input$lm == T){
        p <- p + geom_smooth(method = "lm", size = 2)
        }
    facet <- paste('. ~', input$separate)
    p <- p + facet_grid(facet)
    p
  })
  output$mytable <- renderDataTable({
    dfCut <- diamonds[sample(nrow(diamonds), input$n), ] %>%
      group_by_(input$separate) %>%
      do(fits = lm(Price ~ Carat, data = .))
  dfCoef = tidy(dfCut, fits)
  dfCoef[,3:5] <- round(dfCoef[,3:5], 2)
  subset(dfCoef, term != "(Intercept)")[,-2]
  })
  output$conditional <- renderUI({
    if(input$lm == T){
      fluidRow(
            column(10, offset = 1,
                          dataTableOutput('mytable')))
    }
  })
})
