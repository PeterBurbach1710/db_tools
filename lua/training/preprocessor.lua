create schema if not exists preprocessing;

--/
create or replace lua script preprocessing.mytransform() as
function transform_user(sqltext)
    return sqltext
end
output(transform_user([[USE_MY_SCHEMA]]))
/
execute script preprocessing.mytransform() with output;

--/
create or replace lua script preprocessing.mypreprocess() AS 
import('PREPROCESSING.MYTRANSFORM', 'MYTRANSFORM')
sqltext = sqlparsing.getsqltext()
sqltext = MYTRANSFORM.transform_use(sqltext)
sqlparsing.selsqltext(sqltext)
/

select * from exp_parameters;
alter session set sql_preprocessor_script = preprocessing.mypreprocess;

select 5;
flush statistics;
select * from exa_dba_audit_sql where session_id=current_session;

alter session set sql_preprocessor_script = '';