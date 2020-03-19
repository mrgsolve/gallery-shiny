library(shinydashboard)
library(shiny)
library(lattice)
library(shiny)
library(dplyr)
library(mrgsolve)

mod <- modlib("pk2")

dose <- selectizeInput(
  inputId="dose", "Dose", 
  choices = seq(0,1000,100), 
  selected = 300, multiple=TRUE
)

rate <- numericInput(
  inputId = "tinf", "Infusion duration",
  min = 0, max = 24, value = 0
)

ii <- selectizeInput(
  inputId="ii","Dose interval",
  choices=c(24,12)
)

total <- numericInput(
  inputId="days", "Dosing days", 
  min=1, max=28, value=10
)

cl <- sliderInput("cl", "CL", min = 0.1, max = 3,   value = 0.45)
v2 <- sliderInput("v2", "V2", min = 1,   max = 50,  value = 10)
q  <- sliderInput("q",  "Q",  min = 0.1, max = 8,   value = 0.5)
v3 <- sliderInput("v3", "V3", min = 10,  max = 300, value = 90)
ka <- sliderInput("ka", "KA", min = 0.5, max = 5,   value = 2)

logy <- checkboxInput("logy", "Log Y scale")
splot <- plotOutput("plot1")

dosing <- fluidRow(column(3,dose), column(3,ii),column(3,rate),column(3,total))
options <- fluidRow(column(3,logy), column(3,""))

body <- dashboardBody(splot,fluidPage(dosing,options))
side <- dashboardSidebar(cl,v2,q,v3,ka)
head <- dashboardHeader(title="PK Explorer")
ui <- dashboardPage(head,side,body,title="Model")

server <- shinyServer(function(input,output,session) {
  
  rev <- reactive({
    expand.ev(
      amt = as.numeric(input$dose), 
      ii = as.numeric(input$ii), 
      tinf = as.numeric(input$tinf),
      total = 24/as.numeric(input$ii)*as.integer(input$days)
    )  
  })
  
  sim <- reactive({
    mod <- param(
      mod, 
      CL = input$cl, 
      V2 = input$v2, 
      Q  = input$q,
      V3 = input$v3,
      KA = input$ka
    )
    end <- 24*(as.numeric(input$days) + 7)
    mrgsim_e(mod,events=rev(),delta=0.5,end=end,add=0.001)
  })
  
  output$plot1 <- renderPlot({
    plot(
      sim(),
      CP ~ time,
      scales=list(y=list(log=input$logy)), 
      xlab  = "Time (hr)"
      )    
  })
})

app <- shinyApp(ui,server)
runApp(app)
