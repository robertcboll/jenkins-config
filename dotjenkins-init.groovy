job {
  name '_jenkins/dotjenkins-init'
  description 'initialize jobs for a .jenkins repo'

  parameters {
    stringParam 'git_url'
    stringParam 'git_creds'
    stringParam 'git_branch'
  }

  scm {
    git {
      remote {
        url '${git_url}'       
        credentials '${git_creds}'
      }

      branch '${git_branch}'
    }
  }

  steps {
    dsl {
      removeAction 'IGNORE'
      external '.jenkins/*.groovy'
    }
  }
}
