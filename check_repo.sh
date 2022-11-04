#!/bin/bash

BASE_URL=https://gitlab.manjaro.org
GROUP_NAME=manjaro-arm%2Fpackages%2Fcommunity%2Fnemo-ux

source gitlab.config.sh 2> /dev/null
source ~/.config/gitlab.config.sh 2> /dev/null

if [ -z "$GITLAB_PRIVATE_TOKEN" ];then
    echo "echo 'GITLAB_PRIVATE_TOKEN=\"\"' > gitlab.config.sh # Add your token from ${BASE_URL}/-/profile/personal_access_tokens" >&2
    exit 1
fi

#gitlab_data="$(mktemp /tmp/gitlab.XXXXXXX)"
gitlab_data=./repos.json
if /bin/false; then
    rm -f "$gitlab_data"
    for i in 1 2 3 4; do
        curl --request GET --header "PRIVATE-TOKEN: $GITLAB_PRIVATE_TOKEN" "${BASE_URL}/api/v4/groups/${GROUP_NAME}/projects?per_page=100&page=$i" >> "$gitlab_data"
    done
fi

#echo "#!/bin/bash" > repos.sh
#echo "declare -A bash_array" >> repos.sh
#jq -r 'paths(scalars) as $p | "bash_array[\"\($p|[.[]|tostring]|join("."))\"]=\"\(getpath($p))\""'  -r $gitlab_data >> ./repos.sh

#for PROJECT in $(jq --raw-output '.[].id|@text' "$gitlab_data"); do
for SSH in $(jq --raw-output '.[].ssh_url_to_repo|@text' "$gitlab_data"|sort); do
    slug=$(basename $SSH)
    slug=${slug%.git}
    if [[ -d "$slug" || -d "devices/$slug" ]]; then
: #        echo OK $slug
    else
        if [ -d "${slug}-git" ]; then
            echo "# needs to be renamed ${slug}-git"
                git submodule deinit -f -- ${slug}-git
                rm -rf .git/modules/${slug}-git
                git rm -f ${slug}-git
        else
                echo "# Add submodule $slug"
echo                git submodule add -b master -- "$SSH" "$slug"
#                git submodule add -b master -- "$SSH" "$slug"
        fi
    fi
done

#rm -f "$gitlab_data"
