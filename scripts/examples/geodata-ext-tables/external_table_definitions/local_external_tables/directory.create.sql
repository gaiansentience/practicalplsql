--prompt use server file path visible to the database


--Login as SYS to create directory and grant to PRACTICALPLSQL

--Local windows installation of XE 21
--CREATE OR REPLACE DIRECTORY GEODATA_DIR AS 'C:\ExternalData\ora-db-directories\shared\geodata';


--Oracle 23ai VirtualBox Linux Appliance with external data path
--CREATE OR REPLACE DIRECTORY GEODATA_DIR AS '/home/oracle/ext-data/ora-db-directories/shared/geodata';

--grant directory access to user
GRANT READ ON DIRECTORY GEODATA_DIR TO PRACTICALPLSQL;
GRANT WRITE ON DIRECTORY GEODATA_DIR TO PRACTICALPLSQL;
