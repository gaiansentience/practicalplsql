import oracledb
import time
import os
import json
def connect_db():
     try:
          script_dir = os.path.dirname(os.path.abspath(__file__))
          config_path = os.path.join(script_dir, "db_config.json")          
          with open(config_path, "r", encoding="utf-8") as cf:
               dbCfg = json.load(cf)
 
          connection = oracledb.connect(user=dbCfg["user"], password=dbCfg["pwd"], dsn=dbCfg["dsn"])
          print("Connection established successfully.")
          return connection
     except oracledb.DatabaseError as e:
          print(f"Database connection error: {e}")
          return None

try:
     with connect_db() as connection:
          with connection.cursor() as cursor:
               start_time = time.perf_counter()
               # instead of cursor.var(oracledb.CURSOR) just create a new cursor to hold the REF CURSOR
               rc = connection.cursor()
               n = 10000
               cursor.callproc("data_api.get_ref_cursor", [n, rc])
               #calling function uses oracldb.CURSOR to define the return type
               #rc = cursor.callfunc("data_api.fget_ref_cursor", oracledb.CURSOR, [n])
               rows = rc.fetchall()
               rc.close()
               end_time = time.perf_counter()
               elapsed_time = end_time - start_time
               print(f"Time taken to fetch REF CURSOR data: {elapsed_time:.6f} seconds")
               print("Number of rows:", len(rows))
               #for row in rows:
               #    print(row)
except oracledb.DatabaseError as e:
     print(f"Error connecting to the database: {e}")

try:
     with connect_db() as connection:
          with connection.cursor() as cursor:

               start_time = time.perf_counter()
               json_data = cursor.var(oracledb.DB_TYPE_CLOB)
               cursor.callproc("data_api.get_json", [n, json_data])
               content = json_data.getvalue().read()
               #content = json_data.read()
               end_time = time.perf_counter()
               elapsed_time = end_time - start_time
               print(f"Time taken to fetch JSON data: {elapsed_time:.6f} seconds")
               print("Length of JSON data:", len(content))  
               #print(content)
   
except oracledb.DatabaseError as e:
     print(f"Error connecting to the database: {e}")

