from timeit import default_timer as timer

import pymysql
import sys
import json
import datetime
import os

REGION = 'us-east-1'

user_name = os.environ['user_name']
password = os.environ['password']
db_name = os.environ['db_name']
connect_timeout = int(os.environ['connect_timeout'])

def main(event, context):
    start = timer()
    run_sql(event)
    durationInSeconds = timer() - start

    response_body = {'durationInMillis': str(durationInSeconds * 1000)}
    return {
        'statusCode': 200,
        'headers': {'Content-Type': 'application/json'},
        'body': str(response_body)
    }


def run_sql(event):
    try:
        request_body = json.loads(event['body'])
        server = request_body['server_ip']
        query = request_body['query']

        conn = pymysql.connect(server, user=user_name, passwd=password, db=db_name, connect_timeout=connect_timeout)

        queries = query.split(';')
        for q in queries:
            print q
            result = []
            with conn.cursor() as cur:
                cur.execute(q)
                for row in cur:
                    result.append(list(row))
                print 'Data from RDS...'
                print result
        conn.close()
    except Exception, e:
        print e
        raise
