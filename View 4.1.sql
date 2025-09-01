--View 4.1

CREATE VIEW View_4_1 AS
WITH most_bought_product AS (
    SELECT c.id_client, p.id_prod AS top_product, 
           SUM(price * quantity) AS prod_sales_aug
    FROM product p 
    INNER JOIN invoice_products ip USING (id_prod)
    INNER JOIN invoice i USING (id_invoice)
    INNER JOIN branch b USING (id_branch)
    INNER JOIN client c USING (id_client)
    WHERE EXTRACT('month' FROM i.date) = 8
    GROUP BY c.id_client, p.id_prod
    ORDER BY SUM(price * quantity) DESC
    LIMIT 10
)
SELECT COALESCE(c.name, c.Contact_name) AS client_name
,
       TO_CHAR(SUM(price * quantity),'€FM999G999G999D00')AS sales_total_aug,
       COALESCE( '%' || ROUND((SUM(ip.discount * ip.quantity )) / (SUM(price * quantity)) * 100, 5), '0%') AS percent_discount_totalsales,
       COALESCE ( '%' || ROUND(((SUM(price * quantity) - SUM(ip.discount) - SUM(p.cost)) / SUM(price * quantity)) * 100, 2), '0%') AS percent_profitability,
       mbp.top_product AS most_bought_product
FROM client c 
INNER JOIN branch b USING (id_client)
INNER JOIN invoice i USING (id_branch)
INNER JOIN invoice_products ip USING (id_invoice)
INNER JOIN product p USING (id_prod)
INNER JOIN most_bought_product mbp ON c.id_client = mbp.id_client  -- Join with the common key
WHERE EXTRACT('month' FROM i.date) = 8
GROUP BY c.name, c.Contact_name, mbp.top_product
ORDER BY percent_profitability DESC
LIMIT 10; --TOP client with best profitability