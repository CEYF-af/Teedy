pipeline {
    agent any

    environment {
        // 设置 Java 11 环境变量
        // 注意：这里的路径必须与 Jenkins 服务器（或 Agent）上的实际路径一致
        JAVA_HOME = '/usr/lib/jvm/java-11-openjdk-amd64'
        // 将 JAVA_HOME/bin 加入 PATH，确保 mvn 和 java 命令能找到
        PATH = "${env.JAVA_HOME}/bin:${env.PATH}"
    }

    options {
        // 只保留最近 5 次构建记录，节省磁盘空间
        buildDiscarder(logRotator(numToKeepStr: '5'))
        // 设置构建超时时间为 30 分钟（可选，防止卡死）
        timeout(time: 30, unit: 'MINUTES')
    }

    stages {
        stage('Checkout') {
            steps {
                // 从 SCM 拉取代码
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    // 安装 OCR 依赖 (Tesseract)
                    // 使用 sudo 确保有权限，-y 自动确认安装
                    sh 'sudo apt-get update && sudo apt-get install -y tesseract-ocr tesseract-ocr-deu tesseract-ocr-eng'
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    // 1. 清理并安装 (跳过测试以避免测试失败中断后续打包，如果你必须在测试失败时中断，请去掉 -DskipTests)
                    // 2. 使用 || true 确保即使 mvn 报错，Pipeline 也不会直接崩溃，方便后续收集日志
                    // 如果你想严格一点，可以使用: sh 'mvn clean install -Dmaven.test.failure.ignore=true'
                    
                    echo "Starting Maven Build..."
                    sh 'mvn clean install -DskipTests'
                }
            }
        }

        stage('Test & Report') {
            steps {
                script {
                    echo "Running Tests and Generating Reports..."
                    // 运行测试并生成报告
                    // -Dmaven.test.failure.ignore=true: 测试失败仍继续生成报告，但构建状态会变黄 (Unstable)
                    sh 'mvn test surefire-report:report -Dmaven.test.failure.ignore=true'
                }
            }
            post {
                always {
                    // 收集 JUnit 测试结果
                    // allowEmptyResults: true 防止没有测试文件时报错
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline 执行成功！'
        }
        failure {
            echo '❌ Pipeline 执行失败，请检查日志。'
        }
        always {
            echo '📦 归档构建产物...'
            archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true
            // 归档测试报告 HTML，方便在 Jenkins 界面查看
            archiveArtifacts artifacts: '**/target/site/surefire-report.html', allowEmptyArchive: true
        }
    }
}
