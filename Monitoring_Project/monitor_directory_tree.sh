

#!/bin/bash

# Assign the current user to a variable 

current_user=$(whoami)


# Define the file path for the file that contains the folder to monitor

file_with_path="path_to_file.txt"


# Check if the file exists

if [ -f "$file_with_path" ]
then
    # Read the folder to monitor from the file
    while IFS= read -r line
    do
        folder_to_monitor="$line"
    done < "$file_with_path"
else
    # If the file is not found, show an error message
    echo "File not found: $file_with_path, please note that all the program script files must be in the same directory to work properly!"
fi



# Define the log file path and name, using the current date

today=$(date +"%Y-%m-%d")

# Searching for this project directory 
main_folder_path=$(find /home -name Monitoring_Project)

log_file="$main_folder_path/monitor_log_$today"

#################### /crontab/ ####################

# Set up a cron job to send the log file as an email everyday at 23:59 PM

# Define the cron command - to change the time, (MINUTES HOURS * * * ...)

cron_command="59 23 * * * if [ -f $log_file ]; then mpack -s 'Monitor Log for $today' $log_file mrpentesterqwerty@gmail.com; else echo 'No changes were detected in the monitor log for $today.' | mailx -s 'No Changes for Today' mrpentesterqwerty@gmail.com; fi"

# Deletes the 1st line from the crontab 
crontab -l | sed '1d' | crontab -

# Check if the cron job already exists
if ! (crontab -l | grep -Fxq "$cron_command"); then

    # If the cron job does not exist, add it to the crontab
    (crontab -l ; echo "$cron_command") | crontab -
fi
#################### /end crontab/ ####################


# Define a trap for handling interrupt signals (when the user stops the program with "Ctrl + C")

trap "echo '     -->        Program Stopped       <--'; exit" INT


# Define functions for different events to log in the file

file_moved_from() {
    TIMESTAMP=`date`
    echo "[$TIMESTAMP] !!!  $folder_to_monitor $2 was MOVED OUT" >> $log_file
}

file_moved_to() {
    TIMESTAMP=`date`
    echo "[$TIMESTAMP] !!!  $2 was MOVED to $folder_to_monitor" >> $log_file
}

file_removed() {
    TIMESTAMP=`date`
    echo "[$TIMESTAMP] !!!  $folder_to_monitor $2 was REMOVED" >> $log_file
}

file_modified() {
    TIMESTAMP=`date`
    echo "[$TIMESTAMP] !!!  $folder_to_monitor $2 was MODIFIED" >> $log_file
}

file_created() {
    TIMESTAMP=`date`
    echo "[$TIMESTAMP] !!!  $folder_to_monitor $2 was CREATED" >> $log_file
}

file_accessed() {
    TIMESTAMP=`date`
    echo "[$TIMESTAMP]      $folder_to_monitor $2 was ACCESSED" >> $log_file
}

#The next portion of the code uses inotifywait to monitor changes made 
#to files in the directory specified in $folder_to_monitor. The -q 
#option means that the events will be reported quietly, without the 
#default output text. The -m option tells inotifywait to run continuously 
#until killed, while the -r option tells it to monitor subdirectories recursively.
#The -e option specifies which file events to watch for, in this case: modify, 
#delete, access, create, moved_from, and moved_to.

#When a file event is detected, inotifywait reports the directory, event type,
#and file name, which are captured by the read command and stored in the variables
#DIRECTORY, EVENT, and FILE, respectively. The reported event is then processed by 
#the case statement, which calls the corresponding function depending on the type of event.
#The functions log the event and its time to a file specified in the $log_file variable.


inotifywait -q -m -r -e modify,delete,access,create,moved_from,moved_to $folder_to_monitor | while read DIRECTORY EVENT FILE; do
    case $EVENT in
        MODIFY*)
            file_modified "$DIRECTORY" "$FILE"
            ;;
        CREATE*)
            file_created "$DIRECTORY" "$FILE"
            ;;
        DELETE*)
            file_removed "$DIRECTORY" "$FILE"
            ;;
        ACCESS*)
            file_accessed "$DIRECTORY" "$FILE"
            ;;
        MOVED_FROM*)
            file_moved_from "$DIRECTORY" "$FILE"
            ;;
        MOVED_TO*)
            file_moved_to "$DIRECTORY" "$FILE"
            ;;
    esac
done
