#!/bin/bash

projectId="zanenet-njinck"

fhirDevUrl="https://healthcare.googleapis.com/v1/projects/zanenet-njinck/locations/us-east4/datasets/dev-zanenet-njinck/fhirStores/dev-zanenet-njinck-datastore/fhir"
fhirStageUrl="https://healthcare.googleapis.com/v1/projects/zanenet-njinck/locations/us-east4/datasets/stage-zanenet-njinck/fhirStores/stage-zanenet-njinck-datastore/fhir"
fhirProdUrl="https://healthcare.googleapis.com/v1/projects/zanenet-njinck/locations/us-central1/datasets/prod-zanenet-njinck/fhirStores/prod-zanenet-njinck-datastore/fhir"


# change to correct project so you don't have to do this manually
gcloud config set project $projectId
# only needed the first time
# gcloud auth login

# dev server
curl -X POST \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    -H "content-type: application/fhir+json; charset=utf-8" \
    --data @./"devBundle.json" \
        "$fhirDevUrl" > devBundleUploaded.json
        
# stage server
# curl -X POST \
#     -H "Authorization: Bearer $(gcloud auth print-access-token)" \
#     -H "content-type: application/fhir+json; charset=utf-8" \
#     --data @./"stageBundle.json" \
#         "$fhirStageUrl" > stageBundle.json

# prod server
# curl -X POST \
#     -H "Authorization: Bearer $(gcloud auth print-access-token)" \
#     -H "content-type: application/fhir+json; charset=utf-8" \
#     --data @./"prodBundle.json" \
#         "$fhirProdUrl" > prodBundle.json