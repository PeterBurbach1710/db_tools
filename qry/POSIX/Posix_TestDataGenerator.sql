open schema pb_playground;
--/
CREATE OR REPLACE SCRIPT posix_dummy_creator(number_of_unique_rows, aprox_number_of_total_rows) AS
        function log(value, base)
                return math.log(value)/math.log(base)
        end
        
        query([[CREATE OR REPLACE TABLE posix(ts_string CHAR(26), pt1 DECIMAL(36,6), pt2 DECIMAL(36,6))]])
        
        for i=0, number_of_unique_rows-1
                do
                        query([[INSERT INTO posix (ts_string)
                                WITH posix_sub (ts) AS (SELECT from_posix_time(rand(0,1623911170)))
                                SELECT LEFT(ts,23)||truncate(rand(100,999),0) FROM posix_sub]])
                end
        
        local duplication_factor = log(aprox_number_of_total_rows/number_of_unique_rows, 2)
        for i=0, math.ceil(duplication_factor)-1
                do
                        query([[INSERT INTO posix SELECT * FROM posix]])
                end
        
/

EXECUTE SCRIPT posix_dummy_creator(2500, 50000000) with output;

SELECT  ts_string,
        length(ts_string), 
        posix_time(ts_string),
        right(ts_string,3)
        from posix
LIMIT 1;
create or replace table string_test (string varchar(2000));
insert into string_test values ('dies_ist_ein_test');
select right(string,3) from string_test;


with qry as (
        SELECT  ts_string ts_orig
        --        , posix_time(ts_string)
        --        , right(ts_string,3)
                , POSIX_TIME_micro(ts_string) POSIX_MICRO
                , POSIX_TIME(ts_string) POSIX_ORIG
                , trunc(POSIX_TIME_micro(ts_string),3) POSIX_TEST
                , from_posix_time(trunc(POSIX_TIME_micro(ts_string), 3)) ts_string_ist
                , from_posix_time(posix_time(ts_string)) ts_string_soll
                from posix
)--                LIMIT 100000)
select * from qry
where to_char(posix_orig)!=to_char(posix_test) or to_char(ts_string_ist)!=to_char(ts_string_soll)
