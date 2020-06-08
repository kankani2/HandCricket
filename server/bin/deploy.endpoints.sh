#!/bin/bash

bash bin/gen.endpoints.sh
gcloud endpoints services deploy target/openapi-docs/openapi.json
