#!/bin/sh

if [ -z "$HUB_HOST" ]
then
      echo "\$HUB_HOST is empty"
      echo "Run automated API tests..."
      mvn test -Dcucumber.filter.tags=$TYPE
      exit 0
else
      echo "\$HUB_HOST is NOT empty - $HUB_HOST"
fi

echo "Browser - $BROWSER"

echo "Validate $HUB_HOST status.."

STATUS=false

echo "Loop until the hub status is true.."
while [ $STATUS != true ]
do
 sleep 1
 STATUS=$(curl -s http://selenium-hub:4444/wd/hub/status | jq -r .value.ready)
 echo "Status of Selenium Hub is - $STATUS"
done

# Run tests
mvn test -Dcucumber.filter.tags=$TYPE -DHUB_HOST=$HUB_HOST -DBROWSER=$BROWSER
