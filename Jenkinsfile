throttle(['throttleDocker']) {
  node('docker') {
    wrap([$class: 'AnsiColorBuildWrapper']) {
      try{
        stage('Setup') {
          checkout scm
          sh '''
            docker-compose down
            docker-compose up -d --build
          '''
        }
        stage('Capacity Test') {
          sh '''
            # warm up the compiler
            #echo 'GET http://localhost:8080' | vegeta attack -rate 100 -duration 1s > /dev/null

            # perform the stress test
            #echo 'GET http://localhost:8080' | timeout 7s vegeta attack -rate 100 -duration 5s | vegeta report
            #exit ${PIPESTATUS[1]}
          '''
        }
        stage('Deploy to Docker Swarm') {
          sh '''
            docker push ${REGISTRY}/resume:latest
            export DOCKER_HOST="tcp://46.101.112.188:2375"
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
