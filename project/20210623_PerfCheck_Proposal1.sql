open schema playground;
SET AUTOCOMMIT OFF;
ALTER SESSION SET PROFILE = 'ON';

WITH 
start_ende_gruenphase AS (
    SELECT signalgruppe_id,
           zeitpunkt AS zeitpunkt_start,
           lead(zeitpunkt, 1) over (partition by signalgruppe_id order by zeitpunkt) AS zeitpunkt_ende,
           status status_start,
           lead(status, 1) over (partition by signalgruppe_id order by zeitpunkt) AS status_ende,
           TRUNC(zeitpunkt, 'HH') AS stunde
    FROM signalstatus sig
)
select
signalgruppe_id,
stunde,
avg(SECONDS_BETWEEN(zeitpunkt_ende, zeitpunkt_start) + 1) freigabezeit_sec
from start_ende_gruenphase
where status_start='A' and status_ende='S'
group by signalgruppe_id, stunde
;

FLUSH STATISTICS;

SELECT * FROM EXA_USER_PROFILE_LAST_DAY WHERE SESSION_ID = CURRENT_SESSION ORDER BY STMT_ID, PART_ID;