CREATE TABLE t_auxiliary_3
SELECT
    year,
    SUM(Price) / COUNT(Price) AS average_price,
    payroll
FROM t_Jakub_Lansky_project_SQL_primary_final
GROUP BY Year
ORDER BY Year

SELECT
    year,
    (Average_price - LAG(Average_price, 1) OVER(ORDER BY Year)) / LAG(Average_price, 1) OVER(ORDER BY Year) * 100 AS price_year_difference,
    (Payroll - LAG(Payroll, 1) OVER(ORDER BY Year)) / LAG(Payroll, 1) OVER(ORDER BY Year) * 100 AS payroll_year_difference
FROM t_auxiliary_3

/* Odpověď na otázku číslo 4 - Roční procentuální nárůst všech cen a roční procentuální nárůst mezd. 
Nejvyšší nárůst cen potravin 9,63 % v roce 2017, v některých letech pokles. 
Nejvyšší negativní rozdíl mezi nárůstem cen a mezd v roce 2013, kdy narostly ceny o 5,10 %, ale mzdy klesly o 1,56 % - rozdíl 6,66 %. 
Naopak vysoký pokles cen v roce 2009 (pokles o 6,41 %), zatímco nárůst mezd o 3,25 % - rozdíl 9,76 %. */
