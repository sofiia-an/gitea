pipeline {
    agent any
    tools { go '1.21.0'
            nodejs 'NodeJS-21.0'
        }
    triggers {
        cron('H */12 * * *') // every 12 hours
    }
        
    stages {
        
        stage('Build') {
          when {
        expression { 
            echo "CHANGE_ID value: ${env.CHANGE_ID}"
            return env.CHANGE_TARGET != null && env.CHANGE_TARGET == 'main'
        }
          }
            steps {
                sh 'make clean build'
                echo 'Building with make'
            }
        }
        
        
        stage('Unit Test') {
              when {
                expression { env.CHANGE_ID != null } 
              }
            steps {
                echo 'Unit tests begin now ..'
                sh 'TAGS="bindata sqlite sqlite_unlock_notify" make test'
                echo 'Unit tests done'
            }
        }
        
        stage('Integration Test') {
            steps {
                echo 'Integration tests begin now....'
                sh 'make test-sqlite'
                echo 'Integration tests done.'
            }
        }

        stage('App Deployment to Minikube') {
          agent {
                kubernetes {
            yaml '''
            apiVersion: v1
            kind: Pod
            spec:
              containers:
              - name: helm
                image: lachlanevenson/k8s-helm:v3.1.1
                command:
                - cat
                tty: true
            '''
                }
            }
            
            steps {
                container('helm') { 
                echo 'Deploying to Minikube....'
                sh 'helm upgrade --install giteaapp ./minikube-app -n jenkins'
            }
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
