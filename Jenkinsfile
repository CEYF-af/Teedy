pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
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
