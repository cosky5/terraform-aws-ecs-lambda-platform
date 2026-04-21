def handler(event, context):
    print("Received event:", event)
    return {
        "statusCode": 200,
        "body": "Lambda processed event successfully"
    }