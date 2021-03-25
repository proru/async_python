#!/usr/bin/env python
import pika

connection = pika.BlockingConnection(pika.ConnectionParameters(host='127.0.0.1', port=9010))
channel = connection.channel()
channel.queue_declare(queue='hello')
channel.basic_publish(exchange='',
                      routing_key='hello',
                      body=b'Hello World!')
print(" [x] Sent 'Hello World!'")
connection.close()

