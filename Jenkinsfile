pipeline {
  agent {
    node {
      label 'docker-agent'
    }
  }

  triggers {
    pollSCM '*/5 * * * *'
  }

  tools {
    maven 'Default'
    docker 'Default'
  }

  stages {
    stage ('mvn test') {
      steps {
        sh 'mvn -B clean test'
      }
    }
    stage ('mvn build jar') {
      steps {
        sh 'mvn -B -DskipTests clean package'
      }
    }
    stage ('docker build image') {
      steps {
        docker.WithRegistry('http://nexus:8082') {
          def petclinicImage = docker.build("spring-petclinic:buildv00${BUILD_NUMBER}")
        }
      }
    }
    stage ('docker push to nexus') {
      steps {
        docker.WithRegistry('http://nexus:8082', 'f2fdbeda-e7eb-4ad9-bc6a-66017f108b94') {
          petclinicImage.push()
        }
      }
    }
  }
  
  post {
    always { 
      echo "Job completed"
    }
    success {
      echo "Job's done!"
    }
    failure {
      echo "Oh no!"
    }
  }
}