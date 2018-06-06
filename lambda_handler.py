import sys
import logging
import rds_config
import pymysql
import json
#rds settings
rds_host  = "sampledb0-migrated-cluster.cluster-cffm6hzathlb.us-east-1.rds.amazonaws.com"
#rds_host  = "sampledb0-migrated-cluster.cluster-ro-cffm6hzathlb.us-east-1.rds.amazonaws.com"
name = rds_config.db_username
password = rds_config.db_password
db_name = rds_config.db_name

logger = logging.getLogger()
logger.setLevel(logging.INFO)

logger.info("Trying to connect to MySQL")
conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=10)
logger.info("SUCCESS: Connection to mysql instance succeeded")

def handler(event, context):
    """
    This function fetches content from mysql AURORA instance
    """   
    #parsed_json = json.loads(event['body'])
    test = event['test_action']
    query = event['query']
    response = ""
    logger.info("body: {} {}".format(test,query));
    
    if (test == 'create'):
        response = execute_create(conn, query)
    elif (test == 'row_count'):
        response = get_row_count(conn, query)
    elif (test == 'inner_join'):
        response = execute_inner_join(conn, query)
    elif (test == 'update'):
        response = execute_update(conn, query)
    elif (test == 'delete'):
        response = execute_delete(conn, query)
        
    #conn.close()
    
    out = {}
    out['statusCode'] = 200
    out['headers'] = {'Content-Type': 'application/json'}
    out['body'] = response
    
    return out

def execute_create(conn, query):
    response = 'Failed to create user'
    logger.info(query)
    
    with conn.cursor() as cur:
        result = cur.execute(query)
        conn.commit()
        response = "Created "+str(result)+" entries into the database"
    
    return response
    
def get_row_count(conn, query):
    response = ""
    logger.info(query)
    
    with conn.cursor() as cur:
        result = cur.execute(query)
        for row in cur:
            #logger.info(row)
            response = response + str(row)
            
    return response
    
def execute_inner_join(conn, query):
    #response = "Read operation failed"
    response = ""
    count = 0
    logger.info(query)
    
    with conn.cursor() as cur:
        cur.execute(query)
        for row in cur:
            count += 1
            #response = response + str(row)
        response = "Read "+str(count)+" records using inner join succeeded"
            
    return response

def execute_update(conn,query):
    response = 'Update Failed'
    logger.info(query)
    
    with conn.cursor() as cur:
        result = cur.execute(query)
        conn.commit()
        response = 'Updated '+str(result)+' records'
    
    return response
    
def execute_delete(conn, query):
    response = 'Failed to delete user'
    logger.info(query)
    
    with conn.cursor() as cur:
        result = cur.execute(query)
        conn.commit()
        response = 'Deleted '+str(result)+' records'
    
    return response