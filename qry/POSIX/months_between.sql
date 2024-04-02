select months_between('2021-06-22','2021-03-18') x
,months_between('2021-06-20','2021-02-10') x2
, months_between('2021-06-22 14:00:14.123444555','2021-03-18 03:00:08.123444555') y
, months_between(
        to_timestamp('2021-06-22 14:00:14.123444555')
        ,to_timestamp('2021-03-18 03:00:08.123444555')) z