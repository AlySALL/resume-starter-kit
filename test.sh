# warm up the compiler
echo 'GET http://localhost:8080' | vegeta attack -rate 100 -duration 1s > /dev/null
# perform the stress test
echo 'GET http://localhost:8080' | timeout 7s vegeta attack -rate 100 -duration 5s | vegeta report
exit ${PIPESTATUS[1]}
