import oracledb
import time

user = "devgym"
password = "oracle"
dsn = "192.168.56.122/freepdb1"
try:
     connection = oracledb.connect(user=user, password=password, dsn=dsn)
     print("Connection established successfully.")
     
     cursor = connection.cursor()
     start_time = time.perf_counter()
     n = 10000
     rc = cursor.callfunc("data_api.fget_ref_cursor", oracledb.CURSOR, [n])
     rows = rc.fetchall()
     rc.close()
     end_time = time.perf_counter()
     elapsed_time = end_time - start_time
     print(f"Time taken to fetch REF CURSOR data: {elapsed_time:.6f} seconds")
     print("Number of rows:", len(rows))
     #for row in rows:
     #    print(row)
     start_time = time.perf_counter()
     json_data = cursor.callfunc("data_api.fget_json", oracledb.DB_TYPE_CLOB, [n])
     content = json_data.read()
     end_time = time.perf_counter()
     elapsed_time = end_time - start_time
     print(f"Time taken to fetch JSON data: {elapsed_time:.6f} seconds")
     print("Length of JSON data:", len(content))
     #print(content)
     cursor.close()
     
except oracledb.DatabaseError as e:
     print(f"Error connecting to the database: {e}")

finally:
     if 'connection' in locals() and connection:
         connection.close()
         print("Connection closed.")    

