#!/bin/sh
################################################################
# Proofpoint TAP API (V 2.0)
# Crontab:
#   # PPT
#   */10 * * * * /opt/script/dl-tap-logs-v2.sh
# Changes:
################################################################
# Service Account Name
USERNAME=""
PASSWORD=""

# Alert to and from addresses are use to notify administrators when failures occur during log retrieval
#ALERTTOADDRESS="example@customer.com"
#ALERTFROMADDRESS="noreply@proofpoint.com"

# Determines which API method is used. Valid values are: "all", "issues",
# "messages/blocked", "messages/delivered", "clicks/permitted", and "clicks/blocked"
ACTION="all"

# Determines which format the log is downloaded in. Valid values are "CEF" and "syslog"
FORMAT="CEF"

# Used to specify which customer's data is retrieved. Usually only required if the CTS account is associated with more than one customer id. Otherwise, should be left blank.
NAME=""

# Determines where log file are downloaded. Defaults to the current directory.
#LOGDIR="/opt/arcsight/script/log/V2"
LOGDIR="/var/log/proofpoint"

# Used to store the previous runtime
LASTINTERVALFILE="$LOGDIR/lastinterval"

# Determines the amount of data retrieved the first time the script is run. Uses ISO8601 format - PT1H specifies the previous
# hour's worth of data, PT10M specifies the previous 10 minutes. No more than two hours can be specified.
FIRSTINTERVAL="PT10M"
LOGFILESUFFIX="urldefense.log"
ERRORFILESUFFIX="urldefense.error"
TMPFILESUFFIX="urldefense.tmp"

# Custom Item used to make changing the API URL easier
API_VERSION="https://tap-api-v2.proofpoint.com/v2/siem"
if [ -f $LASTINTERVALFILE ]; then
    INTERVAL=`date`
    INTERVAL_SECS=`date -d "$INTERVAL" +%s`
    INTERVAL_ISO=`date -d "$INTERVAL" +%Y-%m-%dT%H:%M:%S%z`
    LASTINTERVAL=`cat $LASTINTERVALFILE`
    LASTINTERVAL_SECS=`date -d "$LASTINTERVAL" +%s`
    LASTINTERVAL_ISO=`date -d "$LASTINTERVAL" +%Y-%m-%dT%H:%M:%S%z`
    DIFF=`expr $INTERVAL_SECS - $LASTINTERVAL_SECS`
    if [ $DIFF -le 300 ]; then
            echo "Last retrieval was $DIFF seconds ago. Minimum time is 300 seconds. Retrieval not performed."
            exit
    fi
    echo "Retrieving data from $LASTINTERVAL"
                if [ $NAME ]; then
                                STATUS=$(curl -X GET -w '%{http_code}' -o "$LOGDIR/$INTERVAL_SECS-$TMPFILESUFFIX" "$API_VERSION/$ACTION?format=$FORMAT&interval=$LASTINTERVAL_ISO/$INTERVAL_ISO&name=$NAME" --user "$USERNAME:$PASSWORD" -s)
                else
                                STATUS=$(curl -X GET -w '%{http_code}' -o "$LOGDIR/$INTERVAL_SECS-$TMPFILESUFFIX" "$API_VERSION/$ACTION?format=$FORMAT&interval=$LASTINTERVAL_ISO/$INTERVAL_ISO" --user "$USERNAME:$PASSWORD" -s)
                fi
else
    INTERVAL=`date`
    INTERVAL_SECS=`date -d "$INTERVAL" +%s`
    INTERVAL_ISO=`date -d "$INTERVAL" +%Y-%m-%dT%H:%M:%S%z`
    echo "Retrieving data from $FIRSTINTERVAL"
    if [ $NAME ]; then
                                STATUS=$(curl -X GET -w '%{http_code}' -o "$LOGDIR/$INTERVAL_SECS-$TMPFILESUFFIX" "$API_VERSION/$ACTION?format=$FORMAT&interval=$FIRSTINTERVAL/$INTERVAL_ISO&name=$NAME" --user "$USERNAME:$PASSWORD" -s)
                else
                                STATUS=$(curl -X GET -w '%{http_code}' -o "$LOGDIR/$INTERVAL_SECS-$TMPFILESUFFIX" "$API_VERSION/$ACTION?format=$FORMAT&interval=$FIRSTINTERVAL/$INTERVAL_ISO" --user "$USERNAME:$PASSWORD" -s)
                fi
fi
if [ $? -eq 0 ] && [ $STATUS = "200" ]; then
    echo $INTERVAL > $LASTINTERVALFILE
    mv "$LOGDIR/$INTERVAL_SECS-$TMPFILESUFFIX" "$LOGDIR/$INTERVAL_SECS-$LOGFILESUFFIX"
    echo "Retrieval successful. $LOGDIR/$INTERVAL_SECS-$LOGFILESUFFIX created."
    exit 0
fi
if [ $? -eq 0 ] && [ $STATUS = "204" ]; then
    echo $INTERVAL > $LASTINTERVALFILE
    echo "Retrieval successful. No new records found."
    exit 0
fi
mv "$LOGDIR/$INTERVAL_SECS-$TMPFILESUFFIX" "$LOGDIR/$INTERVAL_SECS-$ERRORFILESUFFIX"
(echo "Retrieving TAP SIEM logs failed with error code $STATUS. Error was: " && cat "$LOGDIR/$INTERVAL_SECS-$ERRORFILESUFFIX")
echo "Retrieval unsuccessful. Failed with error code $STATUS."
exit 1
