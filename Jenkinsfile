pipeline {
    agent any

    environment {
        DOCKER_IMAGE      = "yasswdy/student-management"
        DOCKER_CREDENTIAL = "dockerhub-credentials"
        K8S_DIR           = "k8s"
    }

    stages {
        stage('Checkout') {
            steps {
                // Récupère le code depuis GitHub (origin/main)
                checkout scm
            }
        }

        stage('Build') {
            steps {
                // Compile le projet et génère le JAR (teste désactivés ici)
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Docker build & push') {
            steps {
                script {
                    // Connexion à Docker Hub avec les credentials configurés dans Jenkins
                    docker.withRegistry('https://registry.hub.docker.com', DOCKER_CREDENTIAL) {
                        // Construit l'image Docker à partir du Dockerfile à la racine du projet
                        def image = docker.build("${DOCKER_IMAGE}:${env.BUILD_NUMBER}")
                        // Push avec le tag du build (ex: yasswdy/student-management:12)
                        image.push()
                        // Push aussi le tag latest
                        image.push("latest")
                    }
                }
            }
        }

        stage('Deployment Kubernetes') {
            steps {
                // Applique les fichiers YAML dans le cluster (Minikube)
                sh """
                  kubectl apply -f ${K8S_DIR}/mysql-secret.yaml
                  kubectl apply -f ${K8S_DIR}/mysql-pvc.yaml
                  kubectl apply -f ${K8S_DIR}/mysql-deployment.yaml
                  kubectl apply -f ${K8S_DIR}/springboot-deployment.yaml
                """
            }
        }
    }
}
