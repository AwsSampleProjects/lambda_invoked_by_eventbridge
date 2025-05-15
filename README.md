# LocalStack Lambda Project

This project demonstrates a Lambda function running on LocalStack with EventBridge scheduler integration.

## Project Structure
```
.
├── lambda/
│   ├── lambda_function.py
│   └── requirements.txt
├── docker-compose.yml
├── deploy.ps1
├── list-lambdas.ps1
├── list-rules.ps1
├── view-logs.ps1
└── README.md
```

## Prerequisites

- Docker and Docker Compose
- AWS CLI
- Python 3.12
- PowerShell

## Setup

1. Start LocalStack:
```powershell
docker-compose up -d
```

2. Deploy the Lambda function and set up EventBridge scheduler:
```powershell
.\deploy.ps1
```

The deployment script will:
- Install Python requirements
- Create a deployment package
- Deploy the Lambda function
- Create an EventBridge rule that runs every 15 seconds
- Set up permissions for EventBridge to invoke Lambda
- Configure the Lambda function to receive a test parameter

## Managing Resources

### List Lambda Functions
To list all Lambda functions in LocalStack:
```powershell
.\list-lambdas.ps1
```

### List EventBridge Rules
To list all EventBridge rules:
```powershell
.\list-rules.ps1
```

### View Lambda Logs
To view the logs of Lambda invocations triggered by EventBridge:
```powershell
.\view-logs.ps1
```

### Testing Lambda Manually
You can manually invoke the Lambda function with a custom parameter:
```powershell
aws --endpoint-url=http://localhost:4566 --region eu-central-1 lambda invoke `
    --function-name hello-world `
    --payload '{"parameter_name":"custom_value"}' `
    output.json
```

## Cleanup

To stop LocalStack:
```powershell
docker-compose down
``` 