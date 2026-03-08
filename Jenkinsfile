pipeline {
    agent { label 'devops-agent' }
    environment {
        IMAGE_NAME = "devops-app"
        IMAGE_TAG  = "latest"
    }
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/Lisa-commits-hub/mydevops.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .'
            }
        }
        stage('Verify Image') {
            steps {
                sh 'docker images | grep ${IMAGE_NAME}'
            }
        }
    }
    post {
        success { echo 'Docker image built successfully.' }
        failure { echo 'Pipeline failed.' }
    }
}
