#!/usr/bin/env python
#
#  call_log.py
#  MacDroidNotifier
#
#  Created by Rodrigo Damazio on 08/03/10.
#
#  Script which saves all receives notifications to comma-separated-values file
#  in /tmp/event_log.txt .
#

from os import getenv
import csv

notification = getenv('ANDROID_NOTIFICATION')
notificationParts = notification.split('/')

f = open('/tmp/event_log.txt', 'a')
csvWriter = csv.writer(f)
csvWriter.writerow(notificationParts)
f.close()
