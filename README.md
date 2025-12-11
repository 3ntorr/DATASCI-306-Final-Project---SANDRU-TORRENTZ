# DATASCI-306-Final-Project---SANDRU-TORRENTZ
# 👶 U.S. Baby Names Explorer (1880–2017) 🍼

An interactive **R Shiny web application** for exploring trends in U.S. baby name popularity and diversity using **Social Security Administration (SSA)** data via the `babynames` R package.

---

## Statistical Question:
  How have individual name popularity and rarity evolved over time, and how has overall naming diversity changed? We quantify trends in name uniqueness (proportion & rank) and population-level diversity (Shannon entropy & Gini coefficient), and examine patterns by gender, year, and decade.

---

## Data Source

- **Package:** `babynames`
- **Provider:** U.S. Social Security Administration (SSA)
- **Years Covered:** 1880–2017
- **Variables Used:**
  - `name` – baby name
  - `sex` – gender (F/M)
  - `year` – year of birth
  - `n` – number of babies given the name
  - `prop` – proportion of total births (derived)
  - `rank` – popularity rank (derived)
---

## App Features

### Name Popularity Explorer
- Search for any baby name
- Visualize popularity trends over time
- Filter by gender
- Interactive time-series plot with zoom controls

### Top Baby Names Table
- View the most popular baby names in a selected year
- Displays top names by gender

### Diversity & Uniqueness (Planned Extension)
- Shannon Entropy to measure naming diversity
- Gini Coefficient to measure name concentration
- Trends over time by gender

---

## Technologies Used

- **R & Shiny** – web application framework
- **tidyverse** – data manipulation
  -  **ggplot2** – visualization
- **plotly** – visualization
- **babynames** – SSA dataset
- **stringr** – standardized capitalization
- **bslib** – UI theming
- **forcats** – factor manipulation
---

## Running the App Locally

1. Clone this repository
2. Open `app.R` in **RStudio**
3. Install required packages (run once):

```r
install.packages(c("shiny", "dplyr", "ggplot2", "tidyverse", "babynames", "stringr", "bslib", "forcats"))
shiny::runApp()
```
---

## Deployment

This app can be deployed online using shinyapps.io:
```r
install.packages("rsconnect")
rsconnect::deployApp()
```
---

## Repository Structure

```bash
├── app.R      # Shiny application code
├── README.md  # Project documentation
```
---

## Motivation

Names are both personal identifiers and reflections of cultural and historical trends, making them interesting from both personal and research perspectives. Our app combines data science with an opportunity for personal exploration or broader social science inquiries.

---

## Authors

Lizzy Sandru and Natalie Torrentz

University of Michigan

Datasci 306 100 – Introduction to Statistical Computing - Prof. Jonathan Terhorst
