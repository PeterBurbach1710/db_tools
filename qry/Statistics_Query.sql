select * from exa_db_size_daily ;
/* *******************************************************************************************
**  DB Statistics (always: currently, max(last XX days), avg(last XX days), median( XX days)
******************************************************************************************* */
with 
param as (select 99 statistic_days)
, db_size as (
        -- all KPIs are based on GiB!
        select cluster_name, interval_start
        , raw_object_size_max RAW_OBJECT_SIZE, max(raw_object_size_max) over () RAW_OBJECT_SIZE_MAX, avg(raw_object_size_avg) over () RAW_OBJECT_SIZE_AVG -- Unkompromiert ohne Index
        , mem_object_size_max MEM_OBJECT_SIZE, max(mem_object_size_max) over () MEM_OBJECT_SIZE_MAX, avg(mem_object_size_avg) over () MEM_OBJECT_SIZE_AVG -- grösse komp, auf der Platte
        , auxiliary_size_max AUXILIARY_SIZE, max(auxiliary_size_max) over () AUXILIARY_SIZE_MAX, avg(auxiliary_size_avg) over () AUXILIARY_SIZE_AVG       -- Index
        , statistics_size_max STATISTICS_SIZE, max(statistics_size_max) over () STATISTICS_SIZE_MAX, avg(statistics_size_avg) over () STATISTICS_SIZE_AVG -- Audit +
        , recommended_db_ram_size_max RECOMMENDED_DB_RAM_SIZE, max(recommended_db_ram_size_max) over () RECOMMENDED_DB_RAM_SIZE_MAX, avg(recommended_db_ram_size_avg) over () RECOMMENDED_DB_RAM_SIZE_AVG
        , raw_object_size_max/mem_object_size_max COMPRESSION_FACTOR, max(raw_object_size_max/mem_object_size_max) over () COMPRESSION_FACTOR_MAX, avg(raw_object_size_avg/mem_object_size_max) over () COMPRESSION_FACTOR_AVG
        from exa_db_size_daily 
        cross join param
        where interval_start>sysdate-param.statistic_days
        order by interval_start desc
        limit 1)
, monitor as (
        -- persistent_db_ram and temp_db_ram are in MiB!
        select interval_start, avg(cpu_avg) over () CPU_AVG, avg(cpu_max) over () CPU_MAX
        , temp_db_ram_max TEMP_DB_RAM, max(temp_db_ram_max) over () TEMP_DB_RAM_MAX, avg(temp_db_ram_avg) over () TEMP_DB_RAM_AVG
        , persistent_db_ram_max DB_RAM, max(persistent_db_ram_max) over () DB_RAM_MAX, avg(persistent_db_ram_avg) over () DB_RAM_AVG
        -- db_ram_size: nur max + avg 99 Tage aus EXA_SYSTEM_EVENTS
        from exa_monitor_daily 
        cross join param
        where interval_start>sysdate-param.statistic_days
        order by interval_start desc
        limit 1)
, events as (
        select avg(db_ram_size) DB_RAM_SIZE_AVG, max(db_ram_size) DB_RAM_SIZE_MAX 
        from exa_system_events
        cross join param
        where measure_time>sysdate-param.statistic_days
        union all
        select null DB_RAM_SIZE_AVG, db_ram_size DB_RAM_SIZE_MAX 
        from exa_system_events
        limit 1)        
