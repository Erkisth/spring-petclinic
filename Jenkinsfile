pipeline {
  agent {
    node {
      label 'docker-agent'
    }
  }

  tools {
    maven 'Default'
    dockerTool 'Default'
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
        sh 'docker build -t nexus:8082/spring-petclinic:buildv00${BUILD_NUMBER} .'
      }
    }
    stage ('docker push to nexus') {
      steps {
        sh 'docker push nexus:8082/spring-petclinic:buildv00${BUILD_NUMBER}'
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
