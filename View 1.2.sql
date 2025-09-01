/*VIEW 1.2*/
CREATE VIEW view_1_2 AS
-- Get sales for August 2023
WITH august_2023_sales AS (
  	SELECT branch.id_client AS client_id,  -- selecting client id and summing up sales
         SUM(product.price * invoice_products.quantity) AS total_sales_august_2023
  	FROM invoice
 	 INNER JOIN invoice_products USING (id_invoice)
  	INNER JOIN product ON invoice_products.id_prod = product.id_prod
  	INNER JOIN branch ON invoice.id_branch = branch.id_branch
  	WHERE EXTRACT('year' FROM invoice.date) = 2023  -- Only sales from 2023
  	AND EXTRACT('month' FROM invoice.date) = 8      
  	GROUP BY branch.id_client
),

-- Get sales for August 2024
august_2024_sales AS (
  	SELECT branch.id_client AS client_id,  -- selecting client id and summing up sales
         SUM(product.price * invoice_products.quantity) AS total_sales_august_2024
  	FROM invoice
  	INNER JOIN invoice_products ON invoice.id_invoice = invoice_products.id_invoice
  	INNER JOIN product ON invoice_products.id_prod = product.id_prod
  	INNER JOIN branch ON invoice.id_branch = branch.id_branch
  	WHERE EXTRACT('year' FROM invoice.date) = 2024  -- Only sales from 2024
  	AND EXTRACT('month' FROM invoice.date) = 8      
  	GROUP BY branch.id_client
)

-- Compare sales for August 2023 and 2024
SELECT client.name, 
       TO_CHAR((COALESCE(august_2024_sales.total_sales_august_2024, 0)), '€FM999G999G999D00') AS sales_in_august_2024,
       TO_CHAR(COALESCE(august_2023_sales.total_sales_august_2023, 0), '€FM999G999G999D00') AS sales_in_august_2023,
       COALESCE('%'||ROUND(COUNT(DISTINCT branch.id_branch) FILTER (WHERE invoice.date >= '2024-08-01' AND invoice.date <= '2024-08-31')::decimal / COUNT(DISTINCT branch.id_branch) * 100, 2), '0%') AS percent_branches_with_sales,
       TO_CHAR(ROUND((august_2024_sales.total_sales_august_2024 - august_2023_sales.total_sales_august_2023),2), '€FM999G999G999D00') AS sales_difference,
       COALESCE('%'||ROUND((((total_sales_august_2024) / (total_sales_august_2023) - 1) * 100),2), '0%') AS percent_vs_aug_2023
FROM client
-- Join sales data for 2023
INNER JOIN august_2023_sales ON client.id_client = august_2023_sales.client_id
-- Join sales data for 2024
INNER JOIN august_2024_sales ON client.id_client = august_2024_sales.client_id
INNER JOIN branch ON branch.id_client=client.id_client
INNER JOIN invoice ON branch.id_branch = invoice.id_branch
GROUP BY 1, august_2024_sales.total_sales_august_2024, august_2023_sales.total_sales_august_2023
-- Order results by the sales difference, descending
ORDER BY sales_difference
-- Limit to top 10 clients
LIMIT 10;
/* In the output we can visualize the top 10 customer with the worst to best performance ordered by descending, versus last year same month*/
