const AWS = require('aws-sdk');

const db = new AWS.DynamoDB.DocumentClient({ apiVersion: '2012-08-10', region: process.env.AWS_REGION });

exports.handler = async event => {

  const params = {
    TableName: process.env.CONNECTIONS_TABLE,
    Item: {
      connectionId: event.requestContext.connectionId
    }
  };

  try {
    var res = await db.put(params).promise();
    console.log(res);
  } catch(err) {
    console.log(err);
    return { statusCode: 500, body: 'Failed to connect: ' + JSON.stringify(err) }
  }

  return { statusCode: 200, body: 'Connected' };
};