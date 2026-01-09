
#!/bin/bash

set -e

# Colors
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="$HOME/shell-roboshop-logs"
SCRIPT_NAME=$(basename "$0" .sh)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

mkdir -p "$LOGS_FOLDER"
echo "Script started at $(date)" | tee -a "$LOG_FILE"

# Validation function
VALIDATE() {
  if [ "$1" -ne 0 ]; then
    echo -e "$2 ... $R FAILURE $N" | tee -a "$LOG_FILE"
    exit 1
  else
    echo -e "$2 ... $G SUCCESS $N" | tee -a "$LOG_FILE"
  fi
}

echo "Checking Homebrew..." | tee -a "$LOG_FILE"
command -v brew &>/dev/null
VALIDATE $? "Homebrew Installed"

echo "Checking NodeJS..." | tee -a "$LOG_FILE"
command -v node &>/dev/null || brew install node &>>"$LOG_FILE"
VALIDATE $? "NodeJS Installed"

APP_DIR="$HOME/roboshop/catalogue"
mkdir -p "$APP_DIR"

echo "Downloading Catalogue App" | tee -a "$LOG_FILE"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>"$LOG_FILE"
VALIDATE $? "Downloading Catalogue"

echo "Extracting Catalogue App" | tee -a "$LOG_FILE"
rm -rf "$APP_DIR"/*
unzip -o /tmp/catalogue.zip -d "$APP_DIR" &>>"$LOG_FILE"
VALIDATE $? "Extracting Catalogue"

cd "$APP_DIR"

echo "Installing NodeJS dependencies" | tee -a "$LOG_FILE"
npm install &>>"$LOG_FILE"
VALIDATE $? "Installing Dependencies"

echo -e "$G Catalogue App setup completed successfully on macOS $N"





