SELECT
    name AS job_category,
    payroll_year AS year,
    SUM(value) / COUNT(value) AS average_payroll
FROM czechia_payroll
JOIN czechia_payroll_industry_branch 
    ON czechia_payroll.industry_branch_code = czechia_payroll_industry_branch.code
WHERE value_type_code LIKE 5958 AND value IS NOT NULL AND calculation_code LIKE 100
GROUP BY payroll_year, name
ORDER BY name ASC, payroll_year ASC, payroll_quarter ASC ;
 /* Odpověď na otázku číslo 1 - Průměrná mzda v jednotlivých letech pro každé odvětví.
 Z dat je vidět rostoucí trend růstu mzdy ve všech odvětvích. Pouze v roce 2013 je pokles v některých odvětvích. */