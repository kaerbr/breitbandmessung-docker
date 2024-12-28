#!/bin/bash

while true
do
    # wait 15 seconds, then check again
    sleep 15

    # get value of clipboard from novnc
    clipboard="$(DISPLAY=:0 xclip -o)"

    # check if /RUN File exists, or if clipboard is set to 'RUN'
    if [ "$clipboard" == "RUN" ] || [ -f "/RUN" ]
    then
        echo "Run set!"

        # Get the current hour and minute in 24-hour format (e.g., 14:30)
        current_time=$(date +"%H:%M:%S")
        echo "Current time is $current_time"
        
        # Save the hour and minute
        current_hour=$(date +"%H")
        current_minute=$(date +"%M")
        current_hour=${current_hour#0}
        current_minute=${current_minute#0}

        # Convert the start and end times to minutes for easier comparison
        # 13:00 in minutes
        start_time_minutes=$(( ${START_HOUR} * 60 + ${START_MINUTE} ))
        # 22:30 in minutes
        end_time_minutes=$(( ${END_HOUR} * 60 + ${END_MINUTE} ))


        # Convert the current time to minutes for comparison
        let "current_time_minutes=$current_hour * 60 + $current_minute"

        
        # Check if the current time is within the specified range
        # --> only start speedtesting during daytime, as this is the most relevant metric
        if (( current_time_minutes >= start_time_minutes && current_time_minutes <= end_time_minutes ))
        then
            echo "The current time is between $(printf "%02d" $START_HOUR):$(printf "%02d" $START_MINUTE) and $(printf "%02d" $END_HOUR):$(printf "%02d" $END_MINUTE)."
            echo "Trying to start speedtest..."
            
            # messung durchfuehren
            DISPLAY=:0 xdotool mousemove 531 510
            DISPLAY=:0 xdotool click 1

            # haeckchen
            DISPLAY=:0 xdotool mousemove 694 405
            DISPLAY=:0 xdotool click 1
            DISPLAY=:0 xdotool mousemove 694 479
            DISPLAY=:0 xdotool click 1
            DISPLAY=:0 xdotool mousemove 694 551
            DISPLAY=:0 xdotool click 1

            DISPLAY=:0 xdotool mousemove 1169 405
            DISPLAY=:0 xdotool click 1
            DISPLAY=:0 xdotool mousemove 1169 479
            DISPLAY=:0 xdotool click 1
            DISPLAY=:0 xdotool mousemove 1169 551
            DISPLAY=:0 xdotool click 1

            # messung starten
            DISPLAY=:0 xdotool mousemove 1091 668
            DISPLAY=:0 xdotool click 1

            # wait 6 minutes
            sleep 360
            echo "waiting 6 minutes..."
        
        else
            echo "NOT STARTING. The current time is outside the specified range of $(printf "%02d" $START_HOUR):$(printf "%02d" $START_MINUTE) and $(printf "%02d" $END_HOUR):$(printf "%02d" $END_MINUTE)."
        fi

    else
        echo "RUN not set in clipboard or file /RUN not available. (value in clipboard is \"$clipboard\")"
        printf "sleeping 15 seconds.\n\n"
    fi

done
