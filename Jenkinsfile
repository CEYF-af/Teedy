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
                sh 'sudo apt-get update && sudo apt-get install -y tesseract-ocr'
            }
        }

        stage('Build, Test, and Package') {
            steps {
                sh 'mvn clean install pmd:pmd surefire-report:report'
            }
            post {
                always {
                    junit '**/target/surefire-reports/*.xml'
                    pmd canComputeNew: false, defaultEncoding: '', healthy: '', pattern: '**/pmd.xml', unHealthy: ''
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
            archiveArtifacts artifacts: '**/target/*.jar, **/target/surefire-reports/*.html', fingerprint: true
        }
    }
}
