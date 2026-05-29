pipeline {
    agent any

    environment {
        // JDK 11 的路径
        JAVA_HOME = '/usr/lib/jvm/java-11-openjdk-amd64'
        PATH = "${env.JAVA_HOME}/bin:${env.PATH}"
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'sudo apt-get update && sudo apt-get install -y tesseract-ocr tesseract-ocr-deu tesseract-ocr-eng'
            }
        }

        stage('Build, Test, and Package') {
            steps {
                sh 'mvn clean install surefire-report:report'
            }
            }
            post {
                always {
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }
    }

    post {
        success {
            echo 'Build successful!'
        }
        failure {
            echo 'Build failed!'
        }
        always {
            archiveArtifacts artifacts: '**/target/*.jar, **/target/surefire-reports/*.html, **/target/pmd.xml', fingerprint: true
        }
    }
}
