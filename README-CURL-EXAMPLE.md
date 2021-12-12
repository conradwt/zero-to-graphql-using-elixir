curl \
 -i \
 --request POST \
 --url http://localhost:4000/graphql \
 -H "Content-Type: application/json" \
 --data '{"query":"query ExampleQuery($personId: ID!) {\n person(id: $personId) {\n email\n }\n}","variables":"{\n \"personId\": \"1\"\n}"}'
