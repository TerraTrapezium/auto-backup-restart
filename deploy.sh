#!/bin/bash
set -e

DEPLOY_PATH=/usr/local/bin

function addCronjob {
    # Declare local variable for cleaner code
    crontask=$DEPLOY_PATH/abr-run.sh
    # If crontask doesn't already exist, add it (recurs at 12pm, every day)
    sudo grep "$crontask" /etc/crontab || echo "00 12 * * 1-7 $USER $crontask" | sudo tee -a /etc/crontab > /dev/null
}


function deploy {
    # Remove current installation first.
    if ls $DEPLOY_PATH/abr-run.sh 1> /dev/null 2>&1; then
        sudo rm $DEPLOY_PATH/abr-run.sh
    fi

    # Copy abr-run.sh to /usr/local/bin
    sudo cp abr-run.sh $DEPLOY_PATH/
}

echo "Deploying Auto Backup Restart"
deploy
echo "Adding cronjob"
addCronjob
echo "All done!"
