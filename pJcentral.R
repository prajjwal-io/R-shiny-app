####################################
# Advanced Prajjwal Central Dashboard
####################################

# Load required packages
library(shiny)
library(shinydashboard)
library(shinythemes)
library(shinyWidgets)
library(DT)
library(plotly)
library(ggplot2)
library(dplyr)
library(tidyr)
library(readr)
library(lubridate)
library(shinycssloaders)
library(shinyjs)
library(waiter)
library(RColorBrewer)
library(colourpicker)
library(shinyWidgets)

# Define UI
ui <- fluidPage(
  # Use a modern theme
  theme = shinytheme("flatly"),
  # Include custom CSS
  tags$head(
    tags$style(HTML("
      .nav-tabs {
        margin-bottom: 20px;
      }
      .box {
        border-radius: 5px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
      }
      .profile-image {
        border-radius: 50%;
        border: 3px solid #3498db;
        margin-bottom: 15px;
      }
      .welcome-box {
        background-color: #f8f9fa;
        padding: 20px;
        border-radius: 5px;
        margin-bottom: 20px;
      }
      .dashboard-title {
        color: #2c3e50;
        font-weight: 400;
        border-bottom: 2px solid #3498db;
        padding-bottom: 10px;
      }
      .value-box {
        padding: 15px;
        border-radius: 5px;
        margin-bottom: 15px;
        color: white;
        text-align: center;
      }
      .value-box.primary {
        background-color: #3498db;
      }
      .value-box.success {
        background-color: #2ecc71;
      }
      .value-box.warning {
        background-color: #f39c12;
      }
      .value-box.danger {
        background-color: #e74c3c;
      }
      .footer {
        margin-top: 30px;
        padding: 20px;
        background-color: #2c3e50;
        color: white;
        text-align: center;
      }
    "))
  ),
  
  # Enable shinyjs
  useShinyjs(),
  
  # Initialize waiter
  use_waiter(),
  
  # Navbar structure
  navbarPage(
    title = div(
      img(src = "https://github.com/identicons/prajjwal.png", height = "30px", class = "d-inline-block align-top mr-2"),
      "Prajjwal Central"
    ),
    id = "navbar",
    
    # Welcome tab
    tabPanel(
      "Welcome",
      icon = icon("home"),
      
      # Welcome section with user greeting
      fluidRow(
        column(
          width = 12,
          div(
            class = "welcome-box",
            h1(class = "dashboard-title", "Welcome to Prajjwal Central"),
            p("Your comprehensive data science and analytics platform"),
            
            conditionalPanel(
              condition = "output.userLoggedIn != true",
              wellPanel(
                h3("Please introduce yourself"),
                fluidRow(
                  column(6, textInput("firstName", "First Name:", "", placeholder = "Enter your first name")),
                  column(6, textInput("lastName", "Last Name:", "", placeholder = "Enter your last name"))
                ),
                fluidRow(
                  column(12, textInput("email", "Email Address:", "", placeholder = "your.email@example.com"))
                ),
                fluidRow(
                  column(6, passwordInput("password", "Create Password:", "")),
                  column(6, passwordInput("confirmPassword", "Confirm Password:", ""))
                ),
                fluidRow(
                  column(6, selectInput("role", "Your Role:", 
                                        choices = c("Data Scientist", "Data Analyst", "Software Developer", 
                                                    "Student", "Researcher", "Other"))),
                  column(6, selectInput("interests", "Primary Interest:", 
                                        choices = c("Data Visualization", "Machine Learning", "Statistics", 
                                                    "Programming", "Business Analytics", "Other"),
                                        multiple = TRUE))
                ),
                actionButton("submitLogin", "Register / Login", class = "btn-primary btn-block",
                             icon = icon("sign-in-alt"))
              )
            ),
            
            conditionalPanel(
              condition = "output.userLoggedIn == true",
              wellPanel(
                h2(textOutput("welcomeUser")),
                p("We're glad to have you back! Here's a summary of your dashboard:"),
                br(),
                fluidRow(
                  column(3, 
                         div(class = "value-box primary",
                             h3("5"),
                             p("Projects")
                         )),
                  column(3, 
                         div(class = "value-box success",
                             h3("12"),
                             p("Visualizations")
                         )),
                  column(3, 
                         div(class = "value-box warning",
                             h3("3"),
                             p("Models")
                         )),
                  column(3, 
                         div(class = "value-box danger",
                             h3("7"),
                             p("Days Active")
                         ))
                ),
                actionButton("logoutBtn", "Logout", class = "btn-outline-danger",
                             icon = icon("sign-out-alt"))
              )
            )
          )
        )
      ),
      
      # Featured content section
      fluidRow(
        column(
          width = 12,
          h2(class = "dashboard-title", "Featured Content"),
          
          fluidRow(
            column(
              width = 4,
              div(
                class = "box",
                style = "padding: 15px;",
                h3("Data Visualization"),
                img(src = "https://via.placeholder.com/300x200?text=Data+Visualization", width = "100%"),
                p("Explore advanced visualization techniques using ggplot2, plotly, and more."),
                actionButton("goToViz", "Explore", class = "btn-info btn-sm")
              )
            ),
            column(
              width = 4,
              div(
                class = "box",
                style = "padding: 15px;",
                h3("Machine Learning"),
                img(src = "https://via.placeholder.com/300x200?text=Machine+Learning", width = "100%"),
                p("Build and evaluate machine learning models for classification and regression."),
                actionButton("goToML", "Explore", class = "btn-info btn-sm")
              )
            ),
            column(
              width = 4,
              div(
                class = "box",
                style = "padding: 15px;",
                h3("Statistical Analysis"),
                img(src = "https://via.placeholder.com/300x200?text=Statistical+Analysis", width = "100%"),
                p("Perform comprehensive statistical tests and analysis on your data."),
                actionButton("goToStats", "Explore", class = "btn-info btn-sm")
              )
            )
          )
        )
      )
    ),
    
    # Projects tab
    tabPanel(
      "Projects",
      icon = icon("folder-open"),
      
      fluidRow(
        column(
          width = 3,
          wellPanel(
            h3("Project Filters"),
            selectInput("projectCategory", "Category:",
                        choices = c("All", "Data Analysis", "Visualization", "Machine Learning", "Web Apps"),
                        selected = "All"),
            sliderInput("projectComplexity", "Complexity:",
                        min = 1, max = 5, value = c(1, 5), step = 1),
            checkboxGroupInput("projectTags", "Tags:",
                               choices = c("R", "Python", "Shiny", "ggplot2", "TensorFlow", "SQL"),
                               selected = "R"),
            actionButton("resetFilters", "Reset Filters", class = "btn-sm btn-block")
          )
        ),
        
        column(
          width = 9,
          tabsetPanel(
            id = "projectTabs",
            tabPanel(
              "Gallery",
              br(),
              fluidRow(id = "projectGallery", 
                       column(4, div(class = "box", style = "padding: 15px; margin-bottom: 15px;",
                                     img(src = "https://via.placeholder.com/300x200?text=Time+Series+Analysis", width = "100%"),
                                     h4("Time Series Analysis"),
                                     tags$span(class = "badge badge-info", "R"),
                                     tags$span(class = "badge badge-info", "ggplot2"),
                                     p("Forecasting and visualization of temporal data."),
                                     actionButton("openProject1", "Open", class = "btn-sm btn-primary"))),
                       column(4, div(class = "box", style = "padding: 15px; margin-bottom: 15px;",
                                     img(src = "https://via.placeholder.com/300x200?text=Dashboard+Builder", width = "100%"),
                                     h4("Dashboard Builder"),
                                     tags$span(class = "badge badge-info", "Shiny"),
                                     tags$span(class = "badge badge-info", "R"),
                                     p("Create interactive dashboards without coding."),
                                     actionButton("openProject2", "Open", class = "btn-sm btn-primary"))),
                       column(4, div(class = "box", style = "padding: 15px; margin-bottom: 15px;",
                                     img(src = "https://via.placeholder.com/300x200?text=ML+Classification", width = "100%"),
                                     h4("ML Classification"),
                                     tags$span(class = "badge badge-info", "R"),
                                     tags$span(class = "badge badge-info", "Machine Learning"),
                                     p("Comparison of classification algorithms."),
                                     actionButton("openProject3", "Open", class = "btn-sm btn-primary")))
              )
            ),
            tabPanel(
              "Table View",
              br(),
              DTOutput("projectTable") %>% withSpinner(type = 5)
            ),
            tabPanel(
              "Create New",
              br(),
              wellPanel(
                h3("Create New Project"),
                textInput("newProjectName", "Project Name:", placeholder = "Enter a descriptive name"),
                selectInput("newProjectType", "Project Type:", 
                            choices = c("Data Analysis", "Visualization", "Machine Learning", "Web App")),
                textAreaInput("newProjectDesc", "Description:", rows = 3, 
                              placeholder = "Describe your project objectives..."),
                fileInput("projectDataFile", "Upload Data (Optional):", 
                          accept = c(".csv", ".xlsx", ".rds")),
                actionButton("createProject", "Create Project", class = "btn-success")
              )
            )
          )
        )
      )
    ),
    
    # Analytics tab
    tabPanel(
      "Analytics",
      icon = icon("chart-line"),
      
      fluidRow(
        column(
          width = 3,
          wellPanel(
            h3("Data Source"),
            fileInput("dataFile", "Upload Data:",
                      accept = c(".csv", ".xlsx", ".txt")),
            hr(),
            conditionalPanel(
              condition = "output.dataLoaded == true",
              h4("Data Options"),
              selectInput("xVariable", "X Variable:", choices = NULL),
              selectInput("yVariable", "Y Variable:", choices = NULL),
              selectInput("groupVariable", "Group By (Optional):", choices = NULL, multiple = TRUE),
              selectInput("plotType", "Plot Type:",
                          choices = c("Scatter", "Line", "Bar", "Histogram", "Box", "Heatmap")),
              actionButton("generatePlot", "Generate Plot", class = "btn-primary btn-block")
            )
          )
        ),
        
        column(
          width = 9,
          tabsetPanel(
            id = "analyticsTabs",
            tabPanel(
              "Visualization",
              conditionalPanel(
                condition = "output.dataLoaded != true",
                div(
                  style = "text-align: center; margin-top: 100px;",
                  icon("upload", "fa-5x"),
                  h3("Please upload a data file to begin")
                )
              ),
              conditionalPanel(
                condition = "output.dataLoaded == true",
                fluidRow(
                  column(12, plotlyOutput("mainPlot", height = "500px") %>% withSpinner(type = 5))
                ),
                hr(),
                fluidRow(
                  column(4, 
                         div(class = "box", style = "padding: 15px;",
                             h4("Plot Controls"),
                             sliderInput("plotHeight", "Height:", min = 300, max = 800, value = 500),
                             colourpicker::colourInput("plotColor", "Primary Color:", "#3498db"),
                             checkboxInput("showLegend", "Show Legend", TRUE),
                             downloadButton("downloadPlot", "Download Plot")
                         )
                  ),
                  column(8, 
                         div(class = "box", style = "padding: 15px;",
                             h4("Plot Statistics"),
                             verbatimTextOutput("plotStats")
                         )
                  )
                )
              )
            ),
            tabPanel(
              "Data Explorer",
              conditionalPanel(
                condition = "output.dataLoaded == true",
                fluidRow(
                  column(12, DTOutput("dataTable") %>% withSpinner(type = 5))
                ),
                hr(),
                fluidRow(
                  column(6, verbatimTextOutput("dataSummary")),
                  column(6, plotlyOutput("dataStructure"))
                )
              )
            ),
            tabPanel(
              "Statistical Tests",
              conditionalPanel(
                condition = "output.dataLoaded == true",
                fluidRow(
                  column(
                    width = 4,
                    wellPanel(
                      h4("Choose Test"),
                      selectInput("testType", "Test Type:",
                                  choices = c("t-test", "ANOVA", "Chi-Square", "Correlation", "Regression")),
                      uiOutput("dynamicTestInputs"),
                      actionButton("runTest", "Run Test", class = "btn-primary")
                    )
                  ),
                  column(
                    width = 8,
                    h4("Test Results"),
                    verbatimTextOutput("testResults"),
                    plotlyOutput("testPlot", height = "300px")
                  )
                )
              )
            )
          )
        )
      )
    ),
    
    # Learn tab
    tabPanel(
      "Learn",
      icon = icon("graduation-cap"),
      
      fluidRow(
        column(
          width = 3,# Replace the accordion section with this standard Shiny approach
          wellPanel(
            h3("Learning Paths"),
            
            # R Programming section
            div(style = "border-bottom: 1px solid #eee; padding-bottom: 10px; margin-bottom: 10px;",
                div(
                  style = "display: flex; justify-content: space-between; align-items: center;",
                  h4("R Programming", style = "margin: 0;"),
                  actionLink("toggleRProg", "Show/Hide")
                ),
                conditionalPanel(
                  condition = "input.toggleRProg % 2 == 1",
                  div(
                    style = "padding: 10px 0;",
                    p("Learn the fundamentals of R, data wrangling, and more."),
                    actionButton("rlPath", "Start Path", class = "btn-sm btn-block mt-2")
                  )
                )
            ),
            
            # Data Visualization section
            div(style = "border-bottom: 1px solid #eee; padding-bottom: 10px; margin-bottom: 10px;",
                div(
                  style = "display: flex; justify-content: space-between; align-items: center;",
                  h4("Data Visualization", style = "margin: 0;"),
                  actionLink("toggleViz", "Show/Hide")
                ),
                conditionalPanel(
                  condition = "input.toggleViz % 2 == 1",
                  div(
                    style = "padding: 10px 0;",
                    p("Master ggplot2, plotly, and interactive visualization techniques."),
                    actionButton("vizPath", "Start Path", class = "btn-sm btn-block mt-2")
                  )
                )
            ),
            
            # Statistics section
            div(style = "border-bottom: 1px solid #eee; padding-bottom: 10px; margin-bottom: 10px;",
                div(
                  style = "display: flex; justify-content: space-between; align-items: center;",
                  h4("Statistics", style = "margin: 0;"),
                  actionLink("toggleStats", "Show/Hide")
                ),
                conditionalPanel(
                  condition = "input.toggleStats % 2 == 1",
                  div(
                    style = "padding: 10px 0;",
                    p("Understand key statistical concepts and tests."),
                    actionButton("statsPath", "Start Path", class = "btn-sm btn-block mt-2")
                  )
                )
            ),
            
            # Machine Learning section
            div(style = "border-bottom: 1px solid #eee; padding-bottom: 10px; margin-bottom: 10px;",
                div(
                  style = "display: flex; justify-content: space-between; align-items: center;",
                  h4("Machine Learning", style = "margin: 0;"),
                  actionLink("toggleML", "Show/Hide")
                ),
                conditionalPanel(
                  condition = "input.toggleML % 2 == 1",
                  div(
                    style = "padding: 10px 0;",
                    p("Build models for classification, regression, and clustering."),
                    actionButton("mlPath", "Start Path", class = "btn-sm btn-block mt-2")
                  )
                )
            )
          )
        ),
        
        column(
          width = 9,
          tabsetPanel(
            id = "learnTabs",
            tabPanel(
              "Tutorials",
              div(
                class = "box",
                style = "padding: 20px;",
                h3("Featured Tutorials"),
                fluidRow(
                  column(6, 
                         div(style = "margin-bottom: 20px;",
                             img(src = "https://via.placeholder.com/400x225?text=ggplot2+Mastery", width = "100%"),
                             h4("ggplot2 Mastery"),
                             p("Learn how to create beautiful and informative data visualizations with ggplot2."),
                             div(
                               tags$span(class = "badge badge-info", "Intermediate"),
                               tags$span(class = "badge badge-success", "4.8/5 ★")
                             ),
                             actionButton("tutorial1", "Start Tutorial", class = "btn-sm btn-primary mt-2")
                         )
                  ),
                  column(6, 
                         div(style = "margin-bottom: 20px;",
                             img(src = "https://via.placeholder.com/400x225?text=Data+Wrangling", width = "100%"),
                             h4("Data Wrangling with dplyr"),
                             p("Master the essential data manipulation techniques using the tidyverse."),
                             div(
                               tags$span(class = "badge badge-info", "Beginner"),
                               tags$span(class = "badge badge-success", "4.9/5 ★")
                             ),
                             actionButton("tutorial2", "Start Tutorial", class = "btn-sm btn-primary mt-2")
                         )
                  )
                )
              )
            ),
            tabPanel(
              "Resources",
              div(
                class = "box",
                style = "padding: 20px;",
                h3("Learning Resources"),
                tabsetPanel(
                  tabPanel("Books", 
                           br(),
                           fluidRow(
                             column(4, div(class = "box", style = "padding: 15px; text-align: center;",
                                           img(src = "https://via.placeholder.com/150x200?text=R+for+Data+Science", width = "150px"),
                                           h4("R for Data Science"),
                                           p("By Hadley Wickham & Garrett Grolemund"),
                                           a(href = "https://r4ds.had.co.nz/", "Read Online", target = "_blank", class = "btn btn-sm btn-info"))),
                             column(4, div(class = "box", style = "padding: 15px; text-align: center;",
                                           img(src = "https://via.placeholder.com/150x200?text=ggplot2", width = "150px"),
                                           h4("ggplot2: Elegant Graphics for Data Analysis"),
                                           p("By Hadley Wickham"),
                                           a(href = "https://ggplot2-book.org/", "Read Online", target = "_blank", class = "btn btn-sm btn-info"))),
                             column(4, div(class = "box", style = "padding: 15px; text-align: center;",
                                           img(src = "https://via.placeholder.com/150x200?text=Advanced+R", width = "150px"),
                                           h4("Advanced R"),
                                           p("By Hadley Wickham"),
                                           a(href = "https://adv-r.hadley.nz/", "Read Online", target = "_blank", class = "btn btn-sm btn-info")))
                           )),
                  tabPanel("Courses", 
                           br(),
                           DT::dataTableOutput("courseTable")),
                  tabPanel("Cheatsheets", 
                           br(),
                           fluidRow(
                             column(3, downloadButton("downloadGgplot", "ggplot2", class = "btn-block mb-3")),
                             column(3, downloadButton("downloadDplyr", "dplyr", class = "btn-block mb-3")),
                             column(3, downloadButton("downloadShiny", "Shiny", class = "btn-block mb-3")),
                             column(3, downloadButton("downloadStats", "Statistics", class = "btn-block mb-3"))
                           ),
                           hr(),
                           fluidRow(
                             column(12, uiOutput("cheatsheetPreview"))
                           ))
                )
              )
            ),
            tabPanel(
              "Community",
              div(
                class = "box",
                style = "padding: 20px;",
                h3("Join the Community"),
                p("Connect with other data science enthusiasts and get help when you need it."),
                fluidRow(
                  column(4, div(class = "box", style = "padding: 15px; text-align: center;",
                                icon("github", "fa-3x"),
                                h4("GitHub"),
                                p("Contribute to open-source projects and learn from shared code."),
                                a(href = "https://github.com/topics/r", "Explore R Projects", target = "_blank", class = "btn btn-sm btn-info"))),
                  column(4, div(class = "box", style = "padding: 15px; text-align: center;",
                                icon("stack-overflow", "fa-3x"),
                                h4("Stack Overflow"),
                                p("Get answers to your technical questions from experts."),
                                a(href = "https://stackoverflow.com/questions/tagged/r", "R Questions", target = "_blank", class = "btn btn-sm btn-info"))),
                  column(4, div(class = "box", style = "padding: 15px; text-align: center;",
                                icon("r-project", "fa-3x"),
                                h4("R-bloggers"),
                                p("Stay updated with the latest R news and tutorials."),
                                a(href = "https://www.r-bloggers.com/", "Visit R-bloggers", target = "_blank", class = "btn btn-sm btn-info")))
                ),
                hr(),
                h4("Upcoming Events"),
                DTOutput("eventsTable")
              )
            )
          )
        )
      )
    ),
    
    # Contact tab
    tabPanel(
      "Contact",
      icon = icon("envelope"),
      
      fluidRow(
        column(
          width = 8,
          offset = 2,
          div(
            class = "box",
            style = "padding: 20px;",
            h2(class = "dashboard-title", "Get in Touch"),
            p("Have questions, suggestions, or want to collaborate? Feel free to reach out!"),
            
            fluidRow(
              column(
                width = 6,
                wellPanel(
                  h3("Contact Form"),
                  textInput("contactName", "Name:", placeholder = "Your full name"),
                  textInput("contactEmail", "Email:", placeholder = "your.email@example.com"),
                  selectInput("contactSubject", "Subject:",
                              choices = c("General Inquiry", "Feature Request", "Bug Report", 
                                          "Collaboration Proposal", "Other")),
                  textAreaInput("contactMessage", "Message:", rows = 5,
                                placeholder = "Write your message here..."),
                  checkboxInput("contactCopy", "Send me a copy of this message", FALSE),
                  actionButton("sendMessage", "Send Message", class = "btn-primary btn-block",
                               icon = icon("paper-plane"))
                )
              ),
              
              column(
                width = 6,
                div(
                  style = "padding: 20px;",
                  h3("Contact Information"),
                  tags$ul(
                    tags$li(icon("envelope"), " Email: prajjwal024@gmail.com"),
                    tags$li(icon("github"), " GitHub: github.com/prajjwal"),
                    tags$li(icon("linkedin"), " LinkedIn: linkedin.com/in/prajjwal"),
                    tags$li(icon("twitter"), " Twitter: @prajjwal_data")
                  ),
                  hr(),
                  h4("Office Hours"),
                  tags$table(
                    class = "table table-sm",
                    tags$thead(
                      tags$tr(
                        tags$th("Day"),
                        tags$th("Hours")
                      )
                    ),
                    tags$tbody(
                      tags$tr(
                        tags$td("Monday - Friday"),
                        tags$td("9:00 AM - 5:00 PM (IST)")
                      ),
                      tags$tr(
                        tags$td("Saturday"),
                        tags$td("10:00 AM - 2:00 PM (IST)")
                      ),
                      tags$tr(
                        tags$td("Sunday"),
                        tags$td("Closed")
                      )
                    )
                  ),
                  hr(),
                  h4("Response Time"),
                  progressBar(
                    id = "responseProgress",
                    value = 80,
                    status = "success",
                    display_pct = TRUE,
                    title = "Typically respond within 24 hours"
                  )
                )
              )
            )
          )
        )
      )
    ),
    
    # Settings tab
    tabPanel(
      "Settings",
      icon = icon("cog"),
      
      conditionalPanel(
        condition = "output.userLoggedIn != true",
        fluidRow(
          column(
            width = 6,
            offset = 3,
            div(
              class = "box",
              style = "padding: 20px; text-align: center; margin-top: 50px;",
              icon("lock", "fa-5x"),
              h2("Please Log In"),
              p("You need to be logged in to access settings."),
              actionButton("loginRedirect", "Go to Login", class = "btn-primary")
            )
          )
        )
      ),
      
      conditionalPanel(
        condition = "output.userLoggedIn == true",
        fluidRow(
          column(
            width = 3,
            wellPanel(
              h3("User Settings"),
              tabsetPanel(
                id = "settingsTabs",
                tabPanel("Profile", 
                         br(),
                         div(style = "text-align: center;",
                             img(src = "https://github.com/identicons/prajjwal.png", height = "150px", class = "profile-image"),
                             fileInput("profilePhoto", "Change Photo", accept = c("image/jpeg", "image/png")),
                         ),
                         textInput("profileName", "Display Name:", value = ""),
                         textInput("profileEmail", "Email:", value = ""),
                         textAreaInput("profileBio", "Bio:", rows = 3),
                         actionButton("saveProfile", "Save Changes", class = "btn-primary btn-block")),
                tabPanel("Appearance", 
                         br(),
                         selectInput("themeSelection", "App Theme:",
                                     choices = c("Flatly", "Cerulean", "Cosmo", "Journal", "Lumen", "Sandstone", "United")),
                         sliderInput("fontSize", "Font Size:", min = 12, max = 20, value = 14, step = 1),
                         checkboxInput("darkMode", "Dark Mode", FALSE),
                         hr(),
                         h4("Dashboard Layout"),
                         radioButtons("dashLayout", "Layout Preference:",
                                      choices = list("Default" = "default", "Compact" = "compact", "Wide" = "wide"),
                                      selected = "default"),
                         actionButton("applyAppearance", "Apply", class = "btn-primary btn-block")),
                tabPanel("Notifications", 
                         br(),
                         checkboxInput("emailNotifications", "Email Notifications", TRUE),
                         checkboxInput("projectUpdates", "Project Updates", TRUE),
                         checkboxInput("systemAlerts", "System Alerts", TRUE),
                         checkboxInput("weeklyDigest", "Weekly Digest", FALSE),
                         hr(),
                         selectInput("notifFrequency", "Notification Frequency:",
                                     choices = c("Real-time", "Daily Digest", "Weekly Digest")),
                         actionButton("saveNotifications", "Save Preferences", class = "btn-primary btn-block"))
              )
            )
          ),
          
          column(
            width = 9,
            tabsetPanel(
              id = "settingsContentTabs",
              tabPanel("Account", 
                       br(),
                       div(
                         class = "box",
                         style = "padding: 20px;",
                         h3("Account Information"),
                         fluidRow(
                           column(6, 
                                  h4("Personal Information"),
                                  wellPanel(
                                    fluidRow(
                                      column(6, textInput("accountFirstName", "First Name:")),
                                      column(6, textInput("accountLastName", "Last Name:"))
                                    ),
                                    textInput("accountEmail", "Email Address:"),
                                    dateInput("accountBirthday", "Date of Birth:"),
                                    selectInput("accountCountry", "Country:",
                                                choices = c("United States", "India", "United Kingdom", "Canada", "Australia", 
                                                            "Germany", "France", "Japan", "Other"))
                                  )
                           ),
                           column(6, 
                                  h4("Security"),
                                  wellPanel(
                                    passwordInput("currentPassword", "Current Password:"),
                                    passwordInput("newPassword", "New Password:"),
                                    passwordInput("confirmNewPassword", "Confirm New Password:"),
                                    hr(),
                                    h5("Two-Factor Authentication"),
                                    switchInput("enable2FA", "Enable 2FA", value = FALSE),
                                    conditionalPanel(
                                      condition = "input.enable2FA == true",
                                      selectInput("twoFAMethod", "Authentication Method:",
                                                  choices = c("SMS", "Email", "Authenticator App"))
                                    )
                                  )
                           )
                         ),
                         hr(),
                         div(
                           style = "text-align: right;",
                           actionButton("updateAccount", "Update Account", class = "btn-primary"),
                           actionButton("deleteAccount", "Delete Account", class = "btn-danger ml-2")
                         )
                       )),
              tabPanel("API & Integrations", 
                       br(),
                       div(
                         class = "box",
                         style = "padding: 20px;",
                         h3("API Access"),
                         p("Generate API keys to access Prajjwal Central services programmatically."),
                         div(
                           tags$label("API Key:"),
                           tags$input(id = "apiKey", type = "text", class = "form-control", value= "xxxx-xxxx-xxxx-xxxx", readonly = "readonly")
                         ),
                         fluidRow(
                           column(6, verbatimTextOutput("apiKeyDetails")),
                           column(6, div(style = "text-align:right;",
                                         actionButton("regenerateKey", "Regenerate Key", class = "btn-warning"),
                                         actionButton("revokeKey", "Revoke Access", class = "btn-danger ml-2")))
                         ),
                         hr(),
                         h3("Connected Services"),
                         DTOutput("connectedServicesTable"),
                         hr(),
                         h3("Available Integrations"),
                         fluidRow(
                           column(3, div(class = "box", style = "padding: 15px; text-align: center;",
                                         icon("github", "fa-3x"),
                                         h4("GitHub"),
                                         p("Connect your GitHub repositories"),
                                         actionButton("connectGithub", "Connect", class = "btn-sm btn-block btn-info"))),
                           column(3, div(class = "box", style = "padding: 15px; text-align: center;",
                                         icon("google", "fa-3x"),
                                         h4("Google Drive"),
                                         p("Sync your data with Google Drive"),
                                         actionButton("connectGDrive", "Connect", class = "btn-sm btn-block btn-info"))),
                           column(3, div(class = "box", style = "padding: 15px; text-align: center;",
                                         icon("aws", "fa-3x"),
                                         h4("AWS S3"),
                                         p("Store and retrieve data from S3"),
                                         actionButton("connectAWS", "Connect", class = "btn-sm btn-block btn-info"))),
                           column(3, div(class = "box", style = "padding: 15px; text-align: center;",
                                         icon("database", "fa-3x"),
                                         h4("Database"),
                                         p("Connect to SQL databases"),
                                         actionButton("connectDB", "Connect", class = "btn-sm btn-block btn-info")))
                         )
                       )
              ),
              tabPanel("Data Management", 
                       br(),
                       div(
                         class = "box",
                         style = "padding: 20px;",
                         h3("Data Storage"),
                         p("Manage your uploaded data and storage preferences."),
                         fluidRow(
                           column(4, 
                                  div(class = "value-box primary",
                                      h3("250 MB"),
                                      p("Used Space")
                                  )),
                           column(4, 
                                  div(class = "value-box success",
                                      h3("1 GB"),
                                      p("Total Space")
                                  )),
                           column(4, 
                                  div(class = "value-box warning",
                                      h3("25%"),
                                      p("Usage")
                                  ))
                         ),
                         hr(),
                         h4("Uploaded Files"),
                         DTOutput("uploadedFilesTable"),
                         hr(),
                         h4("Storage Settings"),
                         fluidRow(
                           column(6, selectInput("dataRetention", "Data Retention Period:",
                                                 choices = c("30 days", "60 days", "90 days", "180 days", "1 year", "Forever"))),
                           column(6, selectInput("dataCompression", "Compression Level:",
                                                 choices = c("None", "Low", "Medium", "High")))
                         ),
                         checkboxInput("autoCleanup", "Automatically clean up unused files", TRUE),
                         actionButton("saveDataSettings", "Save Settings", class = "btn-primary")
                       )
              )
            )
          )
        )
      )
    )
  ),
  
  # Footer
  div(
    class = "footer",
    fluidRow(
      column(
        width = 4,
        h4("Prajjwal Central"),
        p("Your all-in-one platform for data science and analytics."),
        p(icon("envelope"), " prajjwal024@gmail.com")
      ),
      column(
        width = 4,
        h4("Quick Links"),
        tags$ul(
          style = "list-style-type: none; padding-left: 0;",
          tags$li(a(href = "#", "Home")),
          tags$li(a(href = "#", "Projects")),
          tags$li(a(href = "#", "Analytics")),
          tags$li(a(href = "#", "Learn"))
        )
      ),
      column(
        width = 4,
        h4("Connect"),
        div(
          style = "font-size: 24px;",
          a(href = "#", icon("github"), style = "margin-right: 15px;"),
          a(href = "#", icon("twitter"), style = "margin-right: 15px;"),
          a(href = "#", icon("linkedin"), style = "margin-right: 15px;"),
          a(href = "#", icon("youtube"))
        )
      )
    ),
    hr(),
    p("© 2025 Prajjwal Central. All rights reserved.")
  )
)

# Define server function
server <- function(input, output, session) {
  # Initialize reactive values
  rv <- reactiveValues(
    userLoggedIn = FALSE,
    userName = NULL,
    dataLoaded = FALSE,
    dataFrame = NULL,
    plotGenerated = FALSE,
    selectedProject = NULL
  )
  
  # Show loading screen on startup
  waiter_show(
    html = tagList(
      img(src = "https://github.com/identicons/prajjwal.png", height = "100px"),
      h3("Loading Prajjwal Central..."),
      spin_rotating_plane()
    ),
    color = "#ffffff"
  )
  
  # Hide loading screen after 2 seconds
  observe({
    invalidateLater(2000)
    waiter_hide()
  })
  # Add in the server function
  observeEvent(input$toggleR, {
    # This will handle the show/hide toggle
  })
  observeEvent(input$toggleViz, {
    # Similar for other sections
  })
  observeEvent(input$toggleStats, {
    # Similar for other sections
  })
  observeEvent(input$toggleML, {
    # Similar for other sections
  })
  
  # User login handling
  observeEvent(input$submitLogin, {
    if (input$firstName != "" && input$lastName != "") {
      rv$userLoggedIn <- TRUE
      rv$userName <- paste(input$firstName, input$lastName)
      
      # Show welcome notification
      showNotification(
        paste("Welcome to Prajjwal Central,", rv$userName, "!"),
        type = "message",
        duration = 5
      )
    } else {
      showNotification("Please enter your name to continue.", type = "error")
    }
  })
  
  # Logout handling
  observeEvent(input$logoutBtn, {
    rv$userLoggedIn <- FALSE
    rv$userName <- NULL
    showNotification("You have been logged out.", type = "message")
  })
  
  # Welcome message for logged-in users
  output$welcomeUser <- renderText({
    if (rv$userLoggedIn) {
      paste("Welcome back,", rv$userName, "!")
    }
  })
  
  # Set user login status for UI conditionals
  output$userLoggedIn <- reactive({
    rv$userLoggedIn
  })
  outputOptions(output, "userLoggedIn", suspendWhenHidden = FALSE)
  
  # Data loading
  observeEvent(input$dataFile, {
    # Show loading
    waiter_show(html = spin_fading_circles())
    
    # Read the data
    req(input$dataFile)
    ext <- tools::file_ext(input$dataFile$name)
    
    tryCatch({
      if (ext == "csv") {
        rv$dataFrame <- read.csv(input$dataFile$datapath, stringsAsFactors = FALSE)
      } else if (ext == "xlsx") {
        rv$dataFrame <- readxl::read_excel(input$dataFile$datapath)
      } else if (ext == "txt") {
        rv$dataFrame <- read.delim(input$dataFile$datapath, stringsAsFactors = FALSE)
      }
      
      # Update variable selection dropdowns
      updateSelectInput(session, "xVariable", choices = c("", colnames(rv$dataFrame)))
      updateSelectInput(session, "yVariable", choices = c("", colnames(rv$dataFrame)))
      updateSelectInput(session, "groupVariable", choices = c("", colnames(rv$dataFrame)))
      
      rv$dataLoaded <- TRUE
      showNotification("Data loaded successfully!", type = "message")
    }, error = function(e) {
      showNotification(paste("Error loading data:", e$message), type = "error")
    })
    
    # Hide loading
    waiter_hide()
  })
  
  # Set data loaded status for UI conditionals
  output$dataLoaded <- reactive({
    rv$dataLoaded
  })
  outputOptions(output, "dataLoaded", suspendWhenHidden = FALSE)
  
  # Data table output
  output$dataTable <- DT::renderDT({
    req(rv$dataLoaded)
    DT::datatable(rv$dataFrame,
                  options = list(pageLength = 10, scrollX = TRUE),
                  class = 'cell-border stripe')
  })
  
  # Data summary
  output$dataSummary <- renderPrint({
    req(rv$dataLoaded)
    summary(rv$dataFrame)
  })
  
  # Data structure visualization
  output$dataStructure <- renderPlotly({
    req(rv$dataLoaded)
    
    # Get column types
    col_types <- sapply(rv$dataFrame, class)
    
    # Count by type
    type_counts <- table(col_types)
    
    # Create data frame for plotting
    df <- data.frame(
      Type = names(type_counts),
      Count = as.numeric(type_counts)
    )
    
    # Create the plot
    p <- plot_ly(df, labels = ~Type, values = ~Count, type = 'pie',
                 marker = list(colors = brewer.pal(length(type_counts), "Set3")),
                 textinfo = 'label+percent',
                 insidetextorientation = 'radial')
    
    p <- p %>% layout(title = "Column Data Types",
                      showlegend = FALSE)
    
    return(p)
  })
  
  # Generate main plot
  observeEvent(input$generatePlot, {
    req(rv$dataLoaded, input$xVariable, input$yVariable)
    
    # Check if we have the required columns
    if (input$xVariable == "" || input$yVariable == "") {
      showNotification("Please select X and Y variables.", type = "warning")
      return()
    }
    
    # Show loading
    waiter_show(html = spin_ball())
    
    tryCatch({
      # Basic plot data
      plot_data <- rv$dataFrame
      
      # Generate the plot based on the selected type
      if (input$plotType == "Scatter") {
        p <- plot_ly(plot_data, x = ~get(input$xVariable), y = ~get(input$yVariable),
                     type = 'scatter', mode = 'markers',
                     marker = list(color = input$plotColor, size = 10, opacity = 0.7))
        
        # Add group if selected
        if (!is.null(input$groupVariable) && input$groupVariable != "") {
          p <- plot_ly(plot_data, x = ~get(input$xVariable), y = ~get(input$yVariable),
                       color = ~get(input$groupVariable),
                       type = 'scatter', mode = 'markers',
                       marker = list(size = 10, opacity = 0.7))
        }
        
        p <- p %>% layout(title = paste("Scatter Plot of", input$yVariable, "vs", input$xVariable),
                          xaxis = list(title = input$xVariable),
                          yaxis = list(title = input$yVariable),
                          showlegend = input$showLegend)
      } else if (input$plotType == "Line") {
        p <- plot_ly(plot_data, x = ~get(input$xVariable), y = ~get(input$yVariable),
                     type = 'scatter', mode = 'lines+markers',
                     line = list(color = input$plotColor, width = 2),
                     marker = list(color = input$plotColor, size = 8))
        
        # Add group if selected
        if (!is.null(input$groupVariable) && input$groupVariable != "") {
          p <- plot_ly(plot_data, x = ~get(input$xVariable), y = ~get(input$yVariable),
                       color = ~get(input$groupVariable),
                       type = 'scatter', mode = 'lines+markers')
        }
        
        p <- p %>% layout(title = paste("Line Plot of", input$yVariable, "vs", input$xVariable),
                          xaxis = list(title = input$xVariable),
                          yaxis = list(title = input$yVariable),
                          showlegend = input$showLegend)
      } else if (input$plotType == "Bar") {
        p <- plot_ly(plot_data, x = ~get(input$xVariable), y = ~get(input$yVariable),
                     type = 'bar', marker = list(color = input$plotColor))
        
        # Add group if selected
        if (!is.null(input$groupVariable) && input$groupVariable != "") {
          p <- plot_ly(plot_data, x = ~get(input$xVariable), y = ~get(input$yVariable),
                       color = ~get(input$groupVariable),
                       type = 'bar')
        }
        
        p <- p %>% layout(title = paste("Bar Plot of", input$yVariable, "by", input$xVariable),
                          xaxis = list(title = input$xVariable),
                          yaxis = list(title = input$yVariable),
                          showlegend = input$showLegend)
      } else if (input$plotType == "Histogram") {
        p <- plot_ly(plot_data, x = ~get(input$xVariable),
                     type = 'histogram', marker = list(color = input$plotColor))
        
        # Add group if selected
        if (!is.null(input$groupVariable) && input$groupVariable != "") {
          p <- plot_ly(plot_data, x = ~get(input$xVariable),
                       color = ~get(input$groupVariable),
                       type = 'histogram')
        }
        
        p <- p %>% layout(title = paste("Histogram of", input$xVariable),
                          xaxis = list(title = input$xVariable),
                          yaxis = list(title = "Count"),
                          showlegend = input$showLegend)
      } else if (input$plotType == "Box") {
        p <- plot_ly(plot_data, y = ~get(input$yVariable), type = 'box',
                     marker = list(color = input$plotColor))
        
        # Add group if selected
        if (!is.null(input$groupVariable) && input$groupVariable != "") {
          p <- plot_ly(plot_data, x = ~get(input$groupVariable), y = ~get(input$yVariable),
                       type = 'box')
        }
        
        p <- p %>% layout(title = paste("Box Plot of", input$yVariable),
                          xaxis = list(title = input$groupVariable),
                          yaxis = list(title = input$yVariable),
                          showlegend = input$showLegend)
      } else if (input$plotType == "Heatmap") {
        # For heatmap, we need to reshape data if needed
        # This is a simplified approach for numeric data
        p <- plot_ly(z = as.matrix(plot_data[, c(input$xVariable, input$yVariable)]),
                     type = "heatmap", colorscale = "Viridis")
        
        p <- p %>% layout(title = "Data Heatmap",
                          showlegend = input$showLegend)
      }
      
      # Update plot height
      p <- p %>% layout(height = input$plotHeight)
      
      # Save the plot
      rv$currentPlot <- p
      rv$plotGenerated <- TRUE
      
      # Display the plot
      output$mainPlot <- renderPlotly({
        rv$currentPlot
      })
      
      # Calculate basic statistics
      if (is.numeric(rv$dataFrame[[input$xVariable]]) && is.numeric(rv$dataFrame[[input$yVariable]])) {
        # Calculate correlation
        correlation <- cor(rv$dataFrame[[input$xVariable]], rv$dataFrame[[input$yVariable]], use = "complete.obs")
        
        # Calculate simple linear model
        lm_model <- lm(paste(input$yVariable, "~", input$xVariable), data = rv$dataFrame)
        lm_summary <- summary(lm_model)
        
        # Update stats output
        output$plotStats <- renderPrint({
          cat("Correlation coefficient:", round(correlation, 4), "\n\n")
          cat("Linear regression summary:\n")
          print(lm_summary)
        })
      } else {
        output$plotStats <- renderPrint({
          cat("Statistical analysis requires numeric variables.")
        })
      }
      
      showNotification("Plot generated successfully!", type = "message")
    }, error = function(e) {
      showNotification(paste("Error generating plot:", e$message), type = "error")
    })
    
    # Hide loading
    waiter_hide()
  })
  
  # Handle plot downloads
  output$downloadPlot <- downloadHandler(
    filename = function() {
      paste("plot-", Sys.Date(), ".png", sep = "")
    },
    content = function(file) {
      # Export plotly to png
      plotly::export(rv$currentPlot, file = file)
    }
  )
  
  # Statistical tests
  # Dynamic UI for statistical tests
  output$dynamicTestInputs <- renderUI({
    req(rv$dataLoaded)
    
    if (input$testType == "t-test") {
      tagList(
        selectInput("tTestVariable", "Variable:", choices = colnames(rv$dataFrame)),
        selectInput("tTestGrouping", "Grouping Variable:", choices = colnames(rv$dataFrame)),
        radioButtons("tTestType", "Test Type:", 
                     choices = c("Two Sample" = "two.sample", "Paired" = "paired")),
        numericInput("tTestConf", "Confidence Level:", value = 0.95, min = 0.8, max = 0.99, step = 0.01)
      )
    } else if (input$testType == "ANOVA") {
      tagList(
        selectInput("anovaResponse", "Response Variable:", choices = colnames(rv$dataFrame)),
        selectInput("anovaFactor", "Factor Variable:", choices = colnames(rv$dataFrame)),
        checkboxInput("anovaTukey", "Perform Tukey HSD Post-hoc", TRUE)
      )
    } else if (input$testType == "Chi-Square") {
      tagList(
        selectInput("chiVariable1", "Variable 1:", choices = colnames(rv$dataFrame)),
        selectInput("chiVariable2", "Variable 2:", choices = colnames(rv$dataFrame))
      )
    } else if (input$testType == "Correlation") {
      tagList(
        selectInput("corVariable1", "Variable 1:", choices = colnames(rv$dataFrame)),
        selectInput("corVariable2", "Variable 2:", choices = colnames(rv$dataFrame)),
        selectInput("corMethod", "Method:", 
                    choices = c("Pearson" = "pearson", "Spearman" = "spearman", "Kendall" = "kendall"))
      )
    } else if (input$testType == "Regression") {
      tagList(
        selectInput("regResponse", "Response Variable:", choices = colnames(rv$dataFrame)),
        selectInput("regPredictors", "Predictor Variables:", 
                    choices = colnames(rv$dataFrame), multiple = TRUE),
        checkboxInput("regDiagnostics", "Show Diagnostics", TRUE)
      )
    }
  })
  
  # Run statistical test
  observeEvent(input$runTest, {
    req(rv$dataLoaded)
    
    # Show loading
    waiter_show(html = spin_rotating_plane())
    
    tryCatch({
      if (input$testType == "t-test") {
        # Check for required inputs
        req(input$tTestVariable, input$tTestGrouping)
        
        # Get data
        var <- rv$dataFrame[[input$tTestVariable]]
        group <- rv$dataFrame[[input$tTestGrouping]]
        
        # Run t-test
        test_result <- t.test(var ~ group, 
                              paired = input$tTestType == "paired",
                              conf.level = input$tTestConf)
        
        # Display results
        output$testResults <- renderPrint({
          print(test_result)
        })
        
        # Create boxplot for visualization
        output$testPlot <- renderPlotly({
          plot_data <- data.frame(
            value = var,
            group = group
          )
          
          p <- plot_ly(plot_data, x = ~group, y = ~value, type = "box",
                       boxpoints = "all", jitter = 0.3,
                       pointpos = 0, marker = list(size = 5))
          
          p <- p %>% layout(title = paste("T-test:", input$tTestVariable, "by", input$tTestGrouping),
                            xaxis = list(title = input$tTestGrouping),
                            yaxis = list(title = input$tTestVariable))
          
          return(p)
        })
      } else if (input$testType == "ANOVA") {
        # Check for required inputs
        req(input$anovaResponse, input$anovaFactor)
        
        # Get data
        response <- rv$dataFrame[[input$anovaResponse]]
        factor <- rv$dataFrame[[input$anovaFactor]]
        
        # Run ANOVA
        anova_model <- aov(response ~ factor)
        anova_summary <- summary(anova_model)
        
        # Run post-hoc if requested
        if (input$anovaTukey) {
          tukey_result <- TukeyHSD(anova_model)
        }
        
        # Display results
        output$testResults <- renderPrint({
          print(anova_summary)
          
          if (input$anovaTukey) {
            cat("\nTukey HSD Post-hoc Test:\n")
            print(tukey_result)
          }
        })
        
        # Create boxplot for visualization
        output$testPlot <- renderPlotly({
          plot_data <- data.frame(
            response = response,
            factor = factor
          )
          
          p <- plot_ly(plot_data, x = ~factor, y = ~response, type = "box",
                       boxpoints = "all", jitter = 0.3,
                       pointpos = 0, marker = list(size = 5))
          
          p <- p %>% layout(title = paste("ANOVA:", input$anovaResponse, "by", input$anovaFactor),
                            xaxis = list(title = input$anovaFactor),
                            yaxis = list(title = input$anovaResponse))
          
          return(p)
        })
      } else if (input$testType == "Chi-Square") {
        # Check for required inputs
        req(input$chiVariable1, input$chiVariable2)
        
        # Get data
        var1 <- rv$dataFrame[[input$chiVariable1]]
        var2 <- rv$dataFrame[[input$chiVariable2]]
        
        # Create contingency table
        cont_table <- table(var1, var2)
        
        # Run chi-square test
        chi_result <- chisq.test(cont_table)
        
        # Display results
        output$testResults <- renderPrint({
          cat("Contingency Table:\n")
          print(cont_table)
          
          cat("\nChi-Square Test Results:\n")
          print(chi_result)
        })
        
        # Create heatmap for visualization
        output$testPlot <- renderPlotly({
          p <- plot_ly(z = cont_table, type = "heatmap", colorscale = "Viridis")
          
          p <- p %>% layout(title = paste("Chi-Square Test:", input$chiVariable1, "vs", input$chiVariable2),
                            xaxis = list(title = input$chiVariable2),
                            yaxis = list(title = input$chiVariable1))
          
          return(p)
        })
      } else if (input$testType == "Correlation") {
        # Check for required inputs
        req(input$corVariable1, input$corVariable2)
        
        # Get data
        var1 <- rv$dataFrame[[input$corVariable1]]
        var2 <- rv$dataFrame[[input$corVariable2]]
        
        # Run correlation test
        cor_result <- cor.test(var1, var2, method = input$corMethod)
        
        # Display results
        output$testResults <- renderPrint({
          print(cor_result)
        })
        
        # Create scatter plot for visualization
        output$testPlot <- renderPlotly({
          plot_data <- data.frame(
            var1 = var1,
            var2 = var2
          )
          
          p <- plot_ly(plot_data, x = ~var1, y = ~var2, type = "scatter", mode = "markers",
                       marker = list(size = 10, opacity = 0.7))
          
          # Add regression line
          fit <- lm(var2 ~ var1)
          grid <- data.frame(var1 = seq(min(var1, na.rm = TRUE), max(var1, na.rm = TRUE), length = 100))
          grid$pred <- predict(fit, newdata = grid)
          
          p <- p %>% add_lines(data = grid, x = ~var1, y = ~pred, line = list(color = 'red'))
          
          p <- p %>% layout(title = paste("Correlation:", input$corVariable1, "vs", input$corVariable2,
                                          "(r =", round(cor_result$estimate, 3), ")"),
                            xaxis = list(title = input$corVariable1),
                            yaxis = list(title = input$corVariable2))
          
          return(p)
        })
      } else if (input$testType == "Regression") {
        # Check for required inputs
        req(input$regResponse, input$regPredictors)
        
        # Create formula
        formula_str <- paste(input$regResponse, "~", paste(input$regPredictors, collapse = " + "))
        
        # Run regression
        reg_model <- lm(formula_str, data = rv$dataFrame)
        reg_summary <- summary(reg_model)
        
        # Display results
        output$testResults <- renderPrint({
          cat("Linear Regression Model:", formula_str, "\n\n")
          print(reg_summary)
          
          if (input$regDiagnostics) {
            cat("\nANOVA:\n")
            print(anova(reg_model))
          }
        })
        
        # Create diagnostic plots if requested
        if (input$regDiagnostics) {
          output$testPlot <- renderPlotly({
            # Create data frame with actual vs predicted values
            pred_data <- data.frame(
              actual = rv$dataFrame[[input$regResponse]],
              predicted = predict(reg_model),
              residuals = residuals(reg_model)
            )
            
            # Create scatter plot of actual vs predicted
            p <- plot_ly() %>%
              add_trace(data = pred_data, x = ~predicted, y = ~actual, type = "scatter", mode = "markers",
                        name = "Actual vs Predicted", marker = list(size = 10, opacity = 0.7)) %>%
              add_trace(x = c(min(pred_data$predicted), max(pred_data$predicted)),
                        y = c(min(pred_data$predicted), max(pred_data$predicted)),
                        type = "scatter", mode = "lines", name = "Perfect Fit",
                        line = list(dash = "dash", color = "red"))
            
            p <- p %>% layout(title = "Regression: Actual vs Predicted Values",
                              xaxis = list(title = "Predicted Values"),
                              yaxis = list(title = "Actual Values"))
            
            return(p)
          })
        }
      }
      
      showNotification("Statistical test completed!", type = "message")
    }, error = function(e) {
      showNotification(paste("Error running test:", e$message), type = "error")
      output$testResults <- renderPrint({
        cat("Error running test:", e$message)
      })
    })
    
    # Hide loading
    waiter_hide()
  })
  
  # Project table
  output$projectTable <- DT::renderDT({
    projects_data <- data.frame(
      ID = 1:5,
      Name = c("Time Series Analysis", "Dashboard Builder", "ML Classification", 
               "Data Cleaning Tool", "Interactive Maps"),
      Category = c("Data Analysis", "Web Apps", "Machine Learning", 
                   "Data Analysis", "Visualization"),
      Complexity = c(3, 4, 5, 2, 4),
      LastUpdated = c("2025-02-28", "2025-02-15", "2025-01-30", 
                      "2025-02-10", "2025-02-01"),
      Status = c("Complete", "In Progress", "Complete", "Complete", "In Progress")
    )
    
    DT::datatable(projects_data,
                  options = list(pageLength = 5),
                  class = 'cell-border stripe',
                  selection = 'single')
  })
  
  # Course table
  output$courseTable <- DT::renderDT({
    courses_data <- data.frame(
      Course = c("R Programming Fundamentals", "Advanced Data Visualization",
                 "Statistical Modeling", "Machine Learning with R", "Shiny App Development"),
      Provider = c("Coursera", "DataCamp", "edX", "Udemy", "RStudio"),
      Level = c("Beginner", "Intermediate", "Advanced", "Intermediate", "Intermediate"),
      Duration = c("4 weeks", "6 weeks", "8 weeks", "10 weeks", "6 weeks"),
      Rating = c(4.8, 4.9, 4.7, 4.6, 4.9)
    )
    
    DT::datatable(courses_data,
                  options = list(pageLength = 5),
                  class = 'cell-border stripe')
  })
  
  # Events table
  output$eventsTable <- DT::renderDT({
    events_data <- data.frame(
      Event = c("R Conference 2025", "Data Science Summit", "Shiny Dev Con",
                "Statistical Computing Workshop", "Machine Learning Day"),
      Date = c("2025-04-15", "2025-05-20", "2025-06-10", "2025-03-30", "2025-07-05"),
      Location = c("New York, USA", "London, UK", "San Francisco, USA", "Virtual", "Berlin, Germany"),
      Type = c("Conference", "Summit", "Conference", "Workshop", "Meetup"),
      Registration = c("Open", "Open", "Coming Soon", "Closed", "Open")
    )
    
    DT::datatable(events_data,
                  options = list(pageLength = 5),
                  class = 'cell-border stripe')
  })
  
  # Uploaded files table
  output$uploadedFilesTable <- DT::renderDT({
    files_data <- data.frame(
      Filename = c("sales_data_2024.csv", "customer_survey.xlsx", "time_series.csv", 
                   "project_metrics.rds", "regional_data.csv"),
      Size = c("2.3 MB", "1.1 MB", "4.5 MB", "850 KB", "1.7 MB"),
      DateUploaded = c("2025-02-28", "2025-02-15", "2025-02-10", "2025-01-30", "2025-01-15"),
      Type = c("CSV", "Excel", "CSV", "RDS", "CSV"),
      LastAccessed = c("2025-03-01", "2025-02-20", "2025-02-28", "2025-02-15", "2025-02-25")
    )
    
    DT::datatable(files_data,
                  options = list(pageLength = 5),
                  class = 'cell-border stripe',
                  selection = 'single') %>%
      DT::formatStyle(
        'Type',
        backgroundColor = DT::styleEqual(
          c("CSV", "Excel", "RDS"),
          c('#e6f7ff', '#e6ffe6', '#fff2e6')
        )
      )
  })
  
  # Connected services table
  output$connectedServicesTable <- DT::renderDT({
    services_data <- data.frame(
      Service = c("GitHub", "Google Drive", "Dropbox", "AWS S3"),
      Status = c("Connected", "Connected", "Not Connected", "Not Connected"),
      LastSynced = c("2025-03-01 10:30 AM", "2025-02-28 04:15 PM", NA, NA),
      AccessLevel = c("Read/Write", "Read Only", NA, NA)
    )
    
    DT::datatable(services_data,
                  options = list(pageLength = 5),
                  class = 'cell-border stripe') %>%
      DT::formatStyle(
        'Status',
        backgroundColor = DT::styleEqual(
          c("Connected", "Not Connected"),
          c('#e6ffe6', '#ffe6e6')
        )
      )
  })
  
  # API key details
  output$apiKeyDetails <- renderPrint({
    cat("Key Status: Active\n")
    cat("Created: 2025-02-01\n")
    cat("Expires: 2025-08-01\n")
    cat("Rate Limit: 1000 requests/day\n")
    cat("Last Used: 2025-03-01\n")
  })
  
  # Navigation between tabs
  observeEvent(input$goToViz, {
    updateTabsetPanel(session, "navbar", selected = "Analytics")
  })
  
  observeEvent(input$goToML, {
    updateTabsetPanel(session, "navbar", selected = "Analytics")
    updateSelectInput(session, "plotType", selected = "Scatter")
  })
  
  observeEvent(input$goToStats, {
    updateTabsetPanel(session, "navbar", selected = "Analytics")
    updateTabsetPanel(session, "analyticsTabs", selected = "Statistical Tests")
  })
  
  # Cheatsheet preview
  output$cheatsheetPreview <- renderUI({
    tags$img(src = "https://via.placeholder.com/800x500?text=Cheatsheet+Preview", width = "100%")
  })
  
  # Handle contact form submission
  observeEvent(input$sendMessage, {
    req(input$contactName, input$contactEmail, input$contactMessage)
    
    # In a real app, this would send an email or save to a database
    showNotification(
      "Thanks for your message! We'll get back to you soon.",
      type = "message",
      duration = 5
    )
    
    # Clear form
    updateTextInput(session, "contactName", value = "")
    updateTextInput(session, "contactEmail", value = "")
    updateTextAreaInput(session, "contactMessage", value = "")
  })
  
  # Project creation
  observeEvent(input$createProject, {
    req(input$newProjectName, input$newProjectType)
    
    # In a real app, this would create a new project in the database
    showNotification(
      paste("Project", input$newProjectName, "created successfully!"),
      type = "message",
      duration = 5
    )
    
    # Clear form
    updateTextInput(session, "newProjectName", value = "")
    updateTextAreaInput(session, "newProjectDesc", value = "")
  })
  
  # Profile updates
  observeEvent(input$saveProfile, {
    showNotification(
      "Profile updated successfully!",
      type = "message",
      duration = 5
    )
  })
  
  # Account updates
  observeEvent(input$updateAccount, {
    showNotification(
      "Account information updated successfully!",
      type = "message",
      duration = 5
    )
  })
  
  # Notification preferences
  observeEvent(input$saveNotifications, {
    showNotification(
      "Notification preferences saved!",
      type = "message",
      duration = 5
    )
  })
  
  # Theme changes
  observeEvent(input$applyAppearance, {
    # In a real app, this would change the theme dynamically
    showNotification(
      "Appearance settings applied!",
      type = "message",
      duration = 5
    )
  })
  
  # API key handling
  observeEvent(input$regenerateKey, {
    # Generate a random key pattern
    new_key <- paste(
      paste0(sample(c(0:9, letters[1:6]), 4, replace = TRUE), collapse = ""),
      paste0(sample(c(0:9, letters[1:6]), 4, replace = TRUE), collapse = ""),
      paste0(sample(c(0:9, letters[1:6]), 4, replace = TRUE), collapse = ""),
      paste0(sample(c(0:9, letters[1:6]), 4, replace = TRUE), collapse = ""),
      sep = "-"
    )
    
    updateTextInput(session, "apiKey", value = new_key)
    
    showNotification(
      "API key regenerated successfully!",
      type = "message",
      duration = 5
    )
  })
  
  observeEvent(input$revokeKey, {
    showModal(
      modalDialog(
        title = "Revoke API Key",
        "Are you sure you want to revoke this API key? This action cannot be undone.",
        footer = tagList(
          modalButton("Cancel"),
          actionButton("confirmRevoke", "Confirm Revoke", class = "btn-danger")
        )
      )
    )
  })
  
  observeEvent(input$confirmRevoke, {
    updateTextInput(session, "apiKey", value = "xxxx-xxxx-xxxx-xxxx")
    removeModal()
    showNotification(
      "API key has been revoked.",
      type = "warning",
      duration = 5
    )
  })
  
  # Data settings
  observeEvent(input$saveDataSettings, {
    showNotification(
      "Data storage settings saved successfully!",
      type = "message",
      duration = 5
    )
  })
  
  # Service connections
  observeEvent(input$connectGithub, {
    # In a real app, this would open OAuth flow
    showNotification(
      "GitHub connection initialized. Check your browser.",
      type = "message",
      duration = 5
    )
  })
  
  observeEvent(input$connectGDrive, {
    # In a real app, this would open OAuth flow
    showNotification(
      "Google Drive connection initialized. Check your browser.",
      type = "message",
      duration = 5
    )
  })
  
  observeEvent(input$connectAWS, {
    # In a real app, this would open AWS credentials form
    showModal(
      modalDialog(
        title = "Connect to AWS S3",
        textInput("awsAccessKey", "Access Key ID:"),
        passwordInput("awsSecretKey", "Secret Access Key:"),
        textInput("awsBucket", "Default Bucket:"),
        selectInput("awsRegion", "Region:", 
                    choices = c("us-east-1", "us-east-2", "us-west-1", "us-west-2", "eu-west-1")),
        footer = tagList(
          modalButton("Cancel"),
          actionButton("confirmAWS", "Connect", class = "btn-primary")
        )
      )
    )
  })
  
  observeEvent(input$confirmAWS, {
    removeModal()
    showNotification(
      "AWS S3 connected successfully!",
      type = "message",
      duration = 5
    )
  })
  
  observeEvent(input$connectDB, {
    # In a real app, this would open database connection form
    showModal(
      modalDialog(
        title = "Connect to Database",
        selectInput("dbType", "Database Type:", 
                    choices = c("MySQL", "PostgreSQL", "SQLite", "MS SQL Server")),
        textInput("dbHost", "Host:"),
        textInput("dbPort", "Port:"),
        textInput("dbName", "Database Name:"),
        textInput("dbUser", "Username:"),
        passwordInput("dbPass", "Password:"),
        checkboxInput("dbSavePass", "Save password", FALSE),
        footer = tagList(
          modalButton("Cancel"),
          actionButton("testDBConnection", "Test Connection", class = "btn-info"),
          actionButton("confirmDB", "Connect", class = "btn-primary")
        )
      )
    )
  })
  
  observeEvent(input$confirmDB, {
    removeModal()
    showNotification(
      "Database connected successfully!",
      type = "message",
      duration = 5
    )
  })
  
  # Handle account deletion with confirmation
  observeEvent(input$deleteAccount, {
    showModal(
      modalDialog(
        title = "Delete Account",
        tags$div(
          tags$p("Are you sure you want to delete your account? This action cannot be undone."),
          tags$p("All your data, projects, and settings will be permanently deleted."),
          tags$p(tags$strong("Please type 'DELETE' to confirm:")),
          textInput("deleteConfirmation", "")
        ),
        footer = tagList(
          modalButton("Cancel"),
          actionButton("confirmDelete", "Delete My Account", class = "btn-danger")
        )
      )
    )
  })
  
  observeEvent(input$confirmDelete, {
    if (input$deleteConfirmation == "DELETE") {
      removeModal()
      rv$userLoggedIn <- FALSE
      rv$userName <- NULL
      showNotification(
        "Your account has been deleted. We're sorry to see you go.",
        type = "warning",
        duration = 10
      )
      updateTabsetPanel(session, "navbar", selected = "Welcome")
    } else {
      showNotification(
        "Please type 'DELETE' to confirm account deletion.",
        type = "error",
        duration = 5
      )
    }
  })
  
  # Handle login redirect
  observeEvent(input$loginRedirect, {
    updateTabsetPanel(session, "navbar", selected = "Welcome")
  })
  
  # Set profile information when logged in
  observe({
    if (rv$userLoggedIn) {
      updateTextInput(session, "profileName", value = rv$userName)
      updateTextInput(session, "profileEmail", value = input$email)
      
      # Set account information
      names <- strsplit(rv$userName, " ")[[1]]
      if (length(names) >= 2) {
        updateTextInput(session, "accountFirstName", value = names[1])
        updateTextInput(session, "accountLastName", value = names[2])
      } else {
        updateTextInput(session, "accountFirstName", value = rv$userName)
      }
      updateTextInput(session, "accountEmail", value = input$email)
    }
  })
  
  # Download handlers for cheatsheets
  output$downloadGgplot <- downloadHandler(
    filename = function() {
      "ggplot2-cheatsheet.pdf"
    },
    content = function(file) {
      # In a real app, this would download the actual file
      # For demo purposes, we'll just create a simple text file
      writeLines("This is a placeholder for the ggplot2 cheatsheet", file)
    }
  )
  
  output$downloadDplyr <- downloadHandler(
    filename = function() {
      "dplyr-cheatsheet.pdf"
    },
    content = function(file) {
      writeLines("This is a placeholder for the dplyr cheatsheet", file)
    }
  )
  
  output$downloadShiny <- downloadHandler(
    filename = function() {
      "shiny-cheatsheet.pdf"
    },
    content = function(file) {
      writeLines("This is a placeholder for the Shiny cheatsheet", file)
    }
  )
  
  output$downloadStats <- downloadHandler(
    filename = function() {
      "statistics-cheatsheet.pdf"
    },
    content = function(file) {
      writeLines("This is a placeholder for the Statistics cheatsheet", file)
    }
  )
}

# Run the application
shinyApp(ui = ui, server = server)