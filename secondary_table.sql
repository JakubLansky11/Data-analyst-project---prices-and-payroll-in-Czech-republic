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