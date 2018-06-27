throttle(['throttleDocker']) {
  node('docker') {
    wrap([$class: 'AnsiColorBuildWrapper']) {
      try{
        stage('Setup') {
          checkout scm
          sh '''
            ./setup.sh
          '''
        }
        stage('Capacity Test') {
          sh '''
            ./test.sh
          '''
        }
        stage('Deploy to Docker Swarm') {
          sh '''
            docker push ehemmerlin/resume
            export DOCKER_HOST="tcp://159.89.16.142:2375"
            docker stack deploy --with-registry-auth -c stack.yml resume
          '''
        }
      }
      finally {
        stage('Cleanup') {
          sh '''
            docker-compose down
          '''
        }
      }
    }
  }
}
