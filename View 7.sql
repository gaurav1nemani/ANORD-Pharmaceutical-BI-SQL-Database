--View 7
--Sales Concentration by Client (Pareto Analysis)
--This view shows the % of total sales that comes from each client
--Example of pareto like analysis is: to check if 80% of sales come from 20% of clients
--To calculate this we need total sales and percentage sales

CREATE VIEW View_7 AS
WITH sales_total_table AS(
SELECT SUM(ip.quantity * p.price) as sales_total
FROM invoice_products ip INNER JOIN product p USING(id_prod)
)

SELECT c.name as client_name,
		TO_CHAR(SUM(ip.quantity * p.price), '€FM999G999G999D00') as total_sales,
		COALESCE('%'||ROUND((SUM(ip.quantity * p.price)/(SELECT sales_total FROM sales_total_table))*100, 2), '0%') as sales_percentage
FROM client c INNER JOIN branch b USING (id_client)
	INNER JOIN invoice i USING (id_branch)
	INNER JOIN invoice_products ip USING (id_invoice)
	INNER JOIN product p USING (id_prod)
GROUP BY 1
ORDER BY 2 DESC
;
