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
- Displays top 10 names by gender

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

