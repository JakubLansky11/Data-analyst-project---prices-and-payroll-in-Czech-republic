SELECT
    TA3.Year, 
    (GDP - LAG(GDP, 1) OVER(ORDER BY Year)) / LAG(GDP, 1) OVER(ORDER BY Year) * 100 AS GDP_year_difference,
    (Average_price - LAG(Average_price, 1) OVER (ORDER BY Year)) / LAG(Average_price, 1) OVER(ORDER BY Year) * 100 AS price_year_difference,
    (Payroll - LAG(Payroll, 1) OVER(ORDER BY Year)) / LAG(Payroll, 1) OVER(ORDER BY Year) * 100 AS payroll_year_difference,
    GDP AS "GDP_Czech_republic"
FROM t_auxiliary_3 as TA3
JOIN economies ON economies.Year = TA3.Year WHERE country LIKE "Czech republic"
ORDER BY TA3.Year
/* Odpověď na otázku číslo 5 - Roční procentuální nárůst všech cen a roční procentuální nárůst mezd a HDP v ČR. 
HDP záviselo na cenách potravin a na mzdách. 
V roce nárůstu cen a mezd rostlo HDP Naopak když v roce 2009 klesly ceny potravin, kleslo také HDP. 
Stejně tak v roce 2013 při poklesu mezd také kleslo HDP.  */
