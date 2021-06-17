#!/bin/bash

source "gitlab.config.sh"

if [ -z "$GITLAB_PRIVATE_TOKEN" ];then
    echo "GITLAB_PRIVATE_TOKEN=\"\" > gitlab.config.sh" >&2
    exit 1
fi

BASE_URL=https://gitlab.manjaro.org
GROUP_NAME=manjaro-arm%2Fpackages%2Fcommunity%2Fnemo-ux

gitlab_data="$(mktemp /tmp/gitlab.XXXXXXX)"
curl --request GET --header "PRIVATE-TOKEN: $GITLAB_PRIVATE_TOKEN" "${BASE_URL}/api/v4/groups/${GROUP_NAME}/projects?per_page=1000" > "$gitlab_data"

for PROJECT in $(jq --raw-output '.[].id|@text' "$gitlab_data"); do

    curl -s -H "PRIVATE-TOKEN: ${GITLAB_PRIVATE_TOKEN}" "${BASE_URL}/api/v4/projects/${PROJECT}/jobs?per_page=${PER_PAGE:-50}" > x.json

    json=$(curl --silent  --request GET --header "PRIVATE-TOKEN: ${GITLAB_PRIVATE_TOKEN}"  "${BASE_URL}/api/v4/projects/${PROJECT}/jobs?scope[]=success&scope[]=failed&per_page=100"); 
    job=$(echo $json |jq "[.[] | select(.status==\"success\")  | select(.stage == \"test\"  )][0].id"); #"

    if [ "$job" = "null" ]; then
        echo "$PROJECT/No jobs and artifact found" >&2
        continue;
    fi

    code=$(curl --header "PRIVATE-TOKEN: ${GITLAB_PRIVATE_TOKEN}" "${BASE_URL}/api/v4/projects/${PROJECT}/jobs/$job/artifacts" --insecure --write-out %{http_code} --silent --output artifacts.zip);


    if [ "$code" != 200 ]; then 
        echo "Error: Cannot download artifacts for $PROJECT/$job, code $code" >&2;
        continue;
    fi

    echo $PROJECT/$job/$code

    unzip -o ./artifacts.zip
    rm -f ./artifacts.zip

done

rm -f "$gitlab_data"