, finale as (        
        select dbs.cluster_name, par.statistic_days, dbs.interval_start
        , dbs.RAW_OBJECT_SIZE, dbs.RAW_OBJECT_SIZE_MAX, dbs.RAW_OBJECT_SIZE_AVG
        , dbs.MEM_OBJECT_SIZE, dbs.MEM_OBJECT_SIZE_MAX, dbs.MEM_OBJECT_SIZE_AVG
        , dbs.AUXILIARY_SIZE, dbs.AUXILIARY_SIZE_MAX, dbs.AUXILIARY_SIZE_AVG
        , dbs.STATISTICS_SIZE, dbs.STATISTICS_SIZE_MAX, dbs.STATISTICS_SIZE_AVG
        , dbs.COMPRESSION_FACTOR, dbs.COMPRESSION_FACTOR_MAX, dbs.COMPRESSION_FACTOR_AVG
        , evt.DB_RAM_SIZE_MAX, evt.DB_RAM_SIZE_AVG, if evt.DB_RAM_SIZE_AVG is null then 'DB_RAM statistic is older than'||par.statistic_days||' days.' endif DB_RAM_SIZE_REMARK 
        , mon.TEMP_DB_RAM, mon.TEMP_DB_RAM_MAX, mon.TEMP_DB_RAM_AVG
        , dbs.RECOMMENDED_DB_RAM_SIZE, dbs.RECOMMENDED_DB_RAM_SIZE_MAX, dbs.RECOMMENDED_DB_RAM_SIZE_AVG
        , mon.CPU_AVG, mon.CPU_MAX
        from db_size dbs
        cross join monitor mon
        cross join events evt
        cross join param par)
select 'cluster_name' 'identifier', to_char(cluster_name) 'value' from finale
union all
select 'statistic_days', to_char(statistic_days) from finale
union all
select 'interval_start', to_char(interval_start) from finale
union all
select 'RAW_OBJECT_SIZE', to_char(RAW_OBJECT_SIZE) from finale
union all
select 'RAW_OBJECT_SIZE_MAX', to_char(RAW_OBJECT_SIZE_MAX) from finale
union all
select 'RAW_OBJECT_SIZE_AVG', to_char(RAW_OBJECT_SIZE_AVG) from finale
union all
select 'MEM_OBJECT_SIZE', to_char(MEM_OBJECT_SIZE) from finale
union all
select 'MEM_OBJECT_SIZE_MAX', to_char(MEM_OBJECT_SIZE_MAX) from finale
union all
select 'MEM_OBJECT_SIZE_AVG', to_char(MEM_OBJECT_SIZE_AVG) from finale
union all
select 'AUXILIARY_SIZE', to_char(AUXILIARY_SIZE) from finale
union all
select 'AUXILIARY_SIZE_MAX', to_char(AUXILIARY_SIZE_MAX) from finale
union all
select 'AUXILIARY_SIZE_AVG', to_char(AUXILIARY_SIZE_AVG) from finale
union all
select 'STATISTICS_SIZE', to_char(STATISTICS_SIZE) from finale
union all
select 'STATISTICS_SIZE_MAX', to_char(STATISTICS_SIZE_MAX) from finale
union all
select 'STATISTICS_SIZE_AVG', to_char(STATISTICS_SIZE_AVG) from finale
union all
select 'COMPRESSION_FACTOR', to_char(COMPRESSION_FACTOR) from finale
union all
select 'COMPRESSION_FACTOR_MAX', to_char(COMPRESSION_FACTOR_MAX) from finale
union all
select 'COMPRESSION_FACTOR_AVG', to_char(COMPRESSION_FACTOR_AVG) from finale
union all
select 'DB_RAM_SIZE_MAX', to_char(DB_RAM_SIZE_MAX) from finale
union all
select 'DB_RAM_SIZE_AVG', to_char(DB_RAM_SIZE_AVG) from finale
union all
select 'DB_RAM_SIZE_REMARK', to_char(DB_RAM_SIZE_REMARK) from finale
union all
select 'TEMP_DB_RAM', to_char(TEMP_DB_RAM) from finale
union all
select 'TEMP_DB_RAM_MAX', to_char(TEMP_DB_RAM_MAX) from finale
union all
select 'TEMP_DB_RAM_AVG', to_char(TEMP_DB_RAM_AVG) from finale
union all
select 'RECOMMENDED_DB_RAM_SIZE', to_char(RECOMMENDED_DB_RAM_SIZE) from finale
union all
select 'RECOMMENDED_DB_RAM_SIZE_MAX', to_char(RECOMMENDED_DB_RAM_SIZE_MAX) from finale
union all
select 'RECOMMENDED_DB_RAM_SIZE_AVG', to_char(RECOMMENDED_DB_RAM_SIZE_AVG) from finale
union all
select 'CPU_AVG', to_char(CPU_AVG) from finale
union all
select 'CPU_MAX', to_char(CPU_MAX) from finale
;
