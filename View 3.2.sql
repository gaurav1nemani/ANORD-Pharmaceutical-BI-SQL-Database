--View 3.2

CREATE VIEW View_3_2 AS
SELECT 
    c.name AS client_name, 
    p.name AS product_name,
    TO_CHAR((COALESCE(SUM(ip.quantity * p.price), 0)), '€FM999G999G999D00') AS total_sales,
    TO_CHAR((COALESCE(SUM(ip.quantity * p.cost), 0)), '€FM999G999G999D00') AS total_cost,
    
 /*profitability %*/ 
    COALESCE('%'||ROUND(((SUM(ip.quantity * p.price) - SUM(ip.discount * ip.quantity) - SUM(ip.quantity * p.cost)) / 
      SUM(ip.quantity * p.price)) * 100,2), '0%') AS profitability_percentage,
    
   /*discount %*/
    COALESCE('%'||ROUND(((SUM(ip.discount * ip.quantity) / 
     SUM(ip.quantity * p.price)) * 100),2), '0%') AS discount_percentage

     
FROM client c
	JOIN branch b USING (id_client)
	JOIN invoice i USING (id_branch)
	JOIN invoice_products ip USING (id_invoice)
	JOIN product p USING (id_prod)
WHERE EXTRACT(MONTH FROM i.date) = 8
GROUP BY c.name, p.name, c.id_client, p.id_prod
ORDER BY profitability_percentage DESC  /*Here it is important to have them ascending to have the worst profitability*/
LIMIT 10;  /*TOP 10 best*/