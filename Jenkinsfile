pipeline {
agent any

```
tools {
    jdk 'jdk17'   // Assure-toi que JDK17 est installé dans Jenkins
}

stages {
    stage("Checkout") { 
        steps {
            git branch: "master",
                url: "https://github.com/Yassmineouadday/student-management.git",
                credentialsId: "Eisbuk-pat"   // ID de la credential GitHub (token)
        }
    }

    stage("Build") {
        steps {
            sh "mvn clean package -DskipTests -f student-management/pom.xml"
        }
    }

    stage("Build Docker Image") {
        steps {
            sh "docker build -t yasswdy/student-management:latest student-management"
        }
    }

    stage("Push Docker Image") {
        steps {
            withCredentials([usernamePassword(credentialsId: 'DOCKERHUB_CREDENTIALS', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                sh 'docker push yasswdy/student-management:latest'
            }
        }
    }
}

post {
    success {
        echo "Build et push Docker réussis ! "
    }
    failure {
        echo "Build échoué "
    }

}
