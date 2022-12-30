const AWS = require('aws-sdk');

exports.handler = async event => {
  
  const connectionId = event.requestContext.connectionId;

  const apigwManagementApi = new AWS.ApiGatewayManagementApi({
    apiVersion: '2018-11-29',
    endpoint: event.requestContext.domainName + '/' + event.requestContext.stage
  });

  const params = {
    ConnectionId: connectionId,
    Data: Buffer.from("Hello World!")
  };

  await apigwManagementApi.postToConnection(params).promise();

  return { statusCode: 200, body: 'Data sent.' };
};