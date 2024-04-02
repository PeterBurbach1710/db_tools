--select * from exa_volume_usage;
--select * from exa_statistics_object_sizes;
--select * from exa_clusters;
--select * from exa_db_size_daily where interval_start>sysdate-99 order by 2 desc;
--select * from exa_monitor_daily where interval_start>sysdate-99 order by 2 desc;
--select * from exa_usage_daily where interval_start>sysdate-99 order by 2 desc;
--select * from exa_db_size_monthly where interval_start>sysdate-365 order by 2 desc;
--select * from exa_monitor_monthly where interval_start>sysdate-365 order by 2 desc;
--select * from exa_usage_monthly where interval_start>sysdate-365 order by 2 desc;
--select * from exa_sql_daily limit 10;

/* *******************************************************************************************
**  DB Statistics (always: currently, max(last XX days), avg(last XX days), median( XX days)
******************************************************************************************* */
with 
param as (select 99 statistic_days)
, db_size as (
        -- all KPIs are based on GiB!
        select cluster_name, interval_start
        , raw_object_size_max RAW_OBJECT_SIZE, max(raw_object_size_max) over () RAW_OBJECT_SIZE_MAX, avg(raw_object_size_avg) over () RAW_OBJECT_SIZE_AVG
        , mem_object_size_max MEM_OBJECT_SIZE, max(mem_object_size_max) over () MEM_OBJECT_SIZE_MAX, avg(mem_object_size_avg) over () MEM_OBJECT_SIZE_AVG
        , auxiliary_size_max AUXILIARY_SIZE, max(auxiliary_size_max) over () AUXILIARY_SIZE_MAX, avg(auxiliary_size_avg) over () AUXILIARY_SIZE_AVG
        , statistics_size_max STATISTICS_SIZE, max(statistics_size_max) over () STATISTICS_SIZE_MAX, avg(statistics_size_avg) over () STATISTICS_SIZE_AVG
        , recommended_db_ram_size_max RECOMMENDED_DB_RAM_SIZE, max(recommended_db_ram_size_max) over () RECOMMENDED_DB_RAM_SIZE_MAX, avg(recommended_db_ram_size_avg) over () RECOMMENDED_DB_RAM_SIZE_AVG
        , raw_object_size_max/storage_size_max COMPRESSION_FACTOR, max(raw_object_size_max/storage_size_max) over () COMPRESSION_FACTOR_MAX, avg(raw_object_size_avg/storage_size_avg) over () COMPRESSION_FACTOR_AVG
        from exa_db_size_daily 
        cross join param
        where interval_start>sysdate-param.statistic_days)
, monitor as (
        -- persistent_db_ram and temp_db_ram are in MiB!
        select interval_start, cpu_avg, cpu_max
        , temp_db_ram_max TEMP_DB_RAM, max(temp_db_ram_max) over () TEMP_DB_RAM_MAX, avg(temp_db_ram_avg) over () TEMP_DB_RAM_AVG
        , persistent_db_ram_max DB_RAM, max(persistent_db_ram_max) over () DB_RAM_MAX, avg(persistent_db_ram_avg) over () DB_RAM_AVG
        from exa_monitor_daily 
        cross join param
        where interval_start>sysdate-param.statistic_days)
select dbs.cluster_name, dbs.interval_start
, mon.DB_RAM, mon.DB_RAM_MAX, mon.DB_RAM_AVG
, dbs.RAW_OBJECT_SIZE, dbs.RAW_OBJECT_SIZE_MAX, dbs.RAW_OBJECT_SIZE_AVG
, dbs.MEM_OBJECT_SIZE, dbs.MEM_OBJECT_SIZE_MAX, dbs.MEM_OBJECT_SIZE_AVG
, dbs.AUXILIARY_SIZE, dbs.AUXILIARY_SIZE_MAX, dbs.AUXILIARY_SIZE_AVG
, dbs.STATISTICS_SIZE, dbs.STATISTICS_SIZE_MAX, dbs.STATISTICS_SIZE_AVG
, dbs.COMPRESSION_FACTOR, dbs.COMPRESSION_FACTOR_MAX, dbs.COMPRESSION_FACTOR_AVG
, mon.TEMP_DB_RAM, mon.TEMP_DB_RAM_MAX, mon.TEMP_DB_RAM_AVG
-- usefull: RECOMMENDED_DB_RAM_SIZE and CPU_AVG, CPU_MAX...??
, dbs.RECOMMENDED_DB_RAM_SIZE, dbs.RECOMMENDED_DB_RAM_SIZE_MAX, dbs.RECOMMENDED_DB_RAM_SIZE_AVG
, mon.CPU_AVG, mon.CPU_MAX
from db_size dbs
inner join monitor mon on mon.interval_start = dbs.interval_start
order by dbs.interval_start desc
;

