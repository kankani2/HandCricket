#!/bin/bash

# Needed by Google Endpoints java Framework
export ENDPOINTS_SERVICE_NAME=resounding-sled-278521.appspot.com
export ENDPOINTS_SERVICE_VERSION=2020-07-04r0

# Regenerate target directory.
mvn clean
mvn package

bash ~/google-cloud-sdk/bin/java_dev_appserver.sh \
              --address=0.0.0.0 \
              --jvm_flag=-Duser.timezone=America/Chicago \
              target/handcricket-j8-0.0.1-SNAPSHOT/
