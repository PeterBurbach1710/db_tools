-- Approach 1: RANDOM
-- 1,5m recs/ min
CREATE
OR REPLACE TABLE playground.signalstatus AS WITH qry AS (
        SELECT
                row_number() over () row_num,
                10 * 1000 anz_signalstellen
        FROM
                sys.exa_dba_columns x1,
                sys.exa_dba_columns x2,
                sys.exa_dba_columns x3,
                (
                        SELECT
                                1
                        FROM
                                sys.exa_dba_columns
                        LIMIT
                                5
                ) x4
        LIMIT
                50 * 1000 * 1000
)
SELECT
        MOD(row_num, anz_signalstellen) signalgruppe_id,
        row_num,
        add_minutes(trunc(systimestamp), row_num) zeitpunkt,
        'A' AS status -- START
FROM
        qry
UNION
ALL
SELECT
        MOD(row_num, anz_signalstellen) signalgruppe_id,
        row_num,
        add_seconds(
                add_minutes(trunc(systimestamp), row_num),
                ROUND(RANDOM(1, 60))
        ) zeitpunkt,
        'S' AS status -- ENDE
FROM
        qry;
ALTER session
SET
        query_cache = 'off';
-- 322,186,828
WITH qry AS (
        SELECT
                *
        FROM
                PBB_sales
        WHERE
                sales_timestamp2 >= '2015-04-21 06:00:00'
                AND sales_timestamp2 < '2015-05-22 06:00:00'
        ORDER BY
                sales_timestamp2,
                sales_timestamp
)
SELECT
        *
FROM
        qry;
OPEN schema PBB;
CREATE TABLE PBB_sales AS
SELECT
        sales_timestamp,
        to_char(sales_timestamp, 'YYYY-MM-DD HH24:MI:SS') sales_timestamp2
FROM
        retail.sales