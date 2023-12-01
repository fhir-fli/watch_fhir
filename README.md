# watch_fhir

A server build using [Shelf](https://pub.dev/packages/shelf) and an [atsign](https://docs.atsign.com/) configured to enable running with [Docker](https://www.docker.com/) to allow microservices to be run alongside a FHIR database.

## Setup

1. ```assets/``` and ```home/``` folders needs to be added to primary project directory
2. Save a copy of your ```.atKeys``` file in the assets folder
3. ```lib/models/assets.dart``` file, includes a Yaml file as a dart String. The original Yaml file (so we can callout entries) should look like this:

```yaml
---
# there are times when we only need this server to communicate (send emails or sms to users)
communicationsOnly: false
# if you want to allow communications via email
allowEmails: true
# if you want to allow communications via text
allowTexts: false
# this is a service account from google that we'll use to send emails
serviceAccountEmail: serviceaccount@yourcompany.com
emailSubject: Message from MayJuun
# this is the information from a Twilio account required to send sms
twilioAssets:
  accountSid: f05eb9777cd540adb2dea3e7011bd999
  authToken: 516e665ab7014ba2b192931f35d03fc6
  twilioNumber: "+155555555555"
  minute: '0'
  hour: "*"
  day: "*"
  month: "*"
  dayOfWeek: "*"
# this is the serviceAccountCredentials from GCP
serviceAccountCredentials:
  type: service_account
  project_id: watch-fhir
  private_key_id: 94c63c4869ad4be2a22f89e01ec56e49
  private_key: |
    -----BEGIN PRIVATE KEY-----
    alongprivatekeyfromgooglethatyougetwhenyoudownloadjson
    -----END PRIVATE KEY-----
  client_email: watch-fhir@watch-fhir.iam.gserviceaccount.com
  client_id: '2e231c4690f44d7cbe473ede3ff37293'
  auth_uri: https://accounts.google.com/o/oauth2/auth
  token_uri: https://oauth2.googleapis.com/token
  auth_provider_x509_cert_url: https://www.googleapis.com/oauth2/v1/certs
  client_x509_cert_url: https://www.googleapis.com/robot/v1/metadata/x509/watch-fhir.iam.gserviceaccount.com
  universe_domain: googleapis.com
```
# GCP Examples

- It's hard to find examples of what a post from a Pub/Sub with GCP looks like (which is especially annoying for testing purposes). Here is one below:

