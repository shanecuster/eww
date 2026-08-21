#!/bin/bash
curl -s 'https://api.printables.com/graphql/' \
  -H 'Content-Type: application/json' \
  -d '{
    "operationName": "UserProfileSocial",
    "variables": {"id": "849110"},
    "query": "query UserProfileSocial($id: ID!) { user(id: $id) { downloadCount makesCount } }"
  }' | jq '{downloads: .data.user.downloadCount, makes: .data.user.makesCount}'
