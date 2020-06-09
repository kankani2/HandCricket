import json
import sys

if len(sys.argv) != 2:
    print("Usage: python3 openapi_intercept.py [path to openApi doc]")

# We can do any custom modifications to the open API document here.
with open(sys.argv[1]) as file:
    apiSpec = json.load(file)

    projectId = apiSpec["host"][: apiSpec["host"].index(".appspot.com")]
    apiSpec["securityDefinitions"] = {
        "firebase": {
            "authorizationUrl": "",
            "flow": "implicit",
            "type": "oauth2",
            "x-google-issuer": f"https://securetoken.google.com/{projectId}",
            "x-google-jwks_uri": "https://www.googleapis.com/service_accounts/v1/metadata/x509/securetoken@system.gserviceaccount.com",
            "x-google-audiences": projectId,
        }
    }
    apiSpec["security"] = [{"firebase": []}]


with open(sys.argv[1], "w") as file:
    json.dump(apiSpec, file, indent=2)
