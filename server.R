library(shiny)
library(ggplot2)
library(shinydashboard)
library(grid)
library(markdown)
library(ggExtra)

server <- function(input, output) {

 ### Saving data:
 Rawdata <- reactive({
  slope <- input$slope
  SD <- input$SD
  sample <- input$sample
  x <- round(1:sample + rnorm(n = sample, mean = 1, sd = 1), digits = 2)
  y <- round(slope * (x) + rnorm(n = sample, mean = 3, sd = SD ), digits = 2)
  mod <- lm(y ~ x, data.frame(y,x))
  ypred <- predict(mod)
  Rawdata <- data.frame(y, x, ypred)
 })

 SSdata <- reactive({
  dat <- Rawdata()
  Y <- mean(dat$y)
  mod <- lm(y ~ x, dat)
  ypred <- predict(mod)
  dat$ypred <- ypred
  SST <- sum((dat$y - Y)^2)
  SSE <- round(sum((dat$y - ypred)^2), digits = 5)
  SSA <- SST - SSE

  SSQ <- data.frame(SS = c("Total","Regression","Error"),
                    value = as.numeric(c(SST, SSA, SSE)/SST)*100)
  SSQ$SS <- factor(SSQ$SS, as.character(SSQ$SS))
  SSdata <- data.frame(SS = factor(SSQ$SS, as.character(SSQ$SS)),
                    value = as.numeric(c(SST, SSA, SSE)/SST)*100)

 })


 ### First output "graphs"
 output$total <- renderPlot({
  cols <- c("#619CFF", "#00BA38", "#F8766D")
  ggplot(Rawdata(), aes(x=x,y=y))+
   geom_point(size=3) +
   geom_segment(xend = Rawdata()[,2], yend = mean(Rawdata()[,1]),
                colour = "#619CFF")+
   geom_hline(yintercept = mean(Rawdata()[,1]))+
   theme(axis.title = element_text(size = 20),
         axis.text  = element_text(size = 18),
         panel.background=element_rect(fill="white",colour="black"))+
   ggtitle("SS total")
 })

 ### First output "graphs"
 output$regression <- renderPlot({
  cols <- c("#619CFF", "#00BA38", "#F8766D")
  ggplot(Rawdata(), aes(x=x,y=y))+
   geom_point(alpha=0)+
   geom_smooth(method= "lm", se = F, colour = "black")+
   geom_hline(yintercept = mean(Rawdata()[,1]))+
   geom_segment(aes(x=x,y=ypred), xend = Rawdata()[,2],
                yend = mean(Rawdata()[,1]),
                colour = "#00BA38")+
   theme(axis.title = element_text(size = 20),
         axis.text  = element_text(size = 18),
         panel.background=element_rect(fill="white",colour="black"))+
   ggtitle("SS regression")

 })

 ### First output "graphs"
 output$error <- renderPlot({
  cols <- c("#619CFF", "#00BA38", "#F8766D")
  ggplot(Rawdata(), aes(x = x, y = y))+
   geom_point(size=3) + geom_smooth(method= "lm", se = F,
                                    colour = "black")+
   geom_segment(xend = Rawdata()[,2], yend = Rawdata()[,3],
                colour = "#F8766D")+
   theme(axis.title = element_text(size = 20),
         axis.text  = element_text(size = 18),
         panel.background=element_rect(fill="white",colour="black"))+
   ggtitle("SS error")

 })

 output$variance <- renderPlot({
  cols <- c("#619CFF", "#00BA38", "#F8766D")
  ggplot(SSdata(), aes(y = value, x = SS, fill = SS))+
   geom_bar(stat = "identity")+
   scale_fill_manual(values = cols)+
   theme(axis.title = element_text(size = 20),
         axis.text.x  = element_text(size = 0),
         axis.text.y  = element_text(size = 16),
         panel.background=element_rect(fill="white",colour="black")) +
   ylab("% of variance")+
   xlab("Sums of Squares")

 })


 output$reg <- renderPlot({
  ggplot(Rawdata(), aes(y = y, x = x))+
   geom_point(size = 3, colour = "blue", alpha = .5)+
   geom_smooth(method = "lm")+
   theme(axis.title = element_text(size = 20),
         axis.text  = element_text(size = 16),
         panel.background=element_rect(fill="white",colour="black")) +
   ylab("Y")+
   xlab("X")

 })

 ### Second output "anova"
 output$anova <- renderTable({
  anova(lm(y ~ x, Rawdata()))
 })

 ### Second output "SS"
 output$summary <- renderTable({
  summary(lm(y ~ x, Rawdata()))

 })

 output$data <- renderDataTable(
  Rawdata()[c(1,2)], options = list(
  searchable = FALSE, searching = FALSE, pageLength = 15))

 output$histogram <- renderPlot({
 d1 <- ggplot(Rawdata(), aes(y = y, x = x))+
  geom_point(size = 3, colour = "blue", alpha = .5)+
  theme(axis.title = element_text(size = 20),
        axis.text  = element_text(size = 16),
        panel.background=element_rect(fill="white",colour="black")) +
  ylab("Y")+
  xlab("X")
  ggMarginal(
  d1,
  type = 'histogram')
})

}
