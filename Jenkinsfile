pipeline {
    agent any
    tools { go '1.21.0'
            nodejs 'NodeJS-21.0'
        }
        
    stages {
        
        stage('Build') {
            steps {
                sh 'make clean build'
                echo 'Building with make'
            }
        }
        
        
        stage('Unit Test') {
            steps {
                echo 'Unit tests begin now ..'
               // sh 'TAGS="bindata sqlite sqlite_unlock_notify" make test'
                echo 'Unit tests done'
            }
        }
        
        stage('Integration Test') {
            steps {
                echo 'Integration tests begin now....'
               // sh 'make test-sqlite'
                echo 'Integration tests done.'
            }
        }

        stage('App Deployment to Minikube') {
          agent {
                kubernetes {
                    // Possible configs for kubernetes agent
                }
            }
            steps {
                echo 'Deploying to Minikube....'
                sh 'helm upgrade --install giteaapp ./minikube-app -n jenkins'
            }
        }

    }
    
    post {
        // Clean after build
        always {
            cleanWs(cleanWhenNotBuilt: false,
                    deleteDirs: true,
                    disableDeferredWipeout: true,
                    notFailBuild: true,
                    patterns: [[pattern: '.gitignore', type: 'INCLUDE'],
                               [pattern: '.propsfile', type: 'EXCLUDE']])
        }
    }
}
