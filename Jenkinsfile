pipeline {
  agent any

  tools {
    maven 'Default'
    dockerTool 'Default'
  }
  
  stages {
    stage ('docker build image') {
      steps {
        script {
          docker.withServer('tcp://docker:2376', '7605bcdb-2f4f-4c49-a82b-ee1718924a2f') {
            def petclinicImage = docker.build("nexus:8082/spring-petclinic:buildv00${BUILD_NUMBER}")
          }
        }
      }
    }
    stage ('docker push to nexus') {
      steps {
        script {
          docker.withServer('tcp://docker:2376', '7605bcdb-2f4f-4c49-a82b-ee1718924a2f') {
            petclinicImage.push("nexus:8082/spring-petclinic:buildv00${BUILD_NUMBER}")
          }
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
