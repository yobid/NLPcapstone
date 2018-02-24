#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(tm)
library(quanteda)
library(data.table)

#Server side app
shinyServer(function(input, output) {
        
        freq1 <- fread("freq1.csv")
        freq2 <- fread("freq2.csv")
        freq3 <- fread("freq3.csv")
        freq4 <- fread("freq4.csv")
        freq5 <- fread("freq5.csv")
        
        predWord <- eventReactive(input$goButton, {
                #cleaning input data
                load("profanity.RData")
                text <- iconv(input$text, "latin1", "ASCII", sub="")
                text <- VectorSource(text)
                text <- VCorpus(text)
                text <- tm_map(text, content_transformer(tolower))
                text <- tm_map (text, removePunctuation)
                text <- tm_map(text, removeWords, profanity)
                text <- tm_map(text, removeNumbers)
                text <- tm_map(text, stripWhitespace)
                text <- corpus(text)
                text <- text$documents$texts[1]
                text <- unlist(strsplit(text, split=" "))
                #prediction model
                nwords <- length(text)
                message <- NULL
                if (nwords>=4) {
                        inp1 <- paste("\\<", text[(nwords-3)], "\\>", sep="") 
                        logic <- grepl(inp1, freq5$term1)
                        result <- freq5[logic,] 
                        inp2 <- paste("\\<", text[(nwords-2)], "\\>", sep="")  
                        logic2 <- grepl(inp2, result$term2)
                        result2 <- result[logic2,] 
                        inp3 <- paste("\\<", text[(nwords-1)], "\\>", sep="")
                        logic3 <- grepl(inp3, result2$term3)
                        result3 <- result2[logic3,] 
                        inp4 <- paste("\\<", text[(nwords)], "\\>", sep="")
                        logic4 <- grepl(inp4, result3$term4)
                        result4 <- result3[logic4,] 
                        if (nrow(result4)==0) {
                                nwords <- 3
                        }
                        else {
                                message <- result4$term5[1]   
                        }
                }
                if (nwords==3) {
                        
                        inp1 <- paste("\\<", text[(nwords-2)], "\\>", sep="")        
                        logic <- grepl(inp1, freq4$term1)
                        result <- freq4[logic,] 
                        inp2 <- paste("\\<", text[(nwords-1)], "\\>", sep="")        
                        logic2 <- grepl(inp2, result$term2)
                        result2 <- result[logic2,] 
                        inp3 <- paste("\\<", text[(nwords)], "\\>", sep="")        
                        logic3 <- grepl(inp3, result2$term3)
                        result3 <- result2[logic3,] 
                        
                        if (nrow(result3)==0) {
                                nwords <- 2
                        }
                        else {
                                message <- result3$term4[1]  
                        }
                }
                
                if (nwords==2) {
                        
                        inp1 <- paste("\\<", text[(nwords-1)], "\\>", sep="")        
                        logic <- grepl(inp1, freq3$term1)
                        result <- freq3[logic,] 
                        inp2 <- paste("\\<", text[(nwords)], "\\>", sep="")        
                        logic2 <- grepl(inp2, result$term2)
                        result2 <- result[logic2,] 
                        
                        if (nrow(result2)==0) {
                                nwords <- 1       
                        }
                        else {
                                message <- result2$term3[1]   
                        }
                }
                
                if (nwords==1) {
                        
                        inp <- paste("\\<", text[nwords], "\\>", sep="")        
                        logic <- grepl(inp, freq2$term1)
                        result <- freq2[logic,]
                        
                        if (nrow(result)==0) {
                                message <- paste(freq1$term[1:3], sep=",")
                        }
                        else {
                                message <- result$term2[1]
                        }
                }
                return(message)
        })
        
        output$word1 <- renderText({
                predWord()
        })
        
        counter <- eventReactive(input$goButton, {
                load(file="count.RData")
                count <- count + 1
                save(count, file="count.RData")
                count
        })
        
        output$wordcount <- renderText({
                if (input$goButton == 0) {
                        load(file="count.RData")   
                        count
                }
                else {
                        counter()
                }
        })
})
