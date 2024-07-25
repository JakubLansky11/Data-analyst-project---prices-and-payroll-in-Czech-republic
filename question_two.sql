SELECT
    Payroll / Price AS bread_amount,
    unit,
    year
FROM t_Jakub_Lansky_project_SQL_primary_final
WHERE name LIKE "%chléb%"
ORDER BY Year ASC
Limit 1 ;
 -- Odpověď na otázku číslo 2 - Množství chleba, které šlo za průměrnou mzdu koupit při nejstarším období

SELECT
    Payroll / Price AS bread_amount,
    unit,
    year
FROM t_Jakub_Lansky_project_SQL_primary_final
WHERE name LIKE "%chléb%"
ORDER BY Year DESC
Limit 1 ;
 -- Odpověď na otázku číslo 2 - Množství chleba, které šlo za průměrnou mzdu koupit při nejmladším období

SELECT
    Payroll / Price AS milk_amount,
    unit,
    year
FROM t_Jakub_Lansky_project_SQL_primary_final
WHERE name LIKE "%mléko%"
ORDER BY Year ASC
Limit 1 ;
 -- Odpověď na otázku číslo 2 - Množství mléka, které šlo za průměrnou mzdu koupit při nejstarším období

SELECT
    Payroll / Price AS milk_amount,
    unit,
    year
FROM t_Jakub_Lansky_project_SQL_primary_final
WHERE name LIKE "%mléko%"
ORDER BY Year DESC
Limit 1 ;
 -- Odpověď na otázku číslo 2 - Množství mléka, které šlo za průměrnou mzdu koupit při nejmladším období