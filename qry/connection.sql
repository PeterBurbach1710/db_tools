-- CREATE SCHEMA pb_playground;

CREATE OR REPLACE CONNECTION con_pb_sftpd TO 'test-VirtualBox' USER 'ftpuser' IDENTIFIED BY 'test';

CREATE OR REPLACE CONNECTION con_pb_mysql TO 'test-VirtualBox' USER 'mysqluser' IDENTIFIED BY 'test';

CREATE  virtual_schema 'pb_mysql'
USING   adapater.jdbc_adapter
WITH    catalog_name = ''
        connection_name = 'con_pb_mysql'