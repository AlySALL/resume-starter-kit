throttle(['throttleDocker']) {
  node('docker') {
    wrap([$class: 'AnsiColorBuildWrapper']) {
      try{
        stage('Setup') {
          checkout scm
          sh '''
            docker-compose down
            docker-compose up -d --build
            docker-compose logs -f &
            pid=$!

            for i in `seq 1 600`; do
              # wait for containers to come up
              sleep 1
              # get a response from backend and frontend
              curl localhost:8080 >/dev/null 2>&1
              # exit if successful
              if [ $? -eq 0 ]; then
                kill $pid
                wait $pid
                echo "Docker container started"
                exit 0
              fi
            done

            # init script did not run
            kill $pid
            wait $pid
            >&2 echo "Docker container did not start"
            exit 1
          '''
        }
        stage('Capacity Test') {
          sh '''
            # warm up the compiler
            echo 'GET http://localhost:8080' | vegeta attack -rate 100 -duration 1s > /dev/null

            # perform the stress test
            echo 'GET http://localhost:8080' | timeout 7s vegeta attack -rate 100 -duration 5s | vegeta report
            exit ${PIPESTATUS[1]}
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
