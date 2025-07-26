#!/bin/bash

# Check current time sync status
status=$(timedatectl show -p NTPSynchronized --value)

if [ "$status" != "yes" ]; then
    echo "Time synchronization is not active. Applying fix..."

    conf_file="/etc/systemd/timesyncd.conf"

    # Use sudo to ensure we have permission
    sudo sed -i -E \
        -e '/^#?NTP=/c\NTP=pool.ntp.org time.google.com' \
        "$conf_file"

    # Restart and enable the timesyncd service
    # sudo systemctl restart systemd-timesyncd.service
    sudo systemctl enable --now systemd-timesyncd.service

    echo "Time synchronization service has been updated and restarted."
else
    echo "Time synchronization is already active. No changes made."
fi

