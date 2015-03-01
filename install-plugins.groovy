job {
  name '_jenkins/install-plugins'
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
          shell 'if [ ${BUILD_NUMBER} -eq 1 ]; then exit 0; else exit 1; fi'
        }
      }
      runner("Unstable")

      shell './plugins/install.sh ${JENKINS_URL}'
    }
  }
}

queue 'jenkins/install-plugins'
