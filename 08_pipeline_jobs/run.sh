#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
export ATC_URL=${ATC_URL:-"http://192.168.100.4:8080"}
export fly_target=${fly_target:-tutorial}
echo "Concourse API target ${fly_target}"
echo "Concourse API $ATC_URL"
echo "Tutorial $(basename $DIR)"

pushd $DIR
  yes y | fly -t ${fly_target} configure -c pipeline.yml
  curl $ATC_URL/pipelines/main/jobs/job-fetch-resource/builds -X POST
  fly -t ${fly_target} watch -j job-fetch-resource
  fly -t ${fly_target} watch -j job-run-task
popd
