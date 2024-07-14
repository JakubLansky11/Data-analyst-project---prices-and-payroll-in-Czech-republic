CREATE TABLE t_auxiliary_1
SELECT
	name,
    SUM (value) / COUNT (value) AS Price,
    price_value AS Price_value,
    price_unit AS Unit,
    YEAR(date_to) AS Year
FROM czechia_price
JOIN czechia_price_category ON czechia_price.category_code = czechia_price_category.code
GROUP BY Year, name
ORDER BY name, Year ;
-- Vytvoření pomocné tabulky - ceny potravin

CREATE TABLE t_auxiliary_2
SELECT
    payroll_year AS Year,
    SUM (value) / COUNT (value) AS Payroll
FROM czechia_payroll
JOIN czechia_payroll_industry_branch 
    ON czechia_payroll.industry_branch_code = czechia_payroll_industry_branch.code
WHERE value_type_code LIKE 5958 and value IS NOT NULL and calculation_code LIKE 100
GROUP BY payroll_year
ORDER BY payroll_year ASC ;
-- Vytvoření pomocné tabulky - údaje o průměrné mzdě za jednotlivé roky

CREATE TABLE t_Jakub_Lansky_project_SQL_primary_final
SELECT 
    name,
    Price,
    Price_value,
    Unit,
    TA1.Year,
    Payroll
From t_auxiliary_1 as TA1
JOIN t_auxiliary_2 as TA2 ON TA1.Year = TA2.Year ;
 -- Vytvoření hlavní první tabulky - ceny jednotlivých potravin za jednotlivé roky a k nim průměrná mzda v daném roce. 

SELECT
    name AS Job_category,
    payroll_year AS Year,
    SUM (value) / COUNT (value) AS Average_payroll
FROM czechia_payroll
JOIN czechia_payroll_industry_branch 
    ON czechia_payroll.industry_branch_code = czechia_payroll_industry_branch.code
WHERE value_type_code LIKE 5958 and value IS NOT NULL and calculation_code LIKE 100
GROUP BY payroll_year, name
ORDER BY name ASC, payroll_year ASC, payroll_quarter ASC ;
 /* Odpověď na otázku číslo 1 - Průměrná mzda v jednotlivých letech pro každé odvětví.
 Z dat je vidět rostoucí trend ve všech odvětvích. */

SELECT
    Payroll / Price AS Bread_amount,
    Unit,
    Year
FROM t_Jakub_Lansky_project_SQL_primary_final
WHERE name LIKE "%chléb%"
ORDER BY Year ASC
Limit 1 ;
 -- Odpověď na otázku číslo 2 - Množství másla, které šlo za průměrnou mzdu koupit při nejstarším období

SELECT
    Payroll / Price AS "Bread_amount",
    Unit,
    Year
FROM t_Jakub_Lansky_project_SQL_primary_final
WHERE name LIKE "%chléb%"
ORDER BY Year DESC
Limit 1 ;
 -- Odpověď na otázku číslo 2 - Množství másla, které šlo za průměrnou mzdu koupit při nejmladším období

SELECT
    Payroll / Price AS "Milk_amount",
    Unit,
    Year
FROM t_Jakub_Lansky_project_SQL_primary_final
WHERE name LIKE "%mléko%"
ORDER BY Year ASC
Limit 1 ;
 -- Odpověď na otázku číslo 2 - Množství mléka, které šlo za průměrnou mzdu koupit při nejstarším období

SELECT
    Payroll / Price AS "Milk_amount",
    Unit,
    Year
FROM t_Jakub_Lansky_project_SQL_primary_final
WHERE name LIKE "%mléko%"
ORDER BY Year DESC
Limit 1 ;
 -- Odpověď na otázku číslo 2 - Množství mléka, které šlo za průměrnou mzdu koupit při nejmladším období

SELECT
    name,
    ((MAX(Price) - MIN(Price)) / MIN(Price)) *100 AS Difference
FROM t_Jakub_Lansky_project_SQL_primary_final
GROUP BY name
ORDER BY Difference ;
/* Odpověď na otázku číslo 3 - Procentuální nárůst cen jednotlivých potravin během sledovaného období
Z dat vychází, že největší nárůst je u másla a nejnižší u vína */

CREATE TABLE t_auxiliary_3
SELECT
    Year,
    SUM(Price) / COUNT(Price) AS Average_price,
    Payroll
FROM t_Jakub_Lansky_project_SQL_primary_final
GROUP BY Year
ORDER BY Year

SELECT
    Year,
    (Average_price - LAG(Average_price, 1) OVER (ORDER BY Year)) / LAG(Average_price, 1) OVER (ORDER BY Year) * 100 Price_year_difference,
    (Payroll - LAG(Payroll, 1) OVER (ORDER BY Year)) / LAG(Payroll, 1) OVER (ORDER BY Year) * 100 Payroll_year_difference
FROM t_auxiliary_3

/* Odpověď na otázku číslo 4 - Roční procentuální nárůst všech cen a roční procentuální nárůst mezd. 
Nejvyšší nárůst cen potravin 9,63 % v roce 2017, v některých letech pokles. 
Nejvyšší negativní rozdíl mezi nárůstem cen a mezd v roce 2013, kdy narostly ceny o 5,10 %, ale mzdy klesly o 1,56 % - rozdíl 6,66 %. 
Naopak vysoký pokles cen v roce 2009 (pokles o 6,41 %), zatímco nárůst mezd o 3,25 % - rozdíl 9,76 %. */

SELECT
    TA3.Year, 
    (GDP - LAG(GDP, 1) OVER (ORDER BY Year)) / LAG(GDP, 1) OVER (ORDER BY Year) * 100 GDP_year_difference,
    (Average_price - LAG(Average_price, 1) OVER (ORDER BY Year)) / LAG(Average_price, 1) OVER (ORDER BY Year) * 100 Price_year_difference,
    (Payroll - LAG(Payroll, 1) OVER (ORDER BY Year)) / LAG(Payroll, 1) OVER (ORDER BY Year) * 100 Payroll_year_difference,
    GDP AS "GDP_Czech_republic"
FROM t_auxiliary_3 as TA3
JOIN economies ON economies.Year = TA3.Year WHERE country LIKE "Czech republic"
ORDER BY TA3.Year
/* Odpověď na otázku číslo 5 - Roční procentuální nárůst všech cen a roční procentuální nárůst mezd a HDP v ČR. 
Z dat nevychází příliš velká korelace HDP a růstem cen potravin a růstem mezd.  */

CREATE TABLE t_Jakub_Lansky_project_SQL_secondary_final
SELECT
    c.country,
    c.capital_city,
    c.continent,
    c.currency_name,
    c.religion,
    e.GDP,
    e.year
FROM countries AS c
JOIN economies AS e ON e.country = c.country
WHERE GDP IS NOT NULL
ORDER BY c.country, year
