def git_url   = 'robertcboll/jenkins-configs'

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
    shell './plugins/install.sh ${JENKINS_URL}'
  }
}

queue 'jenkins/install-plugins'
