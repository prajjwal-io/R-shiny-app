# Prajjwal Central Dashboard in Rshiny

## Overview
Prajjwal Central is a comprehensive data science and analytics platform built with R Shiny. This interactive dashboard provides tools for data visualization, statistical analysis, project management, and learning resources - all within a modern, user-friendly interface.

## Features

### User Authentication
- User registration and login system
- Profile management
- Session handling with conditional UI elements
- Account settings and preferences

### Data Analysis & Visualization
- Support for multiple file formats (CSV, Excel, TXT)
- Interactive data exploration and visualization
- Multiple plot types (Scatter, Line, Bar, Histogram, Box, Heatmap)
- Advanced plot customization options
- Plot statistics and insights

### Statistical Testing
- Comprehensive suite of statistical tests:
  - t-test
  - ANOVA (with post-hoc Tukey HSD)
  - Chi-Square test
  - Correlation analysis
  - Linear Regression
- Dynamic UI for test parameter selection
- Visual results with interactive plots

### Project Management
- Project creation and management
- Gallery and table views
- Filtering and sorting capabilities
- Project categorization and tagging

### Learning Resources
- Structured learning paths
- Interactive tutorials
- Comprehensive resources including books, courses, and cheatsheets
- Community integration
- Upcoming events calendar

### Settings & Customization
- Profile management
- Appearance customization
- Notification preferences
- Account security settings

### Integrations
- API access management
- External service connections (GitHub, Google Drive, AWS S3, Databases)
- Data storage management

## Technology Stack

### Core Packages
- **shiny**: Main web framework
- **shinydashboard**: Dashboard UI components
- **shinythemes**: Theming and styling
- **shinyWidgets**: Extended UI components
- **shinyjs**: JavaScript operations
- **DT**: Interactive tables
- **plotly**: Interactive visualizations
- **ggplot2**: Advanced plotting
- **dplyr**: Data manipulation
- **tidyr**: Data cleaning
- **readr**: Data reading
- **lubridate**: Date and time handling
- **waiter**: Loading screens
- **RColorBrewer**: Color palettes

### UI Features
- Modern responsive design
- Custom CSS styling
- Interactive elements
- Loading animations
- Notifications
- Modal dialogs

### Data Visualization
- Interactive plots with tooltips and zooming
- Multiple visualization types
- Customizable options
- Statistical overlays
- Export capabilities

### Statistical Analysis
- Comprehensive statistical testing
- Visualization of test results
- Detailed statistical summaries
- Model diagnostics

## Setup Instructions

1. **Install Required Packages**
   ```r
   # Install the required packages
   install.packages(c("shiny", "shinydashboard", "shinythemes", "shinyWidgets", 
                     "DT", "plotly", "ggplot2", "dplyr", "tidyr", 
                     "readr", "lubridate", "shinycssloaders", 
                     "shinyjs", "waiter", "RColorBrewer"))
   ```

2. **Run the Application**
   ```r
   # Run the application directly
   shiny::runApp("path/to/app")
   ```

## Usage

### Data Upload and Analysis
1. Navigate to the "Analytics" tab
2. Upload data using the file input
3. Select variables for analysis
4. Choose visualization type
5. Customize plot settings
6. Generate plots and view statistics

### Statistical Testing
1. In the "Analytics" tab, go to "Statistical Tests"
2. Choose the desired test type
3. Set test parameters
4. Run the test and analyze results

### Project Management
1. Navigate to the "Projects" tab
2. Browse existing projects or create new ones
3. Use filters to find specific projects
4. View project details and access related resources

### Learning Resources
1. Navigate to the "Learn" tab
2. Explore learning paths and tutorials
3. Access books, courses, and cheatsheets
4. Connect with the community and view upcoming events

## Custom Styling
The dashboard includes extensive custom CSS styling to create a modern, cohesive user experience. Key styling elements include:

- Consistent color scheme based on the Flatly theme
- Custom box shadows and border radius for cards and panels
- Responsive layout adjustments
- Custom value boxes for metric displays
- Profile image styling
- Footer design and layout

## Future Enhancements
- Enhanced data import capabilities for additional file formats
- Advanced machine learning model building interface
- Collaborative project features
- Real-time data connections
- Extended API functionality
- Mobile-specific optimizations
- User permission levels and team management

## Developer Information
This application was developed with R Shiny and follows modern practices for interactive web application development within the R ecosystem.

---

© 2025 Prajjwal Central. All rights reserved.