#! /bin/bash
set -o pipefail

# usage $0 jenkins_url

URL=$1
CLI=/tmp/jenkins-cli.jar

DIR=$(dirname $0)
PLUGINS='job-dsl github cloudbees-folder conditional-buildstep'

echo "downloading jenkins-cli"
curl --silent $URL/jnlpJars/jenkins-cli.jar > $CLI

echo "opening the web ui to trigger update center pull."
open "$URL" || 0
echo "press any key to continue..."
read

echo "installing plugins and restarting"
java -jar $CLI -s $URL install-plugin $PLUGINS
java -jar $CLI -s $URL safe-restart

echo "waiting for jenkins restart"
sleep 30 # wait 30 seconds for shutdown, before we start polling
until java -jar $CLI -s $URL wait-node-online "">/dev/null 2>&1; do
  echo "waiting..." && sleep 5
done

echo "creating jenkins folder"
cat $DIR/jobs/folder.xml | java -jar $CLI -s $URL create-job '_jenkins'

echo "creating bootstrap job"
cat $DIR/jobs/bootstrap.xml | java -jar $CLI -s $URL create-job '_jenkins/bootstrap'

echo "triggering bootstrap job"
java -jar $CLI -s $URL build -f '_jenkins/bootstrap'

echo "waiting for jenkins restart"
java -jar $CLI -s $URL wait-node-offline ""

sleep 30 # wait 30 seconds for shutdown, before we start polling
until java -jar $CLI -s $URL wait-node-online "">/dev/null 2>&1; do
  echo "waiting..." && sleep 5
done

if [ ! -z $GITHUB_CLIENT_ID ] && [ ! -z $GITHUB_CLIENT_SECRET ]; then
  echo "configuring github auth"
  java -jar $CLI -s $URL groovy github-oauth.groovy $GITHUB_CLIENT_ID $GITHUB_CLIENT_SECRET
fi
