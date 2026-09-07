-- Annual material distribution totals and estimated cost

SELECT
    strftime('%Y', d.distribution_date)         AS distribution_year,
    m.material_name,
    m.category,
    SUM(d.quantity)                               AS total_units,
    ROUND(SUM(d.quantity) * m.unit_cost, 2)       AS estimated_cost
FROM material_distributions d
JOIN materials m ON m.material_id = d.material_id
GROUP BY strftime('%Y', d.distribution_date), m.material_name, m.category, m.unit_cost
ORDER BY distribution_year, total_units DESC;
