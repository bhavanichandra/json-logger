#!/bin/bash

# This script requires the following 3 arguments in the following order:
# 1. Anypoint Platform username
# 2. Anypoint Platform password
# 3. Anypoint Platform orgId
# Command should be called as follows:
# ./deploy.sh myUser myPass some-org-id-value

if [ "$#" -ne 3 ]
then
  echo "[ERROR] Not all arguments are present."
  exit 1
fi
echo "Deploying JSON Logger to Exchange"
echo "> OrgId: $3"
echo "> User: $1"

# Replacing ORG_ID_TOKEN inside pom.xml with OrgId value provided from command line
echo "Replacing OrgId token..."
echo sed -i.bkp "s/ORG_ID_TOKEN/$3/g" json-logger/pom.xml
sed -i.bkp "s/ORG_ID_TOKEN/$3/g" json-logger/pom.xml

# Deploying to Exchange
echo "Deploying to Exchange..."
echo mvn -f json-logger/pom.xml --settings maven-settings/settings.xml -Dexchange.user=$1 -Dexchange.password=****** clean deploy
mvn -Dexchange.user=$1 -Dexchange.password=$2 -f json-logger/pom.xml --settings maven-settings/settings.xml clean deploy

if [ $? != 0 ]
then
  echo "[ERROR] Failed deploying to Exchange"
fi