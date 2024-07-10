# Arif Shaikh
# Part 2: Exploratory Data Analysis
# special thanks to Alex the Analyst(https://youtu.be/QYd-RtK58VQ?feature=shared)

#understand the data
select * 
from layoffs_staging2;

#total no of rows
select count(*) 
from layoffs_staging2;
#1995 rows

#max values
select max(total_laid_off)
from layoffs_staging2;
#12000 

-- top 5 laid_off values 
SELECT distinct total_laid_off
FROM layoffs_staging2
ORDER BY total_laid_off DESC
LIMIT 5;


select max(percentage_laid_off)
from layoffs_staging2;
#1

-- top 5 %_laid_off values 
SELECT distinct percentage_laid_off
FROM layoffs_staging2
ORDER BY percentage_laid_off DESC
LIMIT 5;

select * 
from layoffs_staging2
where total_laid_off = (select max(total_laid_off)
from layoffs_staging2)
or percentage_laid_off = (select max(percentage_laid_off)
from layoffs_staging2);

#million dollar company going completely bankrupt
select *
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions DESC;
#116 rows

--  date range
select min(`date`), max(`date`) 
from layoffs_staging2;

-- which companies layoff massively
select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 DESC; 
-- uhooh all ur fav MNC and FANG companies are there :{

select company, sum(total_laid_off),
(SUM(total_laid_off) / (SELECT SUM(total_laid_off) FROM layoffs_staging2) * 100) AS percentage_laid_off
from layoffs_staging2
group by company
order by 3 DESC; 

-- which industry layoff massively
select industry, sum(total_laid_off)
from layoffs_staging2
where industry is not null
group by industry
order by 2 DESC; 

SELECT 
    industry, 
    SUM(total_laid_off) AS total_laid_offf,
    (SUM(total_laid_off) / (SELECT SUM(total_laid_off) FROM layoffs_staging2) * 100) AS percentage_laid_off
FROM 
    layoffs_staging2
WHERE 
    industry IS NOT NULL
GROUP BY 
    industry
ORDER BY 
    total_laid_offf DESC;


-- which country layoff massively
select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 DESC; 

SELECT 
    country, 
    SUM(total_laid_off),
    (SUM(total_laid_off) / (SELECT SUM(total_laid_off) FROM layoffs_staging2) * 100) AS percentage_laid_off
from layoffs_staging2
group by country
order by 3 DESC; 

-- at which stage companies layoff massively
select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 DESC; 

SELECT 
    stage, 
    SUM(total_laid_off),
    (SUM(total_laid_off) / (SELECT SUM(total_laid_off) FROM layoffs_staging2) * 100) AS percentage_laid_off
from layoffs_staging2
group by stage
order by 3 DESC; 

-- which location layoff massively
select location, sum(total_laid_off)
from layoffs_staging2
group by location
order by 2 DESC; 

-- massively layoff  day
select `date`, sum(total_laid_off)
from layoffs_staging2
group by `date`
order by 1 DESC; 

SELECT 
    location, 
    SUM(total_laid_off),
    (SUM(total_laid_off) / (SELECT SUM(total_laid_off) FROM layoffs_staging2) * 100) AS percentage_laid_off
from layoffs_staging2
group by location
order by 3 DESC; 

-- massively layoff  year
select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 DESC; 
-- but 2023 has only 3 months 

SELECT 
    year(`date`),
    SUM(total_laid_off),
    (SUM(total_laid_off) / (SELECT SUM(total_laid_off) FROM layoffs_staging2) * 100) AS percentage_laid_off
from layoffs_staging2
group by year(`date`)
order by 1 DESC; 

-- massively layoff by  (month-year)
select substring(`date`, 1, 7) as `month`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`, 1, 7) is not null
group by `month`
order by 1; 

# Rolling Total by month
with CTE_Rolling_Total as(
select substring(`date`, 1, 7) as `month`, sum(total_laid_off) as 'total_sum_off'
from layoffs_staging2
where substring(`date`, 1, 7) is not null
group by `month`
order by 1)
select `month`, total_sum_off, 
sum(total_sum_off) over(order by `month`) as roll_tot
from CTE_Rolling_Total;


# Layoff Companies Rank
with CTE_Company_Year(company, years, total_laid_off) as (
select company, year(`date`) ,sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
), CTE_Company_Year_Rank as(
select *,
dense_rank() over (partition by years order by total_laid_off desc) as ranking
from CTE_Company_Year
where years is not null)
select * from CTE_Company_Year_Rank
where ranking <= 5;


