-- CREATE SCHEMA SCHEMA_FOR_VS_SCRIPT;

--/
CREATE OR REPLACE JAVA ADAPTER SCRIPT SCHEMA_FOR_VS_SCRIPT.ADAPTER_SCRIPT_MYSQL AS
    %scriptclass com.exasol.adapter.RequestDispatcher;
    %jar /buckets/bucketfs1/jars/virtual-schema-dist-9.0.1-mysql-2.0.0.jar;
    %jar /buckets/bucketfs1/jars/mysql-connector-java-8.0.25.jar;
/
CREATE OR REPLACE CONNECTION MYSQL_JDBC_CONNECTION
TO 'jdbc:mysql://192.168.56.107:3306/'
USER 'mysqluser'
IDENTIFIED BY 'test';

CREATE VIRTUAL SCHEMA mysql_db
    USING SCHEMA_FOR_VS_SCRIPT.ADAPTER_SCRIPT_MYSQL
    WITH
    CONNECTION_NAME = 'MYSQL_JDBC_CONNECTION'
    CATALOG_NAME = 'mysql';
    
select * from mysql_db."help_topic"
limit 10
;

select * from mysql_db