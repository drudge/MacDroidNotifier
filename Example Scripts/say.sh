#!/bin/sh

# say.sh
# MacDroidNotifier
#
# Created by Rodrigo Damazio on 08/03/10.
#
# Script which uses Mac's text-to-speech to say received notifications
# NOTE: Remember not to select "Mute audio" if you try this script, otherwise
#       you won't hear anything :)
#

# ANDROID_NOTIFICATION is in the format DEVICE_ID/NOTIFICATION_ID/EVENT_TYPE/EVENT_CONTENTS
NOTIFICATION_TYPE="`echo $ANDROID_NOTIFICATION | sed 's/.*\/.*\/\(.*\)\/.*/\1/'`"
NOTIFICATION_DATA="`echo $ANDROID_NOTIFICATION | sed 's/.*\///'`"

if [ $NOTIFICATION_TYPE == "RING" ]; then
  TEXT_TO_SAY="Call from"
elif [ $NOTIFICATION_TYPE == "SMS" ]; then
  TEXT_TO_SAY="SMS received:"
elif [ $NOTIFICATION_TYPE == "MMS" ]; then
  TEXT_TO_SAY="MMS received:"
elif [ $NOTIFICATION_TYPE == "BATTERY" ]; then
  TEXT_TO_SAY="Battery status:"
else
  say "Unknown notification received"
  exit
fi

TEXT_TO_SAY="$TEXT_TO_SAY $NOTIFICATION_DATA"
say $TEXT_TO_SAY
