library(shiny)
function(input, output, session) {
  
  # Reactive map
  filtered <- reactive({
    df = merged_agg_allYears_shpfile2[!is.na(merged_agg_allYears_shpfile2@data$Year),]
    df = df[df@data$Year == input$Year,]
    df
  })  
  # Reactive barplot1
  filteredPlot <- reactive({
    dfplot = wideAgg_allYears[!is.na(wideAgg_allYears$Year),] 
    dfplot = dfplot[dfplot$Year == input$Year2,] 
    dfplot
  })
  
  # Reactive barplot2
  filteredPlot2 <- reactive({
    dfplot2 = gathered_percentage_stage_allFoodGroups[!is.na(gathered_percentage_stage_allFoodGroups$FoodGroup),]
    dfplot2 = dfplot2[dfplot2$FoodGroup == input$FoodGroup,]
    dfplot2
  })
  
  # Output map        
  output$my_map <- renderLeaflet({
    df <- filtered()
    df$label <- paste("<strong>Country:</strong>",df$NAME, "<br>",
                      "<strong>Cereals Production(kg/capita):</strong>", df$AggProduction, "<br>",
                      "<strong>Cereals Supply(kg/capita):</strong> ", df$AggFinalSupply, "<br>",
                      "<strong>Dairy Production(kg/capita): </strong>", df$AggProduction.1, "<br>",
                      "<strong>Dairy Supply(kg/capita): </strong>", df$AggFinalSupply.1, "<br>",
                      "<strong>Seafood Production(kg/capita): </strong>", df$AggProduction.2, "<br>",
                      "<strong>Seafood Supply(kg/capita):</strong> ",df$AggFinalSupply.2, "<br>",
                      "<strong>Fruits and Vegetables Production(kg/capita): </strong> ",df$AggProduction.3, "<br>",
                      "<strong>Fruits and Vegetables Supply(kg/capita): </strong>",df$AggFinalSupply.3, "<br>",
                      "<strong>Meat Production(kg/capita): </strong>",df$AggProduction.4, "<br>",
                      "<strong>Meat Supply(kg/capita): </strong>",df$AggFinalSupply.4, "<br>",
                      "<strong>Oilseeds and Pulses Production(kg/capita): </strong>",df$AggProduction.5, "<br>",
                      "<strong>Oilseeds and Pulses Supply(kg/capita):</strong> ",df$AggFinalSupply.5, "<br>")
                      
                      
   leaflet(data=df) %>% 
      addTiles() %>%
      setView(lat=10, lng=0, zoom=2) %>%
      addPolygons(fillColor = 'Gray',
                  highlight = highlightOptions(weight = 1,
                                               color = "red",
                                               fillOpacity = 0.7,
                                               bringToFront=TRUE),
                                               label=lapply(df$label, HTML))
    
  })
  
  # Output barplot1: AggProd vs. AggSupply
  output$my_prod_vs_supply <- renderPlot({
    dfplot <- filteredPlot() %>%
      ggplot(., aes(x=FoodGroup)) +
      geom_bar(aes(y=AggProduction, fill=FoodGroup), stat="identity", position="dodge") +
      geom_point(aes(y=AggFinalSupply)) +
      ylab("AggProduc vs. AggSupply (kg/capita)") +
      #theme(axis.text.x=element_blank) + 
      facet_wrap(~grpRegion)
    dfplot
  })
 
   # Output barplot2: Percentage Wasted at Every Stage
 
    output$my_foodgroup <- renderPlot({
      dfplot2 <- filteredPlot2() %>%
        ggplot(., aes(x=Region, y=Percentage_by_Weight, 
                      fill=fct_relevel(Stage, 
                                       "Consumption","Distribution..Supermarket_Retail", "Processing_and_Packaging",  
                                       "Postharvest_Handling_and_Storage","Agricultural_Production"), 
                                        labels=FALSE)) +
        geom_bar(stat='identity') +
        ylab("Weight Percentages of Waste at Each Step") +
        theme(axis.text.x=element_text(angle=90)) 
      dfplot2    
      })
    
}
    
    


























