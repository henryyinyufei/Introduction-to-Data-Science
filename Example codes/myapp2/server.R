

function(input, output, session) {

  # Combine the selected variables into a new data frame
  selectedData <- reactive({
    iris[, input$xcol]
  })



  output$plot1 <- renderPlot({
    palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
      "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))

    par(mar = c(5.1, 4.1, 0, 1))
    plot(density(selectedData()))
  })

}
