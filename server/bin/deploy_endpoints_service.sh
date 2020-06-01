mvn clean
mvn package

# This is a hacky way to solve cloudendpoints/endpoints-java#187 and only works on Mac OS since BSD sed is different
# from GNU sed.
HC_SERVER="com.handcricket.appengine.HandCricketServlet"
EP_SERVER="com.google.api.server.spi.EndpointsServlet"

sed -i "" "s/${HC_SERVER}/${EP_SERVER}/g" src/main/webapp/WEB-INF/web.xml
mvn endpoints-framework:openApiDocs
sed -i "" "s/${EP_SERVER}/${HC_SERVER}/g" src/main/webapp/WEB-INF/web.xml

gcloud endpoints services deploy target/openapi-docs/openapi.json
