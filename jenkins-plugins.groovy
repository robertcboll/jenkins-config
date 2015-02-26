def git_url   = 'robertcboll/jenkins-configs'
def git_creds = 'jenkins'

job {
  name 'jenkins/jenkins-plugins'
  description 'script install of jenkins plugins'

  scm {
    git {
      remote {
        github git_url

        credentials git_creds
      }

      branch 'master'
    }
  }

  triggers {
    scm '' // allow triggers
  }

  steps {
    shell './plugins/install.sh'
  }
}
