#!/usr/bin/python
import sys
from datetime import datetime, timedelta
from numpy import mean
import Adafruit_DHT # https://github.com/adafruit/Adafruit_Python_DHT.git

next = datetime.now() + timedelta(seconds = 10)
temp = []
humi = []

print 'DateTime,Temperature (F),Humidity (%)'

while True:
  humidity, temperature = Adafruit_DHT.read_retry(11, 4)
  temp.append(9.0/5.0 * temperature + 32)
  humi.append(humidity)

  now = datetime.now()

  if now > next:
    next = now + timedelta(seconds = 10)
    print '{0},{1:0.1f},{2:0.1f}'.format(now, mean(temp), mean(humi))
    del temp[:]
    temp = []
    del humi[:]
    humi = []
