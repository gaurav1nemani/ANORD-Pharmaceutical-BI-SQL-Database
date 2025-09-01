--View 2.2

CREATE VIEW View_2_2 AS
SELECT product.name AS product_name,

       -- Calculate sales in August 2024
       TO_CHAR(COALESCE(
           (SELECT SUM(invoice_products.quantity * product.price)
            FROM invoice_products
            JOIN invoice ON invoice_products.id_invoice = invoice.id_invoice
            WHERE invoice_products.id_prod = product.id_prod
            AND EXTRACT('year' FROM invoice.date) = 2024
            AND EXTRACT('month' FROM invoice.date) = 8
           ), 0), '€FM999G999G999D00') AS sales_in_august_2024,

       -- Calculate sales in August 2023
       TO_CHAR(COALESCE(
           (SELECT SUM(invoice_products.quantity * product.price)
            FROM invoice_products
            JOIN invoice ON invoice_products.id_invoice = invoice.id_invoice
            WHERE invoice_products.id_prod = product.id_prod
            AND EXTRACT('year' FROM invoice.date) = 2023
            AND EXTRACT('month' FROM invoice.date) = 8
           ), 0), '€FM999G999G999D00') AS sales_in_august_2023,

       -- Calculate the difference in sales
       TO_CHAR((COALESCE(
           (SELECT SUM(invoice_products.quantity * product.price)
            FROM invoice_products
            JOIN invoice ON invoice_products.id_invoice = invoice.id_invoice
            WHERE invoice_products.id_prod = product.id_prod
            AND EXTRACT('year' FROM invoice.date) = 2024
            AND EXTRACT('month' FROM invoice.date) = 8
           ), 0) 
       - 
       COALESCE(
           (SELECT SUM(invoice_products.quantity * product.price)
            FROM invoice_products
            JOIN invoice ON invoice_products.id_invoice = invoice.id_invoice
            WHERE invoice_products.id_prod = product.id_prod
            AND EXTRACT('year' FROM invoice.date) = 2023
            AND EXTRACT('month' FROM invoice.date) = 8
           ), 0)), '€FM999G999G999D00') AS sales_difference,

       -- Calculate percentage change from 2023 to 2024
       COALESCE('%'||ROUND(((COALESCE(
           (SELECT SUM(invoice_products.quantity * product.price)
            FROM invoice_products
            JOIN invoice ON invoice_products.id_invoice = invoice.id_invoice
            WHERE invoice_products.id_prod = product.id_prod
            AND EXTRACT('year' FROM invoice.date) = 2024
            AND EXTRACT('month' FROM invoice.date) = 8
           ), 0) 
       / 
       NULLIF(
           COALESCE(
               (SELECT SUM(invoice_products.quantity * product.price)
                FROM invoice_products
                JOIN invoice ON invoice_products.id_invoice = invoice.id_invoice
                WHERE invoice_products.id_prod = product.id_prod
                AND EXTRACT('year' FROM invoice.date) = 2023
                AND EXTRACT('month' FROM invoice.date) = 8
           ), 0), 0)) - 1) * 100, 2), '0%') AS percent_change,

       -- Find the top client who bought the most product in August 2024
       COALESCE(
  (SELECT client.name
   FROM invoice_products
   JOIN invoice ON invoice_products.id_invoice = invoice.id_invoice
   JOIN branch ON invoice.id_branch = branch.id_branch
   JOIN client ON branch.id_client = client.id_client
   WHERE invoice_products.id_prod = product.id_prod
   AND EXTRACT('year' FROM invoice.date) = 2024
   AND EXTRACT('month' FROM invoice.date) = 8
   GROUP BY client.name
   ORDER BY SUM(invoice_products.quantity * product.price) DESC, client.name ASC
   LIMIT 1
  ), 'No sales') AS top_client_in_august_2024


-- Perform the query on all products
FROM product

-- Order by sales difference in descending order
ORDER BY sales_difference

-- Limit to top 10 products (worst to best)
LIMIT 10;
  