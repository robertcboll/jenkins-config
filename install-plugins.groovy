job {
  name 'jenkins/install-plugins'
  description 'script install of jenkins plugins'

  scm {
    git {
      remote {
        github 'robertcboll/jenkins-config'
      }
      branch 'master'
    }
  }

  triggers {
    githubPush() 
  }

  steps {
    conditionalSteps {
      condition {
        shell 'git show --pretty="format:" --name-only | grep "plugins.list"'
      }
      runner("Run")

      shell './plugins/install.sh ${JENKINS_URL}'
    }
  }
}

queue 'jenkins/install-plugins'
