library(shiny)
library(ggplot2)
library(plotly)
shinyUI(fluidPage(
  titlePanel("Diamond Prices"),
  fluidRow(column(12,p("Diamond prices are influenced by multiple factors. The size (in carats) of the diamond is the most obvious contributor to the price, but cut, color, and clarity also influence the price of diamonds."),
                  p("The plot below shows the relationship between the size and price of a selction of diamonds, separated out across another variable (for example cut). You can use this plot to investigate the relationship between size, proce, and other variables. Using the drop-down menu you can select the variable to separate diamonds by."),
                  p("Using the slider you can choose the number of diamonds to sample (note that sampling more diamonds will result in better estimates but longer processing time)."),
                  p("Finally, you can show the linear models derived from your sample. Note how the error of the model estimates reduces as the sample is increased.")),
           column(3,selectInput("separate",
                                "Separate out by",
                                c("Cut",
                                  "Color",
                                  "Clarity")
                                )
                  ),
           column(3, sliderInput("n", "Number of Samples", 100, 50000, 1000)),
           column(3, checkboxInput("lm", "Show Linear Model", FALSE))),
    fluidRow(column(10, offset = 1,
      plotOutput("plot"))),
  uiOutput("conditional")
  )
)
