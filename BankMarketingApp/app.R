#Special thanks to the Data Science Professor for outlining this approach to
#structuring an ML app in the video below
#https://www.youtube.com/watch?v=ceg7MMQNln8&ab_channel=DataProfessor
library(shiny)
library(data.table)
library(randomForest)
library(caret)
library(shinyWidgets)

# Read in the RF model
model<-readRDS('model2.rds')


# Testing set
TestSet <- read.csv("testing.csv", header = TRUE)
TestSet <- TestSet[,-1]


title <- tags$a(tags$img(src="https://upload.wikimedia.org/wikipedia/commons/5/5c/Euro_symbol_black.svg", height='50', width='50'), 'Deposit Helper', style = "color: white;")


####################################
# User interface                   #
####################################

ui <- pageWithSidebar(

  # Page header
  #headerPanel('Deposit Predictor'),
  #headerPanel(title = title,titleWidth = 150),
  
  dashboardHeader(title = title,titleWidth = 1250),
  # Input values
  sidebarPanel(
    HTML("<h3>Input parameters</h4>"),
    sliderInput("age", label = "Age", value = 18,
                min = min(TestSet$age),
                max = max(TestSet$age)
    ),
    sliderTextInput("job","Occupation" , 
                    choices = c("admin.", "blue-collar", "entrepreneur", "housemaid","management","retired","self-employed","services","student","technician","unemployed","unknown"), 
                                selected = c("admin."), #if you want any default values 
                                animate = FALSE, grid = FALSE, 
                                hide_min_max = FALSE, from_fixed = FALSE,
                                to_fixed = FALSE, from_min = NULL, from_max = NULL, to_min = NULL,
                                to_max = NULL, force_edges = FALSE, width = NULL, pre = NULL,
                                post = NULL, dragRange = TRUE),
    sliderTextInput("marital","Marital Status" , 
                    choices = c("divorced", "single", "married", "unknown"), 
                    selected = c("divorced"), #if you want any default values 
                    animate = FALSE, grid = FALSE, 
                    hide_min_max = FALSE, from_fixed = FALSE,
                    to_fixed = FALSE, from_min = NULL, from_max = NULL, to_min = NULL,
                    to_max = NULL, force_edges = FALSE, width = NULL, pre = NULL,
                    post = NULL, dragRange = TRUE),
    sliderTextInput("education","Education" , 
                    choices = c("basic.4y", "basic.6y", "basic.9y", "high.school","illiterate","professional.course","university.degree","unknown"), 
                    selected = c("basic.4y"), #if you want any default values 
                    animate = FALSE, grid = FALSE, 
                    hide_min_max = FALSE, from_fixed = FALSE,
                    to_fixed = FALSE, from_min = NULL, from_max = NULL, to_min = NULL,
                    to_max = NULL, force_edges = FALSE, width = NULL, pre = NULL,
                    post = NULL, dragRange = TRUE),
    sliderTextInput("default","Default" , 
                    choices = c("no","unknown"), 
                    selected = c("no"), #if you want any default values 
                    animate = FALSE, grid = FALSE, 
                    hide_min_max = FALSE, from_fixed = FALSE,
                    to_fixed = FALSE, from_min = NULL, from_max = NULL, to_min = NULL,
                    to_max = NULL, force_edges = FALSE, width = NULL, pre = NULL,
                    post = NULL, dragRange = TRUE),
    sliderTextInput("housing","Housing" , 
                    choices = c("no","unknown","yes"), 
                    selected = c("no"), #if you want any default values 
                    animate = FALSE, grid = FALSE, 
                    hide_min_max = FALSE, from_fixed = FALSE,
                    to_fixed = FALSE, from_min = NULL, from_max = NULL, to_min = NULL,
                    to_max = NULL, force_edges = FALSE, width = NULL, pre = NULL,
                    post = NULL, dragRange = TRUE),
    sliderTextInput("loan","Loan" , 
                    choices = c("no","unknown","yes"), 
                    selected = c("no"), #if you want any default values 
                    animate = FALSE, grid = FALSE, 
                    hide_min_max = FALSE, from_fixed = FALSE,
                    to_fixed = FALSE, from_min = NULL, from_max = NULL, to_min = NULL,
                    to_max = NULL, force_edges = FALSE, width = NULL, pre = NULL,
                    post = NULL, dragRange = TRUE),
    HTML("<h3>Contact Attributes</h4>"),
    sliderTextInput("contact","Contact (cell or tel.)" , 
                    choices = c("cellular","telephone"), 
                    selected = c("cellular"), #if you want any default values 
                    animate = FALSE, grid = FALSE, 
                    hide_min_max = FALSE, from_fixed = FALSE,
                    to_fixed = FALSE, from_min = NULL, from_max = NULL, to_min = NULL,
                    to_max = NULL, force_edges = FALSE, width = NULL, pre = NULL,
                    post = NULL, dragRange = TRUE),
   
    sliderTextInput("month","Month of contact" , 
                    choices = c("mar","apr","may","jun","jul","aug","sep","oct","nov","dec"), 
                    selected = c("mar"), #if you want any default values 
                    animate = FALSE, grid = FALSE, 
                    hide_min_max = FALSE, from_fixed = FALSE,
                    to_fixed = FALSE, from_min = NULL, from_max = NULL, to_min = NULL,
                    to_max = NULL, force_edges = FALSE, width = NULL, pre = NULL,
                    post = NULL, dragRange = TRUE),
    
    sliderTextInput("day_of_week","Day of Week" , 
                    choices = c("mon","tue","wed","thu","fri"), 
                    selected = c("mon"), #if you want any default values 
                    animate = FALSE, grid = FALSE, 
                    hide_min_max = FALSE, from_fixed = FALSE,
                    to_fixed = FALSE, from_min = NULL, from_max = NULL, to_min = NULL,
                    to_max = NULL, force_edges = FALSE, width = NULL, pre = NULL,
                    post = NULL, dragRange = TRUE),
    HTML("<h3>Other Campaign Attributes</h4>"),
    sliderInput("campaign", label = "Number of previous contacts during campaing", value = 1,
                min = min(TestSet$campaign),
                max = max(TestSet$campaign)),
    
    sliderInput("pdays", label = "Number of days since last contact", value = 5,
                min = min(TestSet$pdays),
                max = max(TestSet$pdays)),

    sliderInput("previous", label = "Number of previous contacts before campaing", value = 0.2,
                min = min(TestSet$previous),
                max = max(TestSet$previous)),
 
    sliderTextInput("poutcome","Outcome of the previous campaign" , 
                    choices = c("failure","nonexistent","success"), 
                    selected = c("failure"), #if you want any default values 
                    animate = FALSE, grid = FALSE, 
                    hide_min_max = FALSE, from_fixed = FALSE,
                    to_fixed = FALSE, from_min = NULL, from_max = NULL, to_min = NULL,
                    to_max = NULL, force_edges = FALSE, width = NULL, pre = NULL,
                    post = NULL, dragRange = TRUE),
    HTML("<h3>Social and economic context attributes</h4>"),
    sliderInput("emp.var.rate", label = "Employment variation rate ", value = 1.4,
                min = min(TestSet$emp.var.rate),
                max = max(TestSet$emp.var.rate)),
    sliderInput("cons.price.idx", label = "Consumer price index", value = 94.215,
                min = min(TestSet$cons.price.idx),
                max = max(TestSet$cons.price.idx)),
    sliderInput("cons.conf.idx", label = "Consumer confidence index", value = -40.0,
                min = min(TestSet$cons.conf.idx),
                max = max(TestSet$cons.conf.idx)),
    sliderInput("euribor3m", label = "Euribor 3 month rate - daily indicator", value = 0.2,
                min = min(TestSet$euribor3m),
                max = max(TestSet$euribor3m)),
    sliderInput("nr.employed", label = "Number of employees", value = 0.2,
                min = min(TestSet$nr.employed),
                max = max(TestSet$nr.employed)),
    
    
    actionButton("submitbutton", "Submit", class = "btn btn-primary")
  ),
  
  mainPanel(
    
    setBackgroundImage(
      src = "https://upload.wikimedia.org/wikipedia/commons/2/2f/Euro-dynamic-clay.png"
    ),
    tags$label(h1('Status/Output')), # Status/Output Text Box
    verbatimTextOutput('contents'),
    tableOutput('tabledata') # Prediction results table
    
  )
)

