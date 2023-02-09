Hello!

This program was made for a purpose to monitoring the directory chosen by a user, basically it outputs into monitor_log file if the folder was accessed, modified, deleted, added or moved.
Every day, at 23:59 PM it sends the email(smtp protocol) with the monitor_log file of the day. If the directory wasnt accessed, modified, etc it sends an email saying basically there was nothing going on ;)

Now, for this project to work, you must:

1. cd /path/to/project/directory            ---(ALWAYS fire the MAIN SCRIPT, "maintrigger.sh, from the project's directory)---

2. chmod +x maintrigger.sh                  ---(allow permission to execute)---

3. chmod +x minitor_directory_tree.sh       ---(allow permission to execute)---

4. Install the necessary dependencies for this program:

        - sudo apt-get install -y $(cat dependencies.txt)

        or manually:
                - sudo apt-get install -y xdotool"
                - sudo apt-get install -y inotify-tools"

5. Start the maintrigger.sh with this command:

        - ./maintrigger.sh /path/to/directory/to/be/monitored/

6. Run this for help:

        -h, --help                      ---(" ./maintrigger.sh -h ")---
