library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)
library(datasets)

logit2prob <- function(logit){
    odds <- exp(logit)
    prob <- odds / (1 + odds)
    return(prob)
}

# Convert frequency data into long format
Titanic1 <- data.frame(Titanic) %>%
    rowwise() %>%
    mutate(Freq = list(seq(1, Freq))) %>%
    ungroup() %>%
    unnest(cols=c(Freq)) %>%
    select(-Freq)


# Model with glm
mod <- glm(Survived~Class+Sex+Age, data=Titanic1, family="binomial")
pred <- predict(mod, Titanic1)
Titanic1$Pred <- logit2prob(pred)

shinyServer(
    function(input, output){
    output$prediction <- renderText(
        logit2prob(predict(mod, data.frame(Class=input$Class, 
                                           Sex=input$Sex, 
                                           Age=input$Age))))
    
    output$cPlot <- renderPlot({
        ggplot(Titanic1, aes(x=Pred, fill=Class, alpha = Class == input$Class)) +
            geom_density() + theme_bw() +
            scale_alpha_manual(values=c(0.5, 1), guide=FALSE) + 
            labs(title="Survival Probability Comparison between Different Classes") +
            xlab("Probability")})
    
    output$sPlot <- renderPlot({
        ggplot(Titanic1, aes(x=Pred, fill=Sex, alpha = Sex == input$Sex)) +
            geom_density() + theme_bw() +
            scale_alpha_manual(values=c(0.5, 1), guide=FALSE) + 
            labs(title="Survival Probability Comparison between Female and Male Passengers") +
            xlab("Probability")})
    
    output$aPlot <- renderPlot({
        ggplot(Titanic1, aes(x=Pred, fill=Age, alpha = Age == input$Age)) +
            geom_density() + theme_bw() +
            scale_alpha_manual(values=c(0.5, 1), guide=FALSE) + 
            labs(title="Survival Probability Comparison between Different Age Groups") +
            xlab("Probability")})
    }
)