####################################
# Server                           #
####################################

server<- function(input, output, session) {
  
  # Input Data
  datasetInput <- reactive({  
    
    df <- data.frame(
      Name = c("age","job", "marital","education","default","housing","loan",
               "contact","month","day_of_week","campaign","pdays","previous",
               "poutcome","emp.var.rate","cons.price.idx","cons.conf.idx",
                "euribor3m","nr.employed"),
      Value = as.character(c(input$age,
                             input$job,
                             input$marital,
                             input$education,
                             input$default,
                             input$housing,
                             input$loan,
                             input$contact,
                             input$month,
                             input$day_of_week,
                             input$campaign,
                             input$pdays,
                             input$previous,
                             input$poutcome,
                             input$emp.var.rate,
                             input$cons.price.idx,
                             input$cons.conf.idx,
                             input$euribor3m,
                             input$nr.employed)),
      stringsAsFactors = FALSE)
    
    Species <- 0
    df <- rbind(df, Species)
    input <- transpose(df)
    write.table(input,"input.csv", sep=",", quote = FALSE, row.names = FALSE, col.names = FALSE)
    
    test <- read.csv(paste("input", ".csv", sep=""), header = TRUE)
    
    Output <- data.frame(Prediction=predict(model,test), round(predict(model,test,type="prob"), 3))
    print(Output)
    
  })
  
  # Status/Output Text Box
  output$contents <- renderPrint({
    if (input$submitbutton>0) { 
      isolate("Calculation complete.") 
    } else {
      return("Server is ready for calculation.")
    }
  })
  
  # Prediction results table
  output$tabledata <- renderTable({
    if (input$submitbutton>0) { 
      isolate(datasetInput()) 
    } 
  })
  
}

####################################
# Create the shiny app             #
####################################
shinyApp(ui = ui, server = server)