# Description
Lambda to execute mysql queries

# Sample Lambda test event
```
{
  "body": "{\"server_ip\":\"xxx.xxx.xxx.xxx\",\"query\":\"select * from xxx\"}"
}
```
# To run loop_script.sh
Modify curl command in the script to provide server ip, query
```
./loop_script.sh | tee <filename>
```
# To run parallel_script.sh
Modify curl command in the script to provide server ip, query
```
./paralle_script.sh <totalruns> <threads> | tee <filename>
```
