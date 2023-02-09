#!/bin/bash

# This script is used to monitor a specified folder for file changes, deletions, creations, and access events


# First argument is the folder to monitor, passed in when the script is run

folder_to_monitor=$1

# Get the current user running the script

current_user=$(whoami)

# Function to show help text

function show_help {
  echo ""
  echo "  Proper syntax of usage (run this in your terminal):"
  echo ""
  echo "      ./maintrigger.sh /choose/path/to/directory/       insert the path for directory as argument"
  echo ""
  echo "      -h, --help      display the correct usage"
  echo ""
  echo "    =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-="
  echo ""
  echo "      !!!ALWAYS!!! change directory (cd path/to/Monitoring_Project) to run this program!"
  echo ""
  echo "      NOTE: Before running the main script, wich is './maintrigger.sh', please make sure you install the dependecy packages first: "
  echo ""
  echo ""
  echo '      - Run this command in your terminal: sudo apt-get install -y $(cat dependencies.txt)'
  echo ""
  echo "      - Or you can just do it manually:"
  echo "                  - sudo apt-get install -y xdotool"
  echo "                  - sudo apt-get install -y inotify-tools"
  echo "                  - sudo apt-get install ssmtp"
  echo "                  - sudo apt-get install mpack"
  echo ""
  echo "      - Configure SMTP:"
  echo "                  - sudo nano /etc/ssmtp/ssmtp.conf"
  echo "                  - Add add these lines:"
  echo "                            root=username@gmail.com"
  echo "                            mailhub=smtp.gmail.com:465"
  echo "                            rewriteDomain=gmail.com"
  echo "                            AuthUser=username"
  echo "                            AuthPass=password"
  echo "                            FromLineOverride=YES"
  echo "                            UseTLS=YES"
  echo ""
  echo "    =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-="
}

# Function to set up new startup application (was made for Linux Debian Parrot OS)

function setting_new_startup_app {

        # Press the super key to open the menu
      xdotool key super

      # Wait for the menu to appear
      sleep 1

      # Type "Startup Applications" to search for the app
      xdotool type "Startup Applications"

      # Press the enter key to open the app
      xdotool key KP_Enter

      # Wait for the app to open
      sleep 1

      xdotool key Tab
      xdotool key Tab

      #Use ENTER to press the "+ Add" button
      xdotool key Return

      xdotool type "Monitoring Bash Program"

      sleep 1

      xdotool key Tab
      
      # Searching for the "minitor_directory_tree.sh" file
      find_the_main_file=$(find /home -name monitor_directory_tree.sh)

      xdotool type "nohup bash $find_the_main_file & disown"

      sleep 1

      xdotool key Return

      xdotool key Alt+F4


}




# Check if the first argument is -h or --help, and show help text if it is

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  show_help
  exit 0

# Check if the first argument is a directory, if not, exit with error message
elif [ ! -d "$folder_to_monitor" ]; then
  echo " ' $folder_to_monitor ' is not a directory path or it doesn't exist :("
  echo ""
  echo "  Please, use this for help: ' ./maintrigger.sh --help '"
  exit 1  

# If all checks are passed, display messages to indicate the script is running 
else
    echo ""
    echo "  Folder was sucessefully found!"
    echo ""
    
  
fi

# Store the folder to monitor in a file

echo "$folder_to_monitor" > path_to_file.txt

read -p "   Do you want to add this program as your new Startup Application (5 sec. duration time)? [Y / N]" new_SU_confirmation

if [ "$new_SU_confirmation" == "y" ] || [ "$new_SU_confirmation" == "Y" ]; then

    # Running function to set up new startup application
    setting_new_startup_app
    echo "    =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-="
    echo ""
    echo "  DONE! Now every time the system is started, the directory you indicated will be monitored and also run hidden :D"
    echo ""
    echo "" 
    echo "  Program is now running, the folder is being monitored..."
    echo "" 
    # Start the second script to monitor the folder
    bash monitor_directory_tree.sh

    
    exit 0

elif [ "$new_SU_confirmation" == "n" ] || [ "$new_SU_confirmation" == "N" ]; then
    # Start the second script to monitor the folder
    echo "" 
    echo "  Program is now running, the folder is being monitored..."
    echo "" 
    bash monitor_directory_tree.sh
    
    exit 1
else
    echo "  Invalid character, program finished!"
    exit 1
fi
