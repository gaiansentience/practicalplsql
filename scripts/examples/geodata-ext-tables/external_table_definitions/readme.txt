--Local External Tables: All datafiles should be located in an accessible directory named GEODATA_DIR granted to user
--  for details see directory.create.sql

--OCI External Tables:  All datafiles should be located in object storage with correct access grants to OCI$RESOURCE_PRINCIPAL
--  for details see oci.create_resource_principal.sql
--  user should have grant on resource principal credential and execute rights on dbms_cloud

--See datafile headers for information about file sources, opensource attribution and field definitions

--Local External Tables Tested On Following Versions/Platforms
--    XE 21c Windows Local Install
--    EE 19c Linux VirtualBox DeveloperDays Appliance  (todo)
--    Free 23ai Linux VirtualBox Appliance

--Cloud External Tables Tested on Following OCI Versions
--    21c Autonomous Database AlwaysFree (todo)
--    23ai Autonomous Database AlwaysFree
