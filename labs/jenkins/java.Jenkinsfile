pipeline {
    agent any
    stages {
        stage('Build and test Java') {
            steps {
                dir('labs/maven-java') {
                    sh 'mvn test package'
                }
            }
        }
    }
}
