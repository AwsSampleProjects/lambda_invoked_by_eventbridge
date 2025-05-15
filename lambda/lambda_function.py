def lambda_handler(event, context):
    parameter_name = event.get('parameter_name', 'No parameter provided')
    print(f"Received parameter: {parameter_name}")
    return {
        'statusCode': 200,
        'body': f'Received parameter: {parameter_name}'
    } 