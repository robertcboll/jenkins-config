# jenkins-config

## what does it do?
* bootstraps a raw jenkins instance from scratch
* automates the install of plugins, and creation of jobs

## .jenkins
`.jenkins` allows configuration of jenkins jobs from dsl scripts within a project's own repository. `dotjenkins-init` runs the scripts in a project's `.jenkins` folder. typically, a project will create it's own sync script to keep the job definitions current. there's a good example at [dotjenkins-test](https://github.com/robertcboll/dotjenkins-test).

## plugins
a list of plugins is maintained, and installed during the bootstrap phase. thereafter, any changes to the list of plugins will be picked up on push and plugins will be updated, followed by a safe restart.

## bootstrap
1. start a new jenkins instance
2. run `bootstrap/bootstrap.sh ${jenkins_url}`
