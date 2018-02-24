#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# UI side of the app
shinyUI(fluidPage(
        
        tabsetPanel(
                tabPanel("App",
                        # Application title
                        titlePanel("Word Prediction App"),
                        
                        # Sidebar 
                        sidebarLayout(
                                sidebarPanel(
                                        textInput("text",
                                                  "Your text:",
                                                  value="",
                                                  placeholder="Enter your text here"
                                        ),
                                        actionButton("goButton", "Submit!"),
                                        h5("Numbers of words predicted from this app:"),
                                        textOutput("wordcount")
                                ),
                                
                                # word predicted
                                mainPanel(
                                        h3("Predicted word"),
                                        textOutput("word1")
                                        
                                        
                                        
                                )
                        )
                ),
                #Documentation
                tabPanel("Doc",
                         titlePanel("Documentation"),
                         sidebarLayout(
                                 sidebarPanel(
                                         h4("Word prediction algorithm")
                                 ),
                                 
                                 mainPanel(
                                         h3("Documentation"),
                                         p("We created a word prediction algorithm for Coursera
                                           Data Science Capstone, based on data Swiftkey provided."),
                                         p("More information about the model can be find on Rpubs."),
                                         a("My Rpubs", href="http://rpubs.com/yobid", target="_blank")
                                         
                                         
                                         
                                 )
                         )
                         )
        )
))
