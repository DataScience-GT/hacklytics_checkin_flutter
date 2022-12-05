/* Amplify Params - DO NOT EDIT
	API_HACKLYTICSPORTAL2023_GRAPHQLAPIENDPOINTOUTPUT
	API_HACKLYTICSPORTAL2023_GRAPHQLAPIIDOUTPUT
	API_HACKLYTICSPORTAL2023_GRAPHQLAPIKEYOUTPUT
	AUTH_HACKLYTICSPORTAL2023_USERPOOLID
	ENV
	REGION
Amplify Params - DO NOT EDIT */

const AWS = require("aws-sdk");
const { default: fetch, Request } = require("node-fetch");
const { request, GraphQLClient } = require("graphql-request");
// const fetch = (...args) =>
//   import("node-fetch").then(({ default: fetch }) => fetch(...args));

/**
 * @type {import('@types/aws-lambda').APIGatewayProxyHandler}
 */
exports.handler = async (event) => {
    console.log(process.env)
  try {
    console.log(event);
    // verify that the user exists
    var params = {
      UserPoolId: process.env.AUTH_HACKLYTICSPORTAL2023_USERPOOLID,
      AttributesToGet: ["name"],
    };

    AWS.config.update({
      region: process.env.USER_POOL_REGION,
      accessKeyId: process.env.AWS_ACCESS_KEY_ID,
      secretAccessKey: process.env.AWS_SECRET_KEY,
    });
    var cognitoidentityserviceprovider =
      new AWS.CognitoIdentityServiceProvider();
    let x = await new Promise((resolve, reject) => {
      cognitoidentityserviceprovider.listUsers(params, (err, data) => {
        if (err) {
          reject(err);
        } else {
          resolve(data);
        }
      });
    });
    var users = x.Users;
    // no users found
    if (users.length <= 0) {
      return JSON.stringify({
        statusCode: 500,
        body: { ok: 0, error: "No users found in user pool." },
      });
    }
    var user = users.find((x) => x.Username == event.arguments.user_uuid);
    // user does not exist
    if (!user) {
      return JSON.stringify({
        statusCode: 400,
        body: { ok: 0, error: "User not found." },
      });
    }

    console.log(user);

    // user exists, check if event exists

    // get the event from graphql
    const query = `
        query GetEvent($id: ID!) {
            getEvent(id: $id) {
                id
                name
                description
                location
            }
        }
    `;
    const variables = {
      id: event.arguments.event_id,
    };
    const GRAPHQL_ENDPOINT =
      process.env.API_HACKLYTICSPORTAL2023_GRAPHQLAPIENDPOINTOUTPUT;
    const GRAPHQL_API_KEY =
      process.env.API_HACKLYTICSPORTAL2023_GRAPHQLAPIKEYOUTPUT;

    const options = {
      method: "POST",
      headers: {
        // "Content-Type": "application/json",
        "x-api-key": GRAPHQL_API_KEY,
      },
      body: JSON.stringify({
        query,
        variables,
      }),
    };

    const client = new GraphQLClient(GRAPHQL_ENDPOINT, {
      headers: {
        "x-api-key": GRAPHQL_API_KEY,
      },
    });

    const data = await client.request(query, variables);
    var json = JSON.parse(data);
    console.log(json);

    // let res = await request({
    //   url: GRAPHQL_ENDPOINT,
    //   document: query,
    //   variables,
    //   requestHeaders: {
    //     "x-api-key": GRAPHQL_API_KEY,
    //   },
    // });
    // console.log(res);
    // const request = new Request(GRAPHQL_ENDPOINT, options);

    // const response = await fetch(request);
    // const json = await response.json();
    // // const e = json.data.getEvent;
    // console.log(json);

    // event does not exist
    // if (!event) {
    // }

    return JSON.stringify({
      statusCode: 200,
      body: { ok: 1 },
    });
  } catch (err) {
    return JSON.stringify({
      statusCode: 500,
      //  Uncomment below to enable CORS requests
      //  headers: {
      //      "Access-Control-Allow-Origin": "*",
      //      "Access-Control-Allow-Headers": "*"
      //  },
      body: { ok: 0, error: err.message },
    });
  }
};
