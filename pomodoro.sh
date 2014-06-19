#!/usr/bin/env bash

###################
# Morgan Reece (Phillips)
# mrrrgn.com
# wiki.mrrrgn.com
#
# This script will notify the user when to work and when to rest
# in intervals as specified in http://en.wikipedia.org/wiki/Pomodoro_Technique
# notifications are sent out via terminal-notifier http://rubygems.org/gems/terminal-notifier
# on OS X or the pynotify library on Linux.  The script will also blacklist any domains listed
# in a file named .pomodoro.urls.blacklist stored in the users home directory.
####################

SUDO_USER=${SUDO_USER}; # So we can run commands as non-root

### INVERVAL CONSTANTS ###

WORK_INTERVAL_SEC=1500; # 25 minutes of work
WORK_MSG="begin-working....";

REST_INTERVAL_SEC=300; # 5 minutes of rest
REST_MSG="take-a-rest....";

SET_SIZE=4; # Take a long rest after this many iterations
SET_INTERVAL_SEC=1200; # 15 minute post-set rest
SET_MSG="set-has-ended....";

### Set up OS Specific commands and variables ###

if [ `uname` = "Darwin" ]; then
    ### OS X ###

    # Make sure terminal-notifier is installed
    if ! which terminal-notifier
        then gem install terminal-notifier;
    fi

    CMD="terminal-notifier -title -sound default -message";
    
    # Because we can't count on ~
    USER_HOME="/Users/$SUDO_USER/";
    CMD_AS_USER="sudo -u $SUDO_USER"; # We need this for notifications to work
else
    ### Debian/Linux ###
    USER_HOME="/home/$SUDO_USER/";
    CMD_AS_USER="";
     
    # Because Linux can run headless, a more complex
    # notification command is needed, that takes args,
    # so a function holds all of the logic.
    function linux_notify() {
        # A text only notification
        echo $1 | wall;
    }
    CMD="linux_notify";
    if echo $DISPLAY 1>/dev/null; then
        if python -m notify2 2>/dev/null; then 
            echo "Graphical notifications not yet supported....";
        fi
    fi
fi


### FILE LOCATIONS ###

BACKUPHOSTSFILE=.pomodoro.etc.hosts.bak; # store the unhampered hosts file here
BLACKLIST=.pomodoro.urls.blacklist; # urls to blacklist during work
PIDFILE=.pomodoro.pid;

### OS agnostic commands ###
CMD_WORK_START="$CMD_AS_USER $CMD '$WORK_MSG'";
CMD_REST_START="$CMD_AS_USER $CMD '$REST_MSG'";
CMD_SET_END="$CMD_AS_USER $CMD '$SET_MSG'";

### FUNCTIONS ###

function root_check {
    if [ "$(id -u)" != "0" ]; then
        echo "This script must be run as root" 1>&2;
        exit 1;
    fi
}

function blacklist_hosts_file {
    if test -f "$USER_HOME$BLACKLIST"; then
        cp /etc/hosts "$USER_HOME$BACKUPHOSTSFILE";
        # A simple checksum for our backup
        if [ $(wc -l < /etc/hosts) = $(wc -l < "$USER_HOME$BACKUPHOSTSFILE") ]; then
            # Append our blacklist values
            cat "$USER_HOME$BLACKLIST" | awk '{print "127.0.0.1 "$1}' >> /etc/hosts;
        fi
    fi
}

function unblacklist_hosts_file {
    if test -f "$USER_HOME$BACKUPHOSTSFILE"; then
        # Overwrite the current hosts file with our backup
        cp "$USER_HOME$BACKUPHOSTSFILE" /etc/hosts;
        # rm the old backup file after a checksum
        if [ $(wc -l < /etc/hosts) = $(wc -l < "$USER_HOME$BACKUPHOSTSFILE") ]; then
            rm "$USER_HOME$BACKUPHOSTSFILE";
        fi
    fi
}

### Only attempt to run if we're root ###
root_check;

### Start Working! ###
if [ x"$1" = xstart ]; then
    if test -f "$USER_HOME$PIDFILE"; then exit; fi
    echo $$ > "$USER_HOME$PIDFILE"
    while true; do
        for i in $(seq 1 $SET_SIZE); do
            # Work starts
            blacklist_hosts_file;
            $CMD_WORK_START;
            $CMD_AS_USER sleep $WORK_INTERVAL_SEC;
            # Rest starts
            unblacklist_hosts_file;
            $CMD_REST_START;
            $CMD_AS_USER sleep $REST_INTERVAL_SEC;
        done
        # Set interval ends here
        $CMD_SET_END;
        $CMD_AS_USER sleep $SET_INTERVAL_SEC;
    done
elif [ x"$1" = xstop ]; then
    # Cleanup hosts file and die.
    unblacklist_hosts_file;
    PID=$(cat $USER_HOME$PIDFILE);
    rm -f $USER_HOME$PIDFILE
    kill -9 $PID;
fi
