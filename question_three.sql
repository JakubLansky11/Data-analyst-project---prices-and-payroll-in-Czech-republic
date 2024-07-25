SELECT
    name,
    ((MAX(price) - MIN(price)) / MIN(price)) *100 AS difference
FROM t_Jakub_Lansky_project_SQL_primary_final
GROUP BY name
ORDER BY difference ;
/* Odpověď na otázku číslo 3 - Procentuální nárůst cen jednotlivých potravin během sledovaného období
Z dat vychází, že potraviny stále nezdražují, ale ceny jednotlivých potravin   různě rostou a klesají. Nejvíce zdražilo máslo. 
Cukr a rajčata mají na konci období nižší cenu než na začátku. U vína chybí údaje z let před rokem 2015.  */