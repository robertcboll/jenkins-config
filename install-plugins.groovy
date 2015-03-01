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
        or {
          shell 'git show --pretty="format:" --name-only | grep "plugins.list"'
        } {
          shell '${BUILD_NUMBER} == 0'
        }
      }
      runner("Run")

      shell './plugins/install.sh ${JENKINS_URL}'
    }
  }
}

queue 'jenkins/install-plugins'
