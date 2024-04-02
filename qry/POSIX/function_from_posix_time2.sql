--/
CREATE OR REPLACE FUNCTION from_posix_time2 (n number)
   RETURN CHAR(26)
   IS
     res CHAR(26);
   BEGIN
     -- wrapper for from_posix_time, except the precission
     res := left(from_posix_time(n), 20) || right(n, 6);
     RETURN res;
   END from_posix_time2;
/
select from_posix_time2(22.346585);

select from_posix_time(22.346585);

--/
CREATE OR REPLACE FUNCTION from_posix_time2 (n DECIMAL(19,9))
   RETURN CHAR(29)
   BEGIN
     -- wrapper for from_posix_time, except the precission, trauncte at index 20 to avoid rounding by from_posix_time()
     RETURN left(from_posix_time(n), 20) || right(n, 6);
   END from_posix_time2;
/