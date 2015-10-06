Test Hcatalog
1) Create a test table : 
CREATE EXTERNAL TABLE users(name string , age int) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' LOCATION '/user/root/tests'

2) Test Hcatalog rest API
> curl http://cdh5pseudo:50111/templeton/v1/ddl/database/default/table/?user.name=root;echo 
