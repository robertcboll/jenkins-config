#! /bin/bash
set -o pipefail

# usage $0 jenkins_url

URL=${1:-http://localhost:8080}
DIR=$(dirname $0)

CLI=/tmp/jenkins-cli.jar

PLUGIN_FILE=$DIR/plugins.list
PLUGINS=`cat $PLUGIN_FILE | sed ':a;N;$!ba;s/\n/ /g'`

echo "downloading jenkins-cli"
curl --silent $URL/jnlpJars/jenkins-cli.jar > $CLI

echo "installing plugins"
java -jar $CLI -s $URL install-plugin $PLUGINS -restart 2>/dev/null
