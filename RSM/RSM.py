"""@package RSM.py
This module is the python script pulling data from the DHT and sending to SQL server.

usage: RSM.py <device_name> <SQL_ip_address>

where device name is the string identifier for this RSM (defaults to mac ID if not provided)
where SQL_ip_address is the IP of a SQL server to receive the atmospheric data (defaults to localhost if not provided)
 
Module Dependencies:
MySQLdb
Adafruit_DHT
numpy

Hardcoded for the DHT11 input on pin GPIO4
"""


#!/usr/bin/python
import sys
import MySQLdb
import uuid
import Adafruit_DHT # https://github.com/adafruit/Adafruit_Python_DHT.git
from datetime import datetime, timedelta
from time import sleep
from numpy import mean

# HANDLE COMMAND LINE ARGS (IF ANY) 
# usage: 1st command line argument is the hostname, defaults to MACID
#        2nd command line argument is the target SQL server, defaults to localhost if none present

## @var _sens_name
#  This is the hostname of the sensor module, stored in the SQL database with each environmental data point
if len(sys.argv) > 1:
  sens_name = sys.argv[1]
else:
  sens_name = uuid.getnode()

## @var _conn_IP
#   This is the IP address of the SQL database

if len(sys.argv) > 2:
  conn_IP = sys.argv[2]
else:
  conn_IP = "127.0.0.1"


# BEGIN CONFIG

print 'Creating connection to SQL database on ', conn_IP, ' as device name ', sens_name, '\n'

SENSOR_NUMBER = "sens_name" # Name of the rasperry pi in question
record_frequency = timedelta(0,30,0) # 30 seconds
# db = MySQLdb.connect("192.168.43.126", "monitor", "monitor", "DRESS_ATMOSPHERIC")
# db = MySQLdb.connect("10.182.128.3", "monitor", "monitor", "DRESS_ATMOSPHERIC")

## @var _db
# this is the connection to the SQL database
db = MySQLdb.connect(conn_IP, "monitor", "monitor", "DRESS_ATMOSPHERIC")

print'Successfully connected to SQL server'

# END CONFIG

dbCursor = db.cursor()

next_record = datetime.now() + record_frequency
temperature_series = []
humidity_series = []

while True:
  humidity, temperature = Adafruit_DHT.read_retry(Adafruit_DHT.DHT11, 4)
  if (humidity is None or temperature is None):
    continue # sometimes the DHT11 will fail to read. Just skip that attempt.
  humidity_series.append(humidity)
  temperature_series.append(temperature)

  if (datetime.now() < next_record):
    continue # don't save to DB unless we have enough samples of data to average

  try:
    record_temperature = mean(temperature_series)
    record_humidity = mean(humidity_series)
    sql = "INSERT INTO DHT11 (datetime, sensor_number, temperature, humidity) VALUES(NOW(), %s, %s, %s)"
    val = (SENSOR_NUMBER, record_temperature, record_humidity)
    dbCursor.execute(sql, val)
    db.commit()

    # Only clear series and wait a minute if the database call succeeded.
    next_record += record_frequency
    del temperature_series[:]
    del humidity_series[:]
    print '{0},{1:0.0f},{2:0.0f}'.format(datetime.now(), record_temperature, record_humidity)
  except:
    try:
      db.rollback()
    except:
      db = MySQLdb.connect(conn_IP, "monitor", "monitor", "DRESS_ATMOSPHERIC")
      dbCursor = db.cursor()
