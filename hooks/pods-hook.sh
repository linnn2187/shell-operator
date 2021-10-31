#!/usr/bin/env bash

source /shell_lib.sh

function __config__() {
  cat <<EOF
configVersion: "v1"
kubernetes: 
- name: monitor-events
  apiVersion: v1
  kind: Event
  namespace: 
    nameSelector: 
      matchNames: ["monitor-events"]
  fieldSelector: 
    matchExpressions: 
    - field: "reason"
      operator: Equals
      value: "Unhealthy"
EOF
}

function __main__()  {
  type=$(jq -r '.[0].type' ${BINDING_CONTEXT_PATH})
  if [[ $type == "Event" ]] ; then
    resourceNS=$(jq -r '.[0].object.involvedObject.namespace' $BINDING_CONTEXT_PATH)
    resourceName=$(jq -r '.[0].object.involvedObject.name' $BINDING_CONTEXT_PATH)
    echo "=== Got Event ==="
    jq '.[0].object.message' ${BINDING_CONTEXT_PATH}
    kubectl sniff $resourceName -n $resourceNS -o - | tshark -r -
  fi
}

hook::run $@
