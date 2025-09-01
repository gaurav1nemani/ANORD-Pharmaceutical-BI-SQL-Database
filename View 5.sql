-- View 5

CREATE VIEW View_5 AS
WITH top_clients_table AS -- find the top client
(
	SELECT c.name as top_client
	FROM client c INNER JOIN branch b USING (id_client)
		INNER JOIN invoice i USING (id_branch)
		INNER JOIN invoice_products ip USING (id_invoice)
	WHERE EXTRACT('year' FROM i.date)=2024 AND EXTRACT('month' FROM i.date)=8
	GROUP BY 1
	ORDER BY SUM(ip.quantity) DESC
	LIMIT 1
)

SELECT e.name as sale_rep_name,
		COALESCE(m.name, 'No Manager') as manager_name,
		TO_CHAR(SUM(ip.quantity * p.price), '€FM999G999G999D00') as total_sales_aug2024,
		(SELECT top_client FROM top_clients_table) as top_client_2024, --top client from CTE
		COALESCE('%'||ROUND((SUM(ip.quantity * p.price)/SUM(SUM(ip.quantity * p.price)) OVER (PARTITION BY e.reports_to)) * 100, 2), '0%') as percent_manager_sales, --Partition and sum to find the sales done by manager and then calculate %
		COUNT(DISTINCT b.id_client) as nbr_clients,
		TO_CHAR(SUM(ip.quantity * p.price)/15, '€FM999G999G999D00') as sales_last_15days -- sales in last 15 days
FROM employee e LEFT JOIN employee m ON e.reports_to=m.id_employee
	INNER JOIN invoice i ON e.id_employee = i.id_employee
	INNER JOIN invoice_products ip USING (id_invoice)
	INNER JOIN product p USING (id_prod)
	INNER JOIN branch b USING (id_branch)
WHERE EXTRACT('year' FROM i.date)=2024 AND EXTRACT('month' FROM i.date)=8
GROUP BY 1, 2, e.reports_to
ORDER BY 3 DESC
LIMIT 10
;