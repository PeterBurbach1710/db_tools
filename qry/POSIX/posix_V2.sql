--/
CREATE
OR REPLACE LUA SCALAR SCRIPT PBB.posix_time_micro (datetime_micro VARCHAR(26)) RETURNS NUMBER AS -- DECIMAL(36, 6) AS
FUNCTION run(ctx) datetime_micro = ctx.datetime_micro IF datetime_micro == NULL THEN RETURN NULL
END -- to find the decimal separator
posDecimal = STRING .find(datetime_micro, '[.]') -- only take three digits after the 3rd decimal
microSec = STRING .sub(datetime_micro, posDecimal + 4, posDecimal + 7) dtt = { YEAR = 1970,
MONTH = 1,
DAY = 12,
HOUR = 0,
MINUTE = 0,
SECOND = 1 } dt = os.time(dt, os.time() + 1 * 60 * 60) dt = (1970 -1970) * 365 + (1 * 31) RETURN tonumber(dt) -- posix_time(datetime_micro) + tonumber("0.000"..microSec)
END / ALTER SESSION
SET
  TIME_ZONE = 'UTC';
SELECT
  POSIX_TIME('1970-01-12 00:00:01.000000') PT1,
  PBB.POSIX_TIME_micro('1970-01-12 00:00:01.000000') PT2 -- 950401.103 333
;