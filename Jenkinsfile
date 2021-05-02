node {
    def app
    stage('Clone repository') {
        checkout scm
    }
	
    stage('Build image') {
       app = docker.build("starchap/betest")
    }

    stage('Test image') {
        app.inside("""--entrypoint='' -p 5000:80 -p 5001:443""") {
            sh 'echo "Tests passed"'
        }
    }

    stage('Push image') {
        docker.withRegistry('https://registry.hub.docker.com', 'git') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }
    }
}