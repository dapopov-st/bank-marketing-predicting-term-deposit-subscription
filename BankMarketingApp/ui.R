library(shiny)
library(ggplot2)
library(shinyWidgets)
title <- tags$a(tags$img(src="https://upload.wikimedia.org/wikipedia/commons/5/5c/Euro_symbol_black.svg", height='30', width='30'), 'Deposit Helper', style = "color: white;")

dataset <- diamonds

ui <- fluidPage(
  dashboardHeader(title = title,titleWidth = 250),

  #hr(),

  setBackgroundImage(
    src = "https://upload.wikimedia.org/wikipedia/commons/2/2f/Euro-dynamic-clay.png"
  ),
  fluidRow(
    column(1,
           h2("Deposit Helper"),
           # sliderInput('sampleSize', 'Sample Size', 
           #             min=1, max=nrow(dataset), value=min(1000, nrow(dataset)), 
           #             step=500, round=0),
           br(),
           checkboxInput('conservative', 'Conservative'),
           checkboxInput('daring', 'Daring')
    ),
    column(2, offset = 1,
           selectInput('x', 'X', names(dataset)),
           selectInput('y', 'Y', names(dataset), names(dataset)[[2]]),
           selectInput('color', 'Color', c('None', names(dataset))),
           selectInput('x', 'X', names(dataset)),
           selectInput('y', 'Y', names(dataset), names(dataset)[[2]]),
           selectInput('color', 'Color', c('None', names(dataset))),
           selectInput('color', 'Color', c('None', names(dataset)))
    ),
    column(2,offset=.75,
           selectInput('facet_row', 'Facet Row', c(None='.', names(dataset))),
           selectInput('facet_col', 'Facet Column', c(None='.', names(dataset))),
           selectInput('facet_row', 'Facet Row', c(None='.', names(dataset))),
           selectInput('facet_col', 'Facet Column', c(None='.', names(dataset)))
    ),
    # column(2, offset = 1,
    #        h5("LT Deposit Helper")),
    # column(4, offset = 8,
    #        h5("LT Deposit Helper")),
    column(2, offset = .75,
           selectInput('x', 'X', names(dataset)),
           selectInput('y', 'Y', names(dataset), names(dataset)[[2]]),
           selectInput('color', 'Color', c('None', names(dataset))),
           selectInput('color', 'Color', c('None', names(dataset)))
    ),
    column(2,offset=.75,
           selectInput('facet_row', 'Facet Row', c(None='.', names(dataset))),
           selectInput('facet_col', 'Facet Column', c(None='.', names(dataset))),
           selectInput('facet_row', 'Facet Row', c(None='.', names(dataset))),
           selectInput('facet_col', 'Facet Column', c(None='.', names(dataset))),
           selectInput('facet_row', 'Facet Row', c(None='.', names(dataset)))    )
  ),
  fluidRow(
    column(1,offset=8,
           h2("Recommendation"),
           # sliderInput('sampleSize', 'Sample Size', 
           #             min=1, max=nrow(dataset), value=min(1000, nrow(dataset)), 
           #             step=500, round=0),
           br(),
           checkboxInput('conservative', 'Conservative'),
           checkboxInput('daring', 'Daring')
    ),
  )
)









# 
# 
# 
# #flights <- read.csv(file = "./flights14.csv")
# fluidPage(
#   titlePanel("NYC Flights 2014"),
#   sidebarLayout(
#     sidebarPanel(
#       selectizeInput(inputId = "origin",
#                      label = "Departure airport",
#                      choices = unique(flights$origin)),
#       selectizeInput(inputId = "dest",
#                      label = "Arrival airport",
#                      choices = unique(flights$dest)),
#       selectizeInput(inputId = "origin",
#                      label = "Departure airport",
#                      choices = unique(flights$origin)),
#       selectizeInput(inputId = "dest",
#                      label = "Arrival airport",
#                      choices = unique(flights$dest)),
#       selectizeInput(inputId = "origin",
#                      label = "Departure airport",
#                      choices = unique(flights$origin)),
#       selectizeInput(inputId = "dest",
#                      label = "Arrival airport",
#                      choices = unique(flights$dest)),
#       selectizeInput(inputId = "origin",
#                      label = "Departure airport",
#                      choices = unique(flights$origin)),
#       selectizeInput(inputId = "dest",
#                      label = "Arrival airport",
#                      choices = unique(flights$dest)),
#       selectizeInput(inputId = "origin",
#                      label = "Departure airport",
#                      choices = unique(flights$origin)),
#       selectizeInput(inputId = "dest",
#                      label = "Arrival airport",
#                      choices = unique(flights$dest)),
#       selectizeInput(inputId = "origin",
#                      label = "Departure airport",
#                      choices = unique(flights$origin)),
#       selectizeInput(inputId = "dest",
#                      label = "Arrival airport",
#                      choices = unique(flights$dest)),
#       selectizeInput(inputId = "origin",
#                      label = "Departure airport",
#                      choices = unique(flights$origin)),
#       selectizeInput(inputId = "dest",
#                      label = "Arrival airport",
#                      choices = unique(flights$dest)),
#       selectizeInput(inputId = "origin",
#                      label = "Departure airport",
#                      choices = unique(flights$origin)),
#       selectizeInput(inputId = "dest",
#                      label = "Arrival airport",
#                      choices = unique(flights$dest)),
#       selectizeInput(inputId = "origin",
#                      label = "Departure airport",
#                      choices = unique(flights$origin)),
#       selectizeInput(inputId = "dest",
#                      label = "Arrival airport",
#                      choices = unique(flights$dest)),
#       selectizeInput(inputId = "origin",
#                      label = "Departure airport",
#                      choices = unique(flights$origin)),
#       selectizeInput(inputId = "dest",
#                      label = "Arrival airport",
#                      choices = unique(flights$dest)),
#       selectizeInput(inputId = "origin",
#                      label = "Departure airport",
#                      choices = unique(flights$origin)),
#       selectizeInput(inputId = "dest",
#                      label = "Arrival airport",
#                      choices = unique(flights$dest)),
#       selectizeInput(inputId = "origin",
#                      label = "Departure airport",
#                      choices = unique(flights$origin)),
#       selectizeInput(inputId = "dest",
#                      label = "Arrival airport",
#                      choices = unique(flights$dest))
#     ),
#     mainPanel(plotOutput("count"))
#   )
# )