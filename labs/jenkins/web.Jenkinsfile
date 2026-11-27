pipeline {
    agent any
    stages {
        stage('Archive web page') {
            steps {
                archiveArtifacts artifacts: 'labs/maven-web/src/main/webapp/index.html'
            }
        }
    }
}
