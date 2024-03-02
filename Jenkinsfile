pipeline {
    agent any

    tools {
        jdk "jdk17"
        maven "M3"
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
                   
                    docker.withRegistry("https://257307634175.dkr.ecr.ap-northeast-2.amazonaws.com/aws00-spring-petclinic", 
                                        "ecr:"ap-northeast-2:AWSCredentials") {
                      docker.image("spring-petclinic:1.0").push()
                    }
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
