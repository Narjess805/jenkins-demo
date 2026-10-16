pipeline {
    agent any

    tools {
        jdk 'JDK-17'
        maven 'maven-3.6.3'
    }

    environment {
        IMAGE_NAME = "jenkins-demo"
        IMAGE_TAG = "1.0.0-${env.BUILD_NUMBER}"
        K8S_NAMESPACE = "jenkins-lab"
    }

    stages {
        stage('Checkout') {
            steps {
                echo '=== 1. Clone du repo GitHub ==='
                git branch: 'main', url: 'https://github.com/Narjess805/jenkins-demo.git'
            }
        }

        stage('Build Maven') {
            steps {
                echo '=== 2. Build Maven ==='
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker') {
            steps {
                echo '=== 3. Build Docker image ==='
                sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .'
            }
        }

        stage('Import into K3S') {
            steps {
                echo '=== 4. Import de l\'image dans K3S ==='
                sh '''
                    docker save ${IMAGE_NAME}:${IMAGE_TAG} -o /tmp/${IMAGE_NAME}.tar
                    sudo /usr/local/bin/k3s ctr images import /tmp/${IMAGE_NAME}.tar
                '''
            }
        }

        stage('Deploy to K3S') {
            steps {
                echo '=== 5. Déploiement sur K3S ==='
                sh '''
                    sed -i "s|image:.*|image: docker.io/library/${IMAGE_NAME}:${IMAGE_TAG}|" deployment.yaml
                    kubectl apply -f deployment.yaml
                    kubectl apply -f service.yaml
                    kubectl rollout status deployment/spring-app-deployment -n ${K8S_NAMESPACE} --timeout=180s
                '''
            }
        }

        stage('Verify') {
            steps {
                echo '=== 6. Vérification finale ==='
                sh '''
                    kubectl get pods -n ${K8S_NAMESPACE}
                    kubectl get svc -n ${K8S_NAMESPACE}
                    curl -s http://localhost:30090/ || echo "App pas encore prête"
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline terminé avec succès !'
        }
        failure {
            echo '❌ Pipeline échoué !'
        }
    }
}
