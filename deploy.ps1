Write-Host "Creating temporary directory for Lambda package..."
$tempDir = "lambda_package"
New-Item -ItemType Directory -Force -Path $tempDir

Write-Host "Installing requirements..."
python -m pip install -r lambda/requirements.txt -t $tempDir

Write-Host "Copying Lambda function..."
Copy-Item "lambda/lambda_function.py" -Destination $tempDir

Write-Host "Creating ZIP file..."
Compress-Archive -Path "$tempDir\*" -DestinationPath function.zip -Force

Write-Host "Cleaning up temporary directory..."
Remove-Item -Path $tempDir -Recurse -Force

Write-Host "Creating log group..."
aws --endpoint-url=http://localhost:4566 --region eu-central-1 logs create-log-group `
    --log-group-name "/aws/lambda/hello-world"

Write-Host "Creating Lambda function..."
aws --endpoint-url=http://localhost:4566 --region eu-central-1 lambda create-function `
    --function-name hello-world `
    --runtime python3.12 `
    --handler lambda_function.lambda_handler `
    --zip-file fileb://function.zip `
    --role arn:aws:iam::000000000000:role/lambda-role

Write-Host "Creating EventBridge rule..."
aws --endpoint-url=http://localhost:4566 --region eu-central-1 events put-rule `
    --name "lambda-scheduler" `
    --schedule-expression "cron(*/1 * * * ? *)" `
    --state ENABLED

Write-Host "Adding Lambda permission for EventBridge..."
aws --endpoint-url=http://localhost:4566 --region eu-central-1 lambda add-permission `
    --function-name hello-world `
    --statement-id EventBridgeInvoke `
    --action lambda:InvokeFunction `
    --principal events.amazonaws.com `
    --source-arn "arn:aws:events:eu-central-1:000000000000:rule/lambda-scheduler"

Write-Host "Setting up EventBridge target..."
$targetJson = @"
[{
    "Id": "1",
    "Arn": "arn:aws:lambda:eu-central-1:000000000000:function:hello-world",
    "Input": "{\"parameter_name\":\"test_value\"}"
}]
"@

aws --endpoint-url=http://localhost:4566 --region eu-central-1 events put-targets `
    --rule lambda-scheduler `
    --targets $targetJson

Write-Host "Testing Lambda function..."
aws --endpoint-url=http://localhost:4566 --region eu-central-1 lambda invoke `
    --function-name hello-world `
    --payload '{}' `
    output.json

Get-Content output.json

Write-Host "Deployment complete!" 