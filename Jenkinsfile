pipeline {
    agent any
    
    tools {
        go '1.21.0'
        nodejs 'NodeJS-21.0'
    }
    
    environment {
        AWS_DEFAULT_REGION = 'eu-west-2'
        BUCKET_NAME = 'gitea-binary'
        S3_PREFIX = 'gitea-'
        VERSION = new Date().format('yyyyMMdd-HHmmss')
    }
    
    stages {
        stage('Build') {
            steps {
                echo 'Building with make'
                sh 'TAGS="bindata" make build'
                sh 'if [ -f gitea ]; then echo "Binary exists"; else echo "Binary does not exist"; fi'
            }
        }    
        
        stage('Deploy to S3') {
            steps {
                script{
                    echo "Deploying binary to S3 bucket with version ${VERSION}..."
                    withAWS(credentials: 'aws-credentials', region: AWS_DEFAULT_REGION) {
                        sh ''
                    }
                }
            }
        }
        
        stage('Infrastructure with Terraform') {
            steps {
                script{
                    echo "Building the infrustructure with Terraform...."
                    dir('ansible-terraform-aws') { 
                        withAWS(credentials: 'aws-credentials', region: AWS_DEFAULT_REGION) {
                        sh 'terraform init'
                        sh 'terraform apply -auto-approve'
                        }
                    } 
                }
            }
        }
        
        stage('Provision EC2 with Ansible playbook') {
            steps {
                script{
                    echo "Provision with Ansible...."
                    dir('ansible-terraform-aws') {
                        withAWS(credentials: 'aws-credentials', region: AWS_DEFAULT_REGION) {
                            sh 'ansible-galaxy collection install amazon.aws:==3.3.1 --force'
                            sh ''
                        }
                    } 
                }
            }
        }
        
        stage('Validate Destroy') {
            input {
                message "Should I destroy it?"
                ok "Destroy"
            }
            steps {
                echo "Destroy Approved"
            }
        }
        
        stage('Destroy') {
            steps {
                script{
                    echo "Destroying...."
                    dir('ansible-terraform-aws') {
                        withAWS(credentials: 'aws-credentials', region: AWS_DEFAULT_REGION) {
                            sh 'terraform destroy -auto-approve'
                        }
                    } 
                }
            }
        }
    }
        post {
            success {
                echo 'Success!'
            }
            
            failure {
                script{
                    echo "Destroying...."
                    dir('ansible-terraform-aws') {
                        withAWS(credentials: 'aws-credentials', region: AWS_DEFAULT_REGION) {
                            sh 'terraform destroy -auto-approve'
                    }
                }
            }
        }
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
