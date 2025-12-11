# DATASCI-306-Final-Project---SANDRU-TORRENTZ
# 👶 U.S. Baby Names Explorer (1880–2017)

An interactive **R Shiny web application** that allows users to explore trends in U.S. baby name popularity and diversity using data from the **Social Security Administration (SSA)** via the `babynames` R package.

---

## 📌 Research Question

Using the **babynames dataset (1880–2017)**, this project investigates:

- How individual name popularity has evolved over time  
- Whether baby names have become more **unique or rare**
- How overall naming **diversity** has changed across generations
- Differences in trends by **gender**, **year**, and **decade**

Proposal Question:
  Using the “babynames” dataset (1880-2017) from the U.S. SSA, we aim to investigate how individual name popularity (uniqueness & rank) and rarity have evolved, and how overall naming “diversity” has increased or decreased over time. We will quantify trends in name uniqueness (LOESS-smoothed) and population-level diversity (Shannon-entropy & Gini Coefficient), and examine how these patterns vary by gender, year, and decade.

---

## 📊 Data Source

- **Package:** `babynames`
- **Provider:** U.S. Social Security Administration (SSA)
- **Years Covered:** 1880–2017
- **Variables Used:**
  - `name` – baby name
  - `sex` – gender (F/M)
  - `year` – year of birth
  - `n` – number of babies given the name
  - `prop` – proportion of total births (calculated)
  - `rank` – popularity rank (calculated)

---

## ✨ App Features

### 🔍 Name Popularity Explorer
- Search for any baby name
- Visualize popularity trends over time
- Filter by gender
- Interactive time-series plot

### 📈 Top Baby Names Table
- View the most popular baby names in a selected year
- Displays top names by gender

### 🌈 Diversity & Uniqueness (Planned Extension)
- Shannon Entropy to measure naming diversity
- Gini Coefficient to measure name concentration
- Trends over time by gender and decade

---

## 🛠️ Technologies Used

- **R**
- **Shiny** – web application framework
- **tidyverse** – data manipulation
- **ggplot2** – visualization
- **babynames** – SSA dataset

---

## ▶️ How to Run the App Locally

1. Clone this repository
2. Open `app.R` in **RStudio**
3. Install required packages (run once):

```r
install.packages(c("shiny", "dplyr", "ggplot2", "tidyverse", "babynames"))
shiny::runApp()
```
---

#☁️ Deployment

This app can be deployed online using shinyapps.io:
```r
install.packages("rsconnect")
rsconnect::deployApp()
```
---

# 📁 Repository Structure

```bash
├── app.R      # Shiny application code
├── README.md  # Project documentation
```
---

#🎓 Motivation

Names are both personal identifiers and reflections of cultural and historical trends, making them interesting from both personal and research perspectives. Our app will combine data science with an opportunity for personal exploration, appealing to a wide audience.

---

#👤 Authors

Lizzy Sandru and Natalie Torrentz
University of Michigan
Datasci 306 – Introduction to Statistical Computing

