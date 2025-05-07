$targetUrl = "http://localhost:5047"
$reportPath = ".\zap-reports\zap-report.html"

Write-Host "Starting ZAP scan against $targetUrl"

# Run ZAP scan
docker run --rm -v ${PWD}/zap-reports:/zap/wrk/:rw --network="host" ghcr.io/zaproxy/zaproxy:stable zap-baseline.py -t $targetUrl -g gen.conf -r $reportPath

Write-Host "ZAP scan completed. Report saved to $reportPath"
