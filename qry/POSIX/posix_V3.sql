open schema pb_playground;
--/
CREATE OR REPLACE LUA SCALAR SCRIPT posix_time_micro (datetime_micro VARCHAR(26))
    RETURNS NUMBER AS
function run(ctx)
  s = ctx.datetime_micro
  
  -- list of cummulative days yeartodate for each month 
  -- If in January, no day, a Febuary day has 31 for the previous month, etc...
  months= {0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334}

  -- year relative to 1970 / younger date will get negative value
  year_value = string.sub(s, 1, 4)
  
  -- days for all closed months in the current year
  month_value = tonumber(string.sub(s, 6, 7))
  month= months[month_value]
  -- days before today
  day  = string.sub(s, 9, 10) - 1
  
  if (year_value % 4 == 0) and (year_value % 100 ~= 0) or (year_value % 1000 == 0) then
    -- "Schaltjahr"
    if month_value>2 then
      month= month + 1
    end
  end
  
  years = year_value - 1970
  if years > 0 then
    extradays = math.floor((years + 1)/4) - math.floor((years + 69)/100) + math.floor((years + 969)/1000)
  elseif years < 0 then
    extradays = math.ceil((years - 1)/4) + math.ceil((years - 30)/100) - math.ceil((years - 30)/1000)
  else
    extradays = 0
  end
  day = day + extradays
  
  -- hours, minutes, seconds, microseconds since today 00:00:00.000 000
  hour  = string.sub(s, 12, 13) 
  minute= string.sub(s, 15, 16)
  second= string.sub(s, 18, 19)
  micsec= "0."..string.sub(s, 21, 26)

  -- print(years, month, day, extradays)
  -- print(hour, minute, second, micsec)

  res = (((years * 365 + month + day) * 24 + hour) * 60 + minute) * 60 + second + micsec
  res = micsec + second + 60 * (minute + 60 *(hour + 24 * (years * 365 + month + day)))
  
  return res
end  
/

ALTER SESSION SET TIME_ZONE='UTC';
SELECT 
  POSIX_TIME('1988-03-01 00:00:01.770001') PT1
  , POSIX_TIME_micro('1988-03-01 00:00:01.770001') PT2 -- 
;
