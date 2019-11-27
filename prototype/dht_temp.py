#!/usr/bin/python

import sys
import MySQLdb
import Adafruit_DHT # https://github.com/adafruit/Adafruit_Python_DHT.git
from datetime import datetime, timedelta
from time import sleep
from numpy import mean

######### BEGIN CONFIG #########

SENSOR_NUMBER = "212-3" # taken from the network port label on the wall
record_frequency = timedelta(0,30,0) # 30 seconds
db = MySQLdb.connect("10.254.254.101", "monitor", "monitor", "GRC_B50_ATMOSPHERIC")

########## END CONFIG ##########

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
      db = MySQLdb.connect("10.254.254.101", "monitor", "monitor", "GRC_B50_ATMOSPHERIC")
      dbCursor = db.cursor()
      
