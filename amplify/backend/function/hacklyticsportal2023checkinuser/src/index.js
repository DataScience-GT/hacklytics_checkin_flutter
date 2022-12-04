/* Amplify Params - DO NOT EDIT
	API_HACKLYTICSPORTAL2023_GRAPHQLAPIENDPOINTOUTPUT
	API_HACKLYTICSPORTAL2023_GRAPHQLAPIIDOUTPUT
	API_HACKLYTICSPORTAL2023_GRAPHQLAPIKEYOUTPUT
	AUTH_HACKLYTICSPORTAL2023_USERPOOLID
	ENV
	REGION
Amplify Params - DO NOT EDIT */

/**
 * @type {import('@types/aws-lambda').APIGatewayProxyHandler}
 */
exports.handler = async (event) => {
    console.log(`EVENT: ${JSON.stringify(event)}`);
    return {
        statusCode: 200,
    //  Uncomment below to enable CORS requests
    //  headers: {
    //      "Access-Control-Allow-Origin": "*",
    //      "Access-Control-Allow-Headers": "*"
    //  }, 
        body: JSON.stringify('Hello from Lambda!'),
    };
};
