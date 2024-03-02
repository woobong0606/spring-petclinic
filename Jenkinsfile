pipeline {
    agent any

    tools {
        jdk "jdk17"
        maven "M3"
    }
    environment {
        AWS_CREDENTIAL_NAME = "AWSCredentials"
        REGION = "ap-northeast-2"
        DOCKER_IMAGE_NAME="aws00-spring-petclinic"
        DOCKER_TAG="1.0"
        ECR_REPOSITORY = "257307634175.dkr.ecr.ap-northeast-2.amazonaws.com"
        ECR_DOCKER_IMAGE = "${ECR_REPOSITORY}/${DOCKER_IMAGE_NAME}"
        ECR_DOCKER_TAG = "${DOCKER_TAG}"        
    }
    
    stages {
        stage('Git Clone') {
            steps {
                echo 'Git Clone'
                git url: 'https://github.com/sjh4616/spring-petclinic.git',
                branch: 'wavefront'
            }
            post {
                success {
                    echo 'success clone project'
                }
                failure {
                    error 'fail clone project' // exit pipeline
                }
            }
        }        
        stage ('mvn Build') {
            steps {
                sh 'mvn -Dmaven.test.failure.ignore=true install' 
            }
            post {
                success {
                    junit '**/target/surefire-reports/TEST-*.xml' 
                }
            }
        }        
        stage ('Docker Build') {
            steps {
                dir("${env.WORKSPACE}") {
                    sh 'docker build -t aws00-spring-petclinic:1.0 .'
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                echo "Push Docker Image to ECR"
                script{
                    // cleanup current user docker credentials
                    sh 'rm -f ~/.dockercfg ~/.docker/config.json || true' 
                    sh 'aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin 257307634175.dkr.ecr.ap-northeast-2.amazonaws.com'
                    sh 'docker tag aws00-spring-petclinic:1.0 257307634175.dkr.ecr.ap-northeast-2.amazonaws.com/aws00-spring-petclinic:1.0'
                    sh 'docker push 257307634175.dkr.ecr.ap-northeast-2.amazonaws.com/aws00-spring-petclinic:1.0'
                }
            }
            post {
                success {
                    echo "Push Docker Image success!"
                }
            }
        }
    }
}
