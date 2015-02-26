#! /bin/bash
set -x
BASEDIR=$(dirname $0)

$BASEDIR/bin/batch-install-jenkins-plugins.sh -p $BASEDIR/plugins.list -d $JENKINS_HOME/plugins

