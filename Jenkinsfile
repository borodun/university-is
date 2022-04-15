pipeline {
    agent any

    tools {
        jdk 'openjdk-17'
        nodejs 'nodejs-17.8'
    }

    stages {
        stage('Build'){
            parallel {
                stage('Build backend') {
                    environment {
                        mvn = tool 'maven-3.8.5'
                    }

                    steps {
                        dir("backend") {
                            sh "${mvn}/bin/mvn package -Dmaven.test.skip"
                        }
                    }
                }

                stage('Build frontend') {
                    steps {
                        dir("frontend") {
                            script {
                                sh "npm install"
                                sh "npm run build"
                                sh "ls"
                            }
                        }
                    }
                }

                stage('Login in registry') {
                    steps {
                        withCredentials([usernamePassword(credentialsId: 'registry-cred', passwordVariable: 'password', usernameVariable: 'user')]) {
                            sh "docker login https://registry.borodun.works -u ${env.user} -p ${env.password}"
                        }
                    }
                }
            }
        }

        stage('Images') {
            parallel {
                stage('Build backend image') {
                    steps {
                        dir("backend") {
                            sh "docker build . -t registry.borodun.works/root/university/backend:${env.BUILD_NUMBER}"
                        }
                        sh "docker push registry.borodun.works/root/university/backend:${env.BUILD_NUMBER}"
                    }
                }

                stage('Build frontend image') {
                    steps {
                        dir("frontend") {
                            sh "docker build . -t registry.borodun.works/root/university/frontend:${env.BUILD_NUMBER}"
                        }
                        sh "docker push registry.borodun.works/root/university/frontend:${env.BUILD_NUMBER}"
                    }
                }
            }
        }

        stage('Deploy to k8s') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'CONFIG')]) {
					sh "kubectl apply -f k8s-manifests/ingress.yaml --kubeconfig=\"$CONFIG\" -n gitlab"
                    sh "kubectl set image deployment/university-backend-deployment university-backend=registry.borodun.works/root/university/backend:${env.BUILD_NUMBER} --kubeconfig=\"$CONFIG\" -n gitlab"
                    sh "kubectl set image deployment/university-frontend-deployment university-frontend=registry.borodun.works/root/university/frontend:${env.BUILD_NUMBER} --kubeconfig=\"$CONFIG\" -n gitlab"
                }
            }
        }
    }
}
