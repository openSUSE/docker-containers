#!/bin/bash -x

# put this in your .bash_profile
pull_request_test() {
  to_branch=$1
  if [ -z $to_branch ]; then
    to_branch="master"
  fi
  
  # try the upstream branch if possible, otherwise origin will do
  upstream=$(git config --get remote.upstream.url)
  origin=$(git config --get remote.origin.url)
  if [ -z $upstream ]; then
    upstream=$origin
  fi
  
  to_user=$(echo $upstream | sed -e 's/.*[\/:]\([^/]*\)\/[^/]*$/\1/')
  from_user=$(echo $origin | sed -e 's/.*[\/:]\([^/]*\)\/[^/]*$/\1/')
  repo=$(basename `git rev-parse --show-toplevel`)
  from_branch=$(git rev-parse --abbrev-ref HEAD)
  wget "https://github.com/$to_user/$repo/pull/new/$to_user:$to_branch...$from_user:$from_branch"
}
 
# usage
#pull_request              # PR to master
#pull_request other_branch # PR to other_branch

pull_request() {
    local to_branch="$1"
    if [ -z $to_branch ]; then
        to_branch="master"
    fi

    local access_token="624d6546ca72c91406c8f5623a39faaf0c3298b7"
    local root_endpoint="api.github.com"
    local origin="$(git config --get remote.origin.url)"
    local user="$(echo "$origin" | sed -e 's/.*[\/:]\([^/]*\)\/[^/]*$/\1/')"
    local repo="$(basename `git rev-parse --show-toplevel`)"
    local from_branch="$(git rev-parse --abbrev-ref HEAD)"

    curl -i \
        -H 'Authorization: token '"$access_token" \
        -H 'Accept: application/vnd.github.v3+json' \
        -d '{
                "title": "Amazing new feature",
                "body": "Please pull this in!",
                "head": "'"$from_branch"'",
                "base": "'"$to_branch"'"
            }' \
        -L https://"$root_endpoint"/repos/"$user"/"$repo"/pulls

}

pull_request "$@"
