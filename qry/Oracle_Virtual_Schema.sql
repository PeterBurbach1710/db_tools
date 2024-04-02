SELECT
    *
FROM
    oracle_virtual_schema.article
LIMIT
    10;
SELECT
    round(SUM(sap.amount)),
    trunc(SUM(sap.price), 2),
    art.product_group_desc
FROM
    oracle_virtual_schema.sales_positions sap
    INNER JOIN oracle_virtual_schema.article art ON art.article_id = sap.article_id
GROUP BY
    art.product_group_desc;