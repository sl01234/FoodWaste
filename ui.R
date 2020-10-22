library(shiny)
fluidPage(
  
  titlePanel("Global Food Waste"),
  sidebarLayout(
    
# Sidebar Panel
    sidebarPanel(
          selectInput(inputId = "Year",
                  label = "Select Year for Map Summary Statistics",
                  choices = c("2014", "2015", "2016", "2017")),
          
          selectInput(inputId = "Year2",
                  label = "Select Year for AggProduc vs. AggSupply (then click 2nd tab)",
                  choices = c("2014", "2015", "2016", "2017")),
          
           selectInput(inputId = "FoodGroup",
              label = "Select Food Group for Waste % (then click 3rd tab)",
              choices = c("Cereals", "Dairy_and_Eggs", "Fish_and_Seafood", "Fruits_and_Vegetables", "Meat", "Oilseeds_and_Pulses"))),
  
# Main Panel 
    mainPanel(
             tabsetPanel(type="tab",
                         tabPanel("Map", leafletOutput("my_map")),
                         tabPanel("AggProd vs. AggSupply", plotOutput("my_prod_vs_supply")),
                         tabPanel("Stage of Waste", plotOutput("my_foodgroup"))
                   
       
     )
  ))
         
  )

