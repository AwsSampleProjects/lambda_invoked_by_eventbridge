Write-Host "Fetching Lambda function logs..."

$logStreams = aws --endpoint-url=http://localhost:4566 --region eu-central-1 logs describe-log-streams `
    --log-group-name "/aws/lambda/hello-world" `
    --order-by LastEventTime `
    --descending `
    --limit 1 `
    --query 'logStreams[0].logStreamName' `
    --output text

if ($logStreams -eq "None") {
    Write-Host "No log streams found yet. Waiting for Lambda invocations..."
} else {
    aws --endpoint-url=http://localhost:4566 --region eu-central-1 logs get-log-events `
        --log-group-name "/aws/lambda/hello-world" `
        --log-stream-name $logStreams 
} 