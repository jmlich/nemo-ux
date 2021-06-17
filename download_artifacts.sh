#!/bin/bash

source "gitlab.config.sh"

if [ -z "$GITLAB_PRIVATE_TOKEN" ];then
    echo "GITLAB_PRIVATE_TOKEN=\"\" > gitlab.config.sh" >&2
    exit 1
fi

BASE_URL=https://gitlab.manjaro.org
gitlab_data="$(mktemp /tmp/gitlab.XXXXXXX)"
#curl --request GET --header "PRIVATE-TOKEN: $GITLAB_PRIVATE_TOKEN" "${BASE_URL}/api/v4/groups/manjaro-arm%2Fpackages%2Fcommunity%2Fnemo-ux/projects?per_page=1000" > "$gitlab_data"
gitlab_data=/tmp/gitlab.m0oxFgV

for PROJECT in $(jq --raw-output '.[].id|@text' "$gitlab_data"); do

    curl -s -H "PRIVATE-TOKEN: ${GITLAB_PRIVATE_TOKEN}" "${BASE_URL}/api/v4/projects/${PROJECT}/jobs?per_page=${PER_PAGE:-50}" > x.json

    json=$(curl --silent  --request GET --header "PRIVATE-TOKEN: ${GITLAB_PRIVATE_TOKEN}"  "${BASE_URL}/api/v4/projects/${PROJECT}/jobs?scope[]=success&scope[]=failed&per_page=100"); 
    job=$(echo $json |jq "[.[] | select(.status==\"success\")  | select(.stage == \"test\"  )][0].id"); #"

    if [ "$job" = "null" ]; then
        echo "$PROJECT/No artifact found" >&2
        continue;
    fi

    code=$(curl --header "PRIVATE-TOKEN: ${GITLAB_PRIVATE_TOKEN}" "${BASE_URL}/api/v4/projects/${PROJECT}/jobs/$job/artifacts" --insecure --write-out %{http_code} --silent --output artifacts.zip);

    echo $PROJECT/$job/$code

    if [ "$code" != 200 ]; then 
        echo "Error: Cannot download artifacts for $job, code $code" >&2;
        continue;
    fi

    unzip -o ./artifacts.zip
    rm -f ./artifacts.zip

#    dir=$(echo "$repo" | sed 's/^[^:]*://')
#    mkdir -p "$dir"
#    git clone "$repo" "$dir"
done

#rm -f "$gitlab_data"
