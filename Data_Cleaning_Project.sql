# Arif Shaikh
# Part 1: MySQL Data Cleaning Project
# special thanks to Alex the Analyst(https://youtu.be/4UltKCnnnTA?feature=shared)

-- Steps Covered
-- 1. Remove Duplicates
-- 2. Standardize the data
-- 3. null or blank values
-- 4. remove any columns or rows

#first let's understand our data
select * from layoffs; 

#keeping raw data as it is and creating another staging table - best practice :)

#create blank table
create table layoffs_staging
like layoffs;

#populate values
insert layoffs_staging
select * from layoffs;

#check new staging table
select * from layoffs_staging; 

-- 1. Remove Duplicates

-- since no primary key will partion/ check over all cols
with duplicate_cte as
(
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging
)
select * from duplicate_cte
where row_num > 1;

#to see if actual duplicate
select * from layoffs_staging
where company = 'Casper'; 

#simply delet in microsoft-sql
-- with duplicate_cte as
-- (
-- select *,
-- row_number() over(
-- partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
-- from layoffs_staging
-- )
-- delete from duplicate_cte
-- where row_num > 1;

#MySQL dosen't support that so here's a workaround :?

#create a copy table add row_num then use it to delete: how smart :)
create table `layoffs_staging2` (
	`company` text,
	`location` text,
	`industry` text,
	`total_laid_off` int default null,
	`percentage_laid_off` text,
	`date` text,
	`stage` text,
	`country` text,
	`funds_raised_millions` int default null,
	`row_num` int
)Engine = InnoDB Default Charset=utf8mb4 collate=utf8mb4_0900_ai_ci;

select * from layoffs_staging2;

insert into layoffs_staging2
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging;

#always check before deleting
select * from layoffs_staging2
where row_num > 1;

delete from layoffs_staging2
where row_num > 1;

-- 2. Standardize the data

-- let's go column by column 

#company column: what's that extra spaces for? remove it
select company, trim(company) 
from layoffs_staging2;

update layoffs_staging2
set company = trim(company);

select distinct(company) 
from layoffs_staging2;

#industry col
select distinct industry
from layoffs_staging2
order by 1;
#nulls and blank will be handled later so chill 

# three variations of crypto let's check those
select *
from layoffs_staging2
where industry like 'Crypto%';

#set to max repeating value
update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%';

#loc col -> handle typo
select distinct location
from layoffs_staging2
order by 1;

UPDATE layoffs_staging2
SET location = CASE
    WHEN location LIKE 'DÃ¼sseldorf' THEN 'Düsseldorf'
    WHEN location LIKE 'MalmÃ¶' THEN 'Malmö'
    WHEN location LIKE 'FlorianÃ³polis' THEN 'Florianópolis'
    ELSE location
END
WHERE location IN ('DÃ¼sseldorf', 'MalmÃ¶', 'FlorianÃ³polis');

#country col 

select distinct country
from layoffs_staging2
order by 1;

#why is there a '.' after US, can we spot it? 
select * from layoffs_staging2
where country like 'United State%';

#not spotted!! anyways remove it with custom trim
select distinct country, trim(trailing '.' from country)
from layoffs_staging2
order by 1;

update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'United State%';

#let's see these  3 num cols also
select distinct total_laid_off
from layoffs_staging2
order by 1;

select distinct percentage_laid_off
from layoffs_staging2
order by 1;

select distinct funds_raised_millions
from layoffs_staging2
order by 1;
#no outliers but null and blanks

#date column
# lets change date to desired format and dtype

#first check
select `date`, str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2;

#then update
update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

#change col type
alter table layoffs_staging2
modify column `date` date;

-- 3. null or blank values

select distinct industry
from layoffs_staging2
order by 1;

#finally it time to handle null and blank
select *
from layoffs_staging2
where industry is null
or industry = '';

select *
from layoffs_staging2
where company = 'Airbnb';

# insight: industry -> travel

#lets update to missing row

select tb1.company, tb1.industry, tb2.industry
from layoffs_staging2 as tb1
join layoffs_staging2 as tb2
	on tb1.company = tb2.company
    and tb1.location = tb2.location
where (tb1.industry is null or tb1.industry = '')
and tb2.industry is not null;

-- update layoffs_staging2 as tb1
-- join layoffs_staging2 as tb2
-- 	on tb1.company = tb2.company
--     and tb1.location = tb2.location
-- set tb1.industry = tb2.industry
-- where (tb1.industry is null or tb1.industry = '')
-- and tb2.industry is not null;

# didn't work? lets change blank to null and see if it works

update layoffs_staging2
set industry = null
where industry = '';

update layoffs_staging2 as tb1
join layoffs_staging2 as tb2
	on tb1.company = tb2.company
    and tb1.location = tb2.location
set tb1.industry = tb2.industry
where tb1.industry is null
and tb2.industry is not null;

#all done to update null and blank since laid_off columns can't be populated since total employee no is not given

-- 4. remove any columns or rows

# not '= null' but 'is null'
select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

#since we are studing layoff we can remove these cols with no info
delete
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;
#2361 -> 1995 rows

select * from layoffs_staging2;
#okay now i don't want the helping col row_num

#so lets remove it
alter table layoffs_staging2
drop column row_num;
