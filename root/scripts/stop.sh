#!/bin/bash
#script to start the server

PID=`ps -eaf | grep tomcat | grep -v grep | awk '{print $2}'`
if [ "" !=  "$PID" ]; then
  echo "killing $PID"
  kill -9 $PID
fi
