#!/bin/sh
### BEGIN INIT INFO
# Provides:          __service__
# Required-Start:    $network $local_fs $syslog
# Required-Stop:     $network $local_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start __service__ at boot time
# Description:       Start __service__.
### END INIT INFO


. /lib/lsb/init-functions

case "$1" in
start)
  log_daemon_msg "Starting __service__." "__service__"
  /usr/bin/sudo -u root -H __root__/__service__/__service__.py __args__
;;
stop)
  log_daemon_msg "Shutting down __service__" "__service__" 
  
  if [ -e /var/run/__service__.pid ];
  	then PID_FILE=/var/run/__service__.pid
  else
  	PID_FILE=`ls /var/run/__service__/*pid 2>/dev/null`
  fi
  
  if [ -z "$PID_FILE" ];
  	then log_end_msg 1
  	exit 1
  fi
  
  start-stop-daemon --stop --quiet --oknodo --pidfile $PID_FILE
  log_end_msg $?

  if [ -e $PID_FILE ]; then
	rm -f $PID_FILE
  fi

;;
*)
  echo "Usage: $0 {start|stop}"
  exit 1
esac

exit 0
