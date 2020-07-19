library(shiny)

#t draws a histogram
shinyUI(fluidPage(

    # Application title
    headerPanel("Titanic Passenger Survival Probability"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            selectInput("Class",
                        "Select Class of Passenger:",
                        c("1st", "2nd", "3rd", "Crew")),
            selectInput("Sex",
                        "Select Sex of Passenger:",
                        c("Male", "Female")),
            selectInput("Age",
                        "Select Age of Passenger:",
                        c("Child", "Adult")),
            submitButton("Submit"),
            br()
            ),

        # Show a plot of the generated distribution
        mainPanel(
            # Print survival probability for the chosen combination
            h3("The survival probability of a passenger with chosen attributes is: "),
            h3(textOutput("prediction")),
            # Plot survival probability comparison for each variable, selected value 
            # is highlighted
            plotOutput("cPlot"),
            plotOutput("sPlot"),
            plotOutput("aPlot")
        )
    )
))
