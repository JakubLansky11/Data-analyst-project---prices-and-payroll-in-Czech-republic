CREATE TABLE t_pomocna_tabulka_1
SELECT
    name,
    SUM (value) / COUNT (value) AS Cena,
    price_value AS Hodnota,
    price_unit AS Jednotka,
    YEAR(date_to) AS Rok
FROM czechia_price
JOIN czechia_price_category ON czechia_price.category_code = czechia_price_category.code
GROUP BY Rok, name
ORDER BY name, Rok ;
# Vytvoření pomocné tabulky - ceny potravin

CREATE TABLE t_pomocna_tabulka_2
SELECT
    payroll_year AS Rok,
    SUM (value) / COUNT (value) AS Mzda
FROM czechia_payroll
JOIN czechia_payroll_industry_branch 
    ON czechia_payroll.industry_branch_code = czechia_payroll_industry_branch.code
WHERE value_type_code LIKE 5958 and value IS NOT NULL and calculation_code LIKE 100
GROUP BY payroll_year
ORDER BY payroll_year ASC ;
# Vytvoření pomocné tabulky - údaje o průměrné mzdě za jednotlivé roky

CREATE TABLE t_Jakub_Lansky_project_SQL_primary_final
SELECT 
    name,
    Cena,
    Hodnota,
    Jednotka,
    t_pomocna_tabulka_1.Rok,
    Mzda
From t_pomocna_tabulka_1
JOIN t_pomocna_tabulka_2 ON t_pomocna_tabulka_1.Rok = t_pomocna_tabulka_2.Rok ;
 # Vytvoření hlavní první tabulky - ceny jednotlivých potravin za jednotlivé roky a k nim průměrná mzda v daném roce. 

SELECT
    name AS Odvětví,
    payroll_year AS Rok,
    SUM (value) / COUNT (value) AS "Průměrná mzda"
FROM czechia_payroll
JOIN czechia_payroll_industry_branch 
    ON czechia_payroll.industry_branch_code = czechia_payroll_industry_branch.code
WHERE value_type_code LIKE 5958 and value IS NOT NULL and calculation_code LIKE 100
GROUP BY payroll_year, name
ORDER BY name ASC, payroll_year ASC, payroll_quarter ASC ;
 # Odpověď na otázku číslo 1 - Průměrná mzda v jednotlivých letech pro každé odvětví.
 # Z dat je vidět rostoucí trend ve všech odvětvích.

SELECT
    Mzda / Cena AS "Množství másla",
    Jednotka,
    Rok
FROM t_Jakub_Lansky_project_SQL_primary_final
WHERE name LIKE "%máslo%"
ORDER BY Rok ASC
Limit 1 ;
 # Odpověď na otázku číslo 2 - Množství másla, které šlo za průměrnou mzdu koupit při nejstarším období

SELECT
    Mzda / Cena AS "Množství másla",
    Jednotka,
    Rok
FROM t_Jakub_Lansky_project_SQL_primary_final
WHERE name LIKE "%máslo%"
ORDER BY Rok DESC
Limit 1 ;
 # Odpověď na otázku číslo 2 - Množství másla, které šlo za průměrnou mzdu koupit při nejmladším období

SELECT
    Mzda / Cena AS "Množství mléka",
    Jednotka,
    Rok
FROM t_Jakub_Lansky_project_SQL_primary_final
WHERE name LIKE "%mléko%"
ORDER BY Rok ASC
Limit 1 ;
 # Odpověď na otázku číslo 2 - Množství mléka, které šlo za průměrnou mzdu koupit při nejstarším období

SELECT
    Mzda / Cena AS "Množství mléka",
    Jednotka,
    Rok
FROM t_Jakub_Lansky_project_SQL_primary_final
WHERE name LIKE "%mléko%"
ORDER BY Rok DESC
Limit 1 ;
 # Odpověď na otázku číslo 2 - Množství mléka, které šlo za průměrnou mzdu koupit při nejmladším období

SELECT
    name,
    ((MAX(Cena) - MIN(Cena)) / MIN(Cena)) *100 AS Narust
FROM t_Jakub_Lansky_project_SQL_primary_final
GROUP BY name
ORDER BY Narust ;
# Odpověď na otázku číslo 3 - Procentuální nárůst cen jednotlivých potravin během sledovaného období
# Z dat vychází, že největší nárůst je u másla a nejnižší u vína

CREATE TABLE t_pomocna_tabulka_3
SELECT
    Rok,
    SUM(Cena) / COUNT(Cena) AS Prumer_cena_potravin,
    Mzda
FROM t_Jakub_Lansky_project_SQL_primary_final
GROUP BY Rok
ORDER BY Rok

SELECT
    Rok,
    (Prumer_cena_potravin - LAG(Prumer_cena_potravin, 1) OVER (ORDER BY Rok)) / LAG(Prumer_cena_potravin, 1) OVER (ORDER BY Rok) * 100 Rocni_narust_cen,
    (Mzda - LAG(Mzda, 1) OVER (ORDER BY Rok)) / LAG(Mzda, 1) OVER (ORDER BY Rok) * 100 Rocni_narust_mzdy
FROM t_pomocna_tabulka_3

# Odpověď na otázku číslo 4 - Roční procentuální nárůst všech cen a roční procentuální nárůst mezd. 
# Nejvyšší nárůst cen potravin 9,63 % v roce 2017, v některých letech pokles. 
# Nejvyšší negativní rozdíl mezi nárůstem cen a mezd v roce 2013, kdy narostly ceny o 5,10 %, ale mzdy klesly o 1,56 % - rozdíl 6,66 %. 
# Naopak vysoký pokles cen v roce 2009 (pokles o 6,41 %), zatímco nárůst mezd o 3,25 % - rozdíl 9,76 %. 

SELECT
    Rok, 
    (GDP - LAG(GDP, 1) OVER (ORDER BY Rok)) / LAG(GDP, 1) OVER (ORDER BY Rok) * 100 Rocni_zmena_HDP,
    (Prumer_cena_potravin - LAG(Prumer_cena_potravin, 1) OVER (ORDER BY Rok)) / LAG(Prumer_cena_potravin, 1) OVER (ORDER BY Rok) * 100 Rocni_narust_cen,
    (Mzda - LAG(Mzda, 1) OVER (ORDER BY Rok)) / LAG(Mzda, 1) OVER (ORDER BY Rok) * 100 Rocni_narust_mzdy,
    GDP AS "HDP v ČR"
FROM t_pomocna_tabulka_3
JOIN economies ON economies.Year = t_pomocna_tabulka_3.Rok WHERE country LIKE "Czech republic"
ORDER BY Rok
# Odpověď na otázku číslo 5 - Roční procentuální nárůst všech cen a roční procentuální nárůst mezd a HDP v ČR. 
# Z dat nevychází příliš velká korelace HDP a růstem cen potravin a růstem mezd.  

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