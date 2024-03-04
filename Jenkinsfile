pipeline {
  agent any

  tools {
    maven 'Default'
    dockerTool 'Default'
  }
  
  stages {
    stage ('mvn test') {
      agent {
        label 'docker-agent'
      }
      steps {
        sh 'mvn -B clean test'
      }
    }
    stage ('mvn build jar') {
      agent {
        label 'docker-agent'
      }
      steps {
        sh 'mvn -B -DskipTests clean package'
        stash includes: 'target/*.jar', name: 'package'
      }
    }
    stage ('docker build image and push') {
      steps {
        unstash 'package'
        script {
          docker.withServer('tcp://docker:2376', '7605bcdb-2f4f-4c49-a82b-ee1718924a2f') {
            docker.withRegistry('http://nexus:8082', '') {
              def petclinicImage = docker.build("spring-petclinic:buildv00${BUILD_NUMBER}")
              petclinicImage.push()
            }
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
