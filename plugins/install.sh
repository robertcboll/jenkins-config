#! /bin/bash
set -o pipefail

# usage $0 jenkins_url

URL=$1
CLI=/tmp/jenkins-cli.jar

PLUGIN_FILE=plugins.list
PLUGINS=`cat $PLUGIN_FILE | sed ':a;N;$!ba;s/\n/ /g'`

curl $URL/jnlpJars/jenkins-cli.jar > $CLI

java -jar $CLI -s $URL install-plugin $PLUGINS -restart
