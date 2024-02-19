pipeline { agent any tools { go '1.21.0' nodejs 'NodeJS-21.0'
        }
        
    stages {
        
        stage('Build with Docker') { agent { dockerfile true } steps { echo 'Building with Dockerfile'
            }
        }
        
        
        stage('Unit Test') { when { branch 'dev'
            }
            steps { echo 'Unit tests begin now ..' sh 'TAGS="bindata sqlite sqlite_unlock_notify" make test'
            }
        }
        
        stage('Integration Test') { when { branch 'main'
            }
            steps { echo 'Integration tests begin now....' sh 'make test-sqlite'
            }
        }
    }
    
    post {
        // Clean after build
        always { cleanWs(cleanWhenNotBuilt: false, deleteDirs: true, disableDeferredWipeout: true, notFailBuild: 
                    true, patterns: [[pattern: '.gitignore', type: 'INCLUDE'],
                               [pattern: '.propsfile', type: 'EXCLUDE']])
        }
    }
}
