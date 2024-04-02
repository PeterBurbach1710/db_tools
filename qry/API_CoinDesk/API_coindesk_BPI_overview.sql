-- --------------------------
-- Source
-- --------------------------
-- API Coindesk BPI
https://www.coindesk.com/coindesk-api
https://api.coindesk.com/v1/bpi/historical/close.json?start=2013-09-01&end=2013-09-05
;








-- --------------------------
-- Target
-- --------------------------
-- STAGING
SELECT bpi_date, bpi_price 
FROM stg_cod_bpi
ORDER BY bpi_date DESC;

-- Target fact table
SELECT * 
FROM f_bpi
ORDER BY bpi_date DESC;

-- --------------------------
-- Processing
-- --------------------------
-- Call of API with Python UDF
SELECT get_api_coindesk_bpi_data(10);

-- Execute Script (based on Lua) for complete processing
EXECUTE SCRIPT load_cod_bpi() WITH OUTPUT;

-- --------------------------
-- Tests
-- --------------------------
-- For testing versioning
UPDATE f_bpi 
SET bpi_price = 1
WHERE bpi_date = DATE'2020-12-28' AND effective_to IS NULL;
;
DELETE 
FROM f_bpi
WHERE bpi_date = DATE'2020-12-29';

