const AWS = require('aws-sdk');

const db = new AWS.DynamoDB.DocumentClient({ apiVersion: '2012-08-10', region: process.env.AWS_REGION });

exports.handler = async event => {
  const params = {
    TableName: process.env.CONNECTIONS_TABLE,
    Key: {
      connectionId: event.requestContext.connectionId
    }
  };

  try {
    await db.delete(params).promise();
  } catch (err) {
    return { statusCode: 500, body: 'Failed to disconnect: ' + JSON.stringify(err) };
  }

  return { statusCode: 200, body: 'Disconnected' };
};