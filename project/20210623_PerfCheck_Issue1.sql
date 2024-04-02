open schema playground;
SET AUTOCOMMIT OFF;
ALTER SESSION SET PROFILE = 'ON';

WITH 
start_ende_gruenphase AS (
    SELECT ss_ende.signalgruppe_id,
           max(ss_start.zeitpunkt) AS zeitpunkt_start,
           ss_ende.zeitpunkt       AS zeitpunkt_ende
    FROM signalstatus ss_ende,
         SIGNALSTATUS ss_start
    WHERE ss_ende.status = 'S'
      and ss_start.status = 'A'
      and ss_start.ZEITPUNKT < ss_ende.ZEITPUNKT
      and ss_start.SIGNALGRUPPE_ID = ss_ende.SIGNALGRUPPE_ID
    GROUP BY ss_ende.signalgruppe_id, ss_ende.zeitpunkt
),

     freigabezeiten AS (
         SELECT SIGNALGRUPPE_ID,
                zeitpunkt_start,
                zeitpunkt_ende,
                SECONDS_BETWEEN(zeitpunkt_ende, zeitpunkt_start) + 1 AS freigabezeit_sec
         FROM start_ende_gruenphase
     ),

     freigabezeiten_pro_stunde AS (
         SELECT TRUNC(zeitpunkt_start, 'HH') AS stunde,
                signalgruppe_id,
                avg(freigabezeit_sec)        AS freigabezeit_sec
         FROM freigabeze iten
         GROUP BY TRUNC(zeitpunkt_start, 'HH'), signalgruppe_id
     )

SELECT *
FROM freigabezeiten_pro_stunde;

FLUSH STATISTICS;

SELECT * FROM EXA_USER_PROFILE_LAST_DAY WHERE SESSION_ID = CURRENT_SESSION ORDER BY STMT_ID, PART_ID;