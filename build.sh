#!/bin/bash

# Teedy 项目构建脚本
# 用于在 Ubuntu WSL2 中使用 JDK 11 构建项目并生成报告

# 设置项目目录
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

# 设置 JDK 11 路径
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export PATH="$JAVA_HOME/bin:$PATH"

echo "========================================"
echo "Teedy 项目构建脚本"
echo "========================================"
echo ""
echo "Java 版本:"
java -version
echo ""
echo "Maven 版本:"
mvn -version
echo ""
echo "========================================"
echo "开始构建项目..."
echo "========================================"
echo ""

# 构建项目并生成报告
mvn clean install pmd:pmd surefire-report:report

# 检查构建结果
if [ $? -eq 0 ]; then
    echo ""
    echo "========================================"
    echo "✅ 构建成功！"
    echo "========================================"
    echo ""
    echo "报告位置:"
    echo "  - 测试报告: **/target/surefire-reports/*.html"
    echo "  - PMD报告:  **/target/pmd.xml"
    echo "  - 构建产物: **/target/*.jar, **/target/*.war"
    echo ""
else
    echo ""
    echo "========================================"
    echo "❌ 构建失败！"
    echo "========================================"
    exit 1
fi
