-- --------------------------
-- DDL Tables
-- --------------------------
DROP TABLE "F_BPI";
CREATE TABLE "STG_COD_BPI" (
        "BPI_DATE" DATE,
        "BPI_PRICE" DOUBLE,
        DISTRIBUTE BY "BPI_DATE"
);
CREATE TABLE "F_BPI" (
        "BPI_DATE" DATE,
        "BPI_PRICE" DOUBLE,
        "EFFECTIVE_FROM" TIMESTAMP,
        "EFFECTIVE_TO" TIMESTAMP,
        DISTRIBUTE BY "BPI_DATE"
);
-- --------------------------
-- Python Script get_api_coindesk_bpi_data
-- --------------------------
--/
CREATE
OR REPLACE PYTHON3 SCALAR SCRIPT get_api_coindesk_bpi_data(no_days_to_load DECIMAL) EMITS (bpi_date DATE, bpi_price DOUBLE) AS import urllib.request AS request import json import datetime AS dt def run(ctx): start_date = (
        dt.datetime.today() - dt.timedelta(days = ctx.no_days_to_load)
) .strftime("%Y-%m-%d") end_date = (dt.datetime.today() - dt.timedelta(days = 1)) .strftime("%Y-%m-%d") url = f "https://api.coindesk.com/v1/bpi/historical/close.json?start={start_date}&end={end_date}#" WITH request.urlopen(url) AS response: IF response.getcode() == 200: # -- read api and read output as json
source = response.read() DATA = json.loads(source) # -- loop over each date and display eachs price
FOR DATE,
price IN DATA [ "bpi" ] .items(): # print(DATE, price) ctx.emit(
        dt.datetime.strptime(DATE, '%Y-%m-%d') .date(),
        price
)
ELSE: print(
        "An error occured when trying to reach out to API"
) / -- --------------------------
-- Call "get_api_coindesk_bpi_data"
-- --------------------------
SELECT
        get_api_coindesk_bpi_data(3000);
-- --------------------------
-- Script "load_cod_bpi"
-- --------------------------
--/
CREATE
OR REPLACE SCRIPT load_cod_bpi() AS query([ [ TRUNCATE TABLE stg_cod_bpi ] ]) res = query(
        [ [
        INSERT INTO
                stg_cod_bpi
        SELECT
                get_api_coindesk_bpi_data(3000) ] ]
) output(
        "Number of rows loaded from API   : " .. res.rows_inserted
) res = query(
        [ [ MERGE INTO f_bpi tgt USING stg_cod_bpi src ON (src.bpi_date = tgt.bpi_date)
        WHEN MATCHED THEN
        UPDATE
        SET
                tgt.effective_to = systimestamp
        WHERE
                src.bpi_price != tgt.bpi_price
                AND tgt.effective_to IS NULL ] ]
) output(
        "Number of rows to update on F_BPI: " .. res.rows_updated
) res = query(
        [ [
        INSERT INTO
                f_bpi (bpi_date, bpi_price, effective_from)
        SELECT
                bpi_date,
                bpi_price,
                systimestamp
        FROM
                stg_cod_bpi
        WHERE
                (bpi_date, bpi_price) NOT IN (
                        SELECT
                                bpi_date,
                                bpi_price
                        FROM
                                f_bpi
                        WHERE
                                effective_to IS NULL
                ) ] ]
) output(
        "Number of rows loaded into F_BPI : " .. res.rows_inserted
) / -- --------------------------
-- Execution "load_cod_bpi"
-- --------------------------
EXECUTE SCRIPT load_cod_bpi() WITH OUTPUT;
-- --------------------------
-- SQL to check results
-- --------------------------
SELECT
        bpi_date,
        bpi_price
FROM
        stg_cod_bpi;
SELECT
        *
FROM
        f_bpi;
-- --------------------------
-- DML to manipulate test data
-- --------------------------
-- TRUNCATE TABLE f_bpi;
-- UPDATE f_bpi SET bpi_price = 0 WHERE bpi_date > sysdate - 2 AND effective_to IS NULL;
WITH base AS (
        SELECT
                bpi_date,
                bpi_price,
                IF (bpi_price > lag(bpi_price, 1) over w1)
                AND (
                        lag(bpi_price, 2) over w1 > lag(bpi_price, 1) over w1
                ) THEN 1
                ELSE 0 endif chk_s,
                IF (bpi_price < lag(bpi_price, 1) over w1)
                AND (
                        lag(bpi_price, 2) over w1 < lag(bpi_price, 1) over w1
                ) THEN 1
                ELSE 0 endif chk_b,
                100 - (100 * bpi_price / (AVG(bpi_price) over w2)) hunger_ratio --, max(bpi_price) over w2 max_price_14
,
                AVG(bpi_price) over w2 avg_price_14,
                lag(bpi_price, 1) over w1 p1,
                lag(bpi_price, 2) over w1 p2,
                lag(bpi_price, 3) over w1 p3,
                lag(bpi_price, 4) over w1 p4,
                lag(bpi_price, 5) over w1 p5,
                bpi_price - lag(bpi_price, 1) over w1 speed,
                lag(bpi_price, 1) over w1 - lag(bpi_price, 2) over w1 prev_speed
        FROM
                stg_cod_bpi window w1 AS (
                        ORDER BY
                                bpi_date rows BETWEEN unbounded preceding
                                AND CURRENT ROW
                ),
                w2 AS (
                        ORDER BY
                                bpi_date rows BETWEEN 14 preceding
                                AND CURRENT ROW
                )
        ORDER BY
                bpi_date
)
SELECT
        IF chk_b = 1 THEN 50 / bpi_price endif calc,
        base. *
FROM
        base
WHERE
        chk_s = 1
        OR chk_b = 1