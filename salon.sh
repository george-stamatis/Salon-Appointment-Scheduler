#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -t -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]] 
  then 
    echo -e "\n$1"
  fi
  echo "Welcome to My Salon, how can I help you?"
  SERVICES=$($PSQL "SELECT service_id, name FROM services")
  echo "$SERVICES" | sed 's/|//g' | while read SERVICE_ID NAME; do
    echo "$SERVICE_ID) $NAME"
  done
  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in 
    1) SCHEDULE_MENU ;;
    2) SCHEDULE_MENU ;;
    3) SCHEDULE_MENU ;;
    4) SCHEDULE_MENU ;;
    5) SCHEDULE_MENU ;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac
}

SCHEDULE_MENU() {
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]] 
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME     
    $($PSQL "INSERT INTO customers(phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME"
  read SERVICE_TIME
  $($PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES ('$SERVICE_TIME', $CUSTOMER_ID, $SERVICE_ID_SELECTED)")
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU