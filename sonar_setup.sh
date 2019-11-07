# To generate the sonar data:
# mvn sonar:sonar   -Dsonar.projectKey=SonarAdapter   -Dsonar.host.url=http://192.168.90.232:9000   -Dsonar.login=4b969d20bc514a359f1e5cf026da09a00e586a47

ConnectAllUrl=http://192.168.99.100:8090
SonarUrl=http://192.168.90.232:9000
ConnectAllApiKey=7a08b8b9-fbfd-4ce9-b3f3-8419c0442527
SonarUserid=admin
PROJECT=$2
#86769
APPLINK=$1
ISSUETYPE=$3
SONAR_ORIGIN=source
OTHER_ORIGIN=destination

# The time zone of the ConnectALL server
CA_timezone="-07"


