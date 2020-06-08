## App Engine Server

This directory holds the java8 GAE app which serves our handcricket RESTful API. We have used Google Cloud Endpoints
which serves as a [Extensible Service Proxy](https://cloud.google.com/endpoints/docs/openapi/glossary#extensible_service_proxy)
for authentication, logging and monitoring. The endpoints are backed by our java8 servelet app deployed on Google App
Engine. 

We have used [Cloud Endpoints Framework](https://cloud.google.com/endpoints/docs/frameworks/about-cloud-endpoints-frameworks)
which makes it even easier to generate REST APIs.

We have integrated the server with Firebase. The server authenticates with Firebase using a service account with at
least the Editor role and is the only entity that writes to the database.

#### Scripts

- `./bin/run.sh` - Used for running the app engine server locally. You can send requests at http://localhost:8080.
- `./bin/gen.endpoints.sh` - Generates our [OpenAPI document](https://swagger.io/specification/) at path
`target/openapi-docs/openapi.json`.
- `./bin/deploy.endpoints.sh` - Generates the openApi doc and deploys it to Cloud Endpoints.
- `./bin/deploy.app.sh` - Deploys the GAE java app to cloud.

#### Configuration

The following files have been git-ignored but are required to deploy/run the app.

- `src/main/webapp/WEB-INF/firebase.json` - The service account key json file.
