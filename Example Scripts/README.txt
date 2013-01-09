==============================
About MacDroidNotifier scripts
==============================

I have provided two sample scripts in this package:

* say.sh will use Mac's text-to-speech to announce the event
  (you could just have Growl do that, but then we wouldn't have an example,
   would we?)
* event_log.py which will save every event to a command-separates-value
  file in /tmp/event_log.txt

As you can see, you can write your script in any language, such as shell
script, Python, Applescript, etc., or you can even have it launch a regular
Mac application.
To read the notification from your script, you want to read the environment
variable ANDROID_NOTIFICATION, which will have the following format:

DEVICE_ID/NOTIFICATION_ID/EVENT_TYPE/EVENT_CONTENTS

Where the fields are:

DEVICE_ID - string that uniquely identifies the device sending the event
NOTIFICATION_ID - a unique ID for the notification, used to eliminate
                  duplicate notifications
EVENT_TYPE - one of {RING,SMS,MMS,BATTERY}
EVENT_CONTENTS - any text that carries additional information to be
                 displayed with the notification, such as who's calling or
                 the contents of the received SMS
