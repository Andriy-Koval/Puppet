#!/bin/bash

USERNAME='Admin'
PASSWORD='zabbix'
API_URL='https://zabbix.devops-world.ua/zabbix/api_jsonrpc.php'
ACTION_NAME=("Linux_Autoregistration" "Windows_Autoregistration" "MacOSX_Autoregistration" "FreeBSD_Autoregistration")
META_VALUE=("Linux" "Windows" "MacOS" "FreeBSD")
TEMPLATE_ID=("10001" "10081" "10079" "10075")

authenticate() {
 curl -k -X POST -H 'Content-Type: application/json-rpc' -d '{
     "jsonrpc":"2.0",
     "method":"user.login",
     "params":{
         "user": "'$USERNAME'",
         "password": "'$PASSWORD'"},
         "id":1,
         "auth":null}' $API_URL | cut -c28-59
}

TOKENS=$(authenticate)

autoregistry() {
 curl -k -X POST -H 'Content-Type: application/json-rpc' -d '{
    "jsonrpc": "2.0",
    "method": "action.create",
    "params": {
        "name": "'${ACTION_NAME[$1]}'",
        "eventsource": 2,
        "status": 0,
        "esc_period": 120,
        "def_shortdata": "Auto registration: {HOST.HOST}",
        "def_longdata": "Host name: {HOST.HOST}\r\nHost IP: {HOST.IP}\r\nAgent port: {HOST.PORT}",
        "filter": {
            "evaltype": 0, 
            "conditions": [
                {
                    "conditiontype": 24,
                    "operator": 2,
                    "value": "'${META_VALUE[$2]}'"
                }
            ]
        },
        "operations": [
            {
                "operationtype": 2
            },
            {
                "operationtype": 6,
                "optemplate": [
                       {
                         "templateid": "'${TEMPLATE_ID[$3]}'"
                       }
               ]
            }
        ]    
    },
    "auth": "'$TOKENS'",
    "id": 1
}' $API_URL
}


iterate () {
  total=${#ACTION_NAME[*]}
  for (( i=0; i<=$(( $total -1 )); i++ ))
     do
       autoregistry i
     done
}

iterate 

exit_code=$?

if [ $exit_code -ne 0 ]
   then
     	echo -e "Error in autoregistry creation\n"
        exit
   else
     	echo -e "\nCreation of autoregistry completed successfully\n"
        exit
fi
