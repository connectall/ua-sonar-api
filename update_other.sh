#!/bin/bash

if [ $# != 3 ]
then
    echo "Usage: ./update_other.sh AppLinkName SonarProject IssueType"
else

. sonar_setup.sh $1 $2 $3 $4 $5 $6 $7

echo Log into Sonar
if [ ! -e ${APPLINK}_read_token.json ]
then
	touch ${APPLINK}_read_token.json
fi


colon=%%3a
minus=%%2b
dte=`date -r ${APPLINK}_read_token.json "+%Y-%m-%dT%H%${colon}%M%${colon}%S${CA_timezone}00"`
#dte="2017-09-23T23${colon}01${colon}56${CA_timezone}00"
echo Find all Sonar records modified since $dte    

curl -X POST $SonarUrl/api/authentication/login?login=admin&password=admin

echo Find all modified Sonar records in the $PROJECT project and send them to ConnectALL at ${ConnectAllUrl}/connectall/api/2/postRecord?apikey=$ConnectAllApiKey
echo

if [ -e data.json ]
then
rm data.json
fi

curl -o data.json "$SonarUrl/api/issues/search?additionalFields=_all&components=$PROJECT&types=$ISSUETYPE&updatedAfter=$dte"


touch ${APPLINK}_read_token.json
if [ -e data.json ]
then
	i=0  
	json=`java -cp /Users/doug/git/sonar/target/sonar-0.0.1.jar:bin/json-20090211.jar com/connectall/adapter/sonar/SonarToConnectAllJson $APPLINK $SONAR_ORIGIN $i <data.json`
	while [ $? -eq 0 ]
	do
		((i++))
		echo $i times through the loop
		echo $json
		echo "$json" | curl --header "Content-Type: application/json;charset=UTF-8" -X POST -T - ${ConnectAllUrl}/connectall/api/2/postRecord?apikey=$ConnectAllApiKey
		json=`java -cp /Users/doug/git/sonar/target/sonar-0.0.1.jar:bin/json-20090211.jar com/connectall/adapter/sonar/SonarToConnectAllJson $APPLINK $SONAR_ORIGIN $i <data.json`
	done
else
	echo No new data found
	echo ""
fi

echo Log out
curl -X POST -c sonar.cookies $SonarUrl/api/authentication/logout
fi
