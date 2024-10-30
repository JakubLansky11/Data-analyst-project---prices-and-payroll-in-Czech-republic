CREATE or replace TABLE t_auxiliary_1
SELECT
    name,
    SUM(value) / COUNT(value) AS price,
    price_value AS price_value,
    price_unit AS unit,
    YEAR(date_to) AS year
FROM czechia_price
JOIN czechia_price_category ON czechia_price.category_code = czechia_price_category.code
GROUP BY Year, name
ORDER BY name, Year ;
-- Vytvoření pomocné tabulky - ceny potravin

CREATE or replace TABLE t_auxiliary_2
SELECT
    payroll_year AS year,
    SUM(value) / COUNT(value) AS payroll
FROM czechia_payroll
JOIN czechia_payroll_industry_branch 
    ON czechia_payroll.industry_branch_code = czechia_payroll_industry_branch.code
WHERE value_type_code LIKE 5958 AND value IS NOT NULL and calculation_code LIKE 100
GROUP BY payroll_year
ORDER BY payroll_year ASC ;
-- Vytvoření pomocné tabulky - údaje o průměrné mzdě za jednotlivé roky

CREATE or replace TABLE t_Jakub_Lansky_project_SQL_primary_final
SELECT 
    name,
    price,
    price_value,
    unit,
    TA1.year,
    payroll
From t_auxiliary_1 AS TA1
JOIN t_auxiliary_2 AS TA2 ON TA1.year = TA2.year ;
 -- Vytvoření hlavní první tabulky - ceny jednotlivých potravin za jednotlivé roky a k nim průměrná mzda v daném roce. 
