#!/bin/bash
set -e

USER_PATH=/home/${whoami}
DATE=$(date '+%d-%m-%Y')

# Configure these to your paths
MAIN_FOLDER=$USER_PATH/projects/trapezium
TSHOCK_PATH=$MAIN_FOLDER/TShock
TSHOCK_DATA_PATH=$TSHOCK_PATH/tshock
BACKUP_PATH=$MAIN_FOLDER/backups
WORLD_PATH=$MAIN_FOLDER/worlds
STARTUP_SCRIPT=start.sh
WORLD_FILE=Trapezium_v1.wld

# Create folder for the files that are being backed up
function createBackupFolder {
    # Create directory of current date in DD-MM-YYYY format
    (cd $TSHOCK_BACKUP_PATH && mkdir $DATE)
}

# Backup the config and the database
function backupData {
    # Copy files from /TShock/tshock to /backups/DD-MM-YYYY (-r because directory)
    cp -r $TSHOCK_DATA_PATH/* $TSHOCK_BACKUP_PATH/$DATE/
}

# Backup world file
function backupWorld {
    # Copy world file from /worlds/WORLDFILE.wld to /backups/DD-MM-YYYY
    cp $WORLD_PATH/$WORLD_FILE $TSHOCK_BACKUP_PATH/$DATE/
}

# Backup world, database and config
function backup {
    createBackupFolder
    backupData
    backupWorld
    cd $BACKUP_PATH/$DATE/
    # Git commands to upload every file, commit, and push
    git add ./
    git commit -m "[Auto] $DATE"
    git push
}

function run {
    # End the tmux session
    tmux send -t tshock exit ENTER
    # Backup and upload files
    backup
    # Start new detached tmux session with name "tshock"
    tmux new -d -s tshock
    # Start server on session
    tmux send -t tshock (cd $TSHOCK_PATH && mono TerrariaServer.exe -world $WORLD_PATH/$WORLD_FILE) ENTER
}
