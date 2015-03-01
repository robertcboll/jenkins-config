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
java -jar $CLI -s $URL install-plugin $PLUGINS 2>/dev/null
java -jar $CLI -s $URL safe-restart 2>/dev/null

echo "waiting for jenkins restart"
sleep 30 # wait 30 seconds for shutdown, before we start polling
until java -jar $CLI -s $URL wait-node-online "">/dev/null 2>&1; do
  echo "waiting..." && sleep 5
done

echo "creating jenkins folder"
cat $DIR/jobs/jenkins-folder.xml | java -jar $CLI -s $URL create-job 'jenkins' 2>/dev/null

echo "creating bootstrap job"
cat $DIR/jobs/bootstrap.xml | java -jar $CLI -s $URL create-job 'jenkins/bootstrap' 2>/dev/null

echo "triggering bootstrap job"
java -jar $CLI -s $URL build 'jenkins/bootstrap' 2>/dev/null
