# Company Layoffs Data Analysis

This project involves comprehensive data cleaning and exploratory data analysis (EDA) of a dataset containing information on company layoffs. The analysis aims to derive insights into layoff trends across different companies, industries, countries, and time periods. The project is performed using MySQL.

## Project Overview

### Objective
- Perform data cleaning to prepare the dataset for analysis.
- Conduct exploratory data analysis to uncover patterns and trends in the layoff data.

### Tools Used
- **MySQL**
- **SQL**

## Data Cleaning

### Steps Involved
1. **Loading Raw Data**: Loaded the raw dataset into a staging table for initial cleaning.
2. **Removing Duplicates**: Identified and removed duplicate records to ensure the integrity of the data.
3. **Handling Null and Blank Values**: Managed null and blank values by either imputing defaults or removing incomplete records.
4. **Standardizing Data Formats**: Ensured consistency in data formats, including date formats and text case uniformity.
5. **Removing Unnecessary Columns and Rows**: Streamlined the dataset by eliminating irrelevant columns and rows.
6. **Optimizing Data Types**: Improved query performance and storage efficiency by using appropriate data types.
7. **Verifying Data Accuracy**: Ensured the accuracy and consistency of the cleaned data before proceeding with analysis.

## Exploratory Data Analysis (EDA)

### Key Analyses
1. **Understanding the Data**:
   - Displayed all records to get an overview of the data.
   - Counted the total number of rows.
   - Identified maximum values in key columns.

2. **Layoff Statistics**:
   - Calculated the top 5 values for total layoffs and percentage layoffs.
   - Identified companies with the highest total and percentage layoffs.

3. **Bankruptcy Analysis**:
   - Investigated companies that went completely bankrupt and their financial details.

4. **Date Range Analysis**:
   - Determined the minimum and maximum dates in the dataset.

5. **Company Layoff Analysis**:
   - Identified companies with the highest total layoffs.
   - Calculated the percentage of total layoffs by company.

6. **Industry and Country Analysis**:
   - Analyzed layoffs by industry and country.
   - Calculated total and percentage layoffs for each industry and country.

7. **Company Stage and Location Analysis**:
   - Examined layoffs by company stage and location.

8. **Date-based Analysis**:
   - Analyzed layoffs by specific dates, years, and month-year combinations.
   - Calculated rolling totals by month to visualize trends over time.

9. **Ranking Analysis**:
   - Ranked companies by the total number of layoffs each year.

## Project Structure
- `data_cleaning.sql`: Contains SQL scripts used for data cleaning.
- `eda.sql`: Contains SQL scripts used for exploratory data analysis.
- `README.md`: This file, providing an overview and summary of the project.

## Special Thanks
Special thanks to [Alex the Analyst](https://youtu.be/QYd-RtK58VQ?feature=shared) for providing guidance and inspiration for this project.
