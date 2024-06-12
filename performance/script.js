import { check, sleep } from 'k6';
import { randomIntBetween } from 'https://jslib.k6.io/k6-utils/1.2.0/index.js';
import { Httpx } from 'https://jslib.k6.io/httpx/0.1.0/index.js';

// const http = new Httpx({
//   baseUrl: 'http://localhost:4000'
// });

const http = new Httpx();

const pauseMin = 2;
const pauseMax = 6;

export const options = {
  discardResponseBodies: true,
  ext: {
    loadimpact: {
      projectID: 3651337,
      name: 'Zero to GraphQL Using Elixir',
      distribution: {
        'amazon:us:ashburn': { loadZone: 'amazon:us:ashburn', percent: 100 }
      },
      apm: [],
    },
  },
  thresholds: {
    // load_generator_memory_used_percent: [{ threshold: 'value<=80', abortOnFail: true }],
    // load_generator_cpu_percent: [{ threshold: 'value<=80', abortOnFail: true }],
    http_req_duration: ['p(95)<=1000'],
  },
  scenarios: {
    getPersonByID: {
      executor: 'ramping-vus',
      gracefulStop: '30s',
      stages: [
        { target: 20, duration: '1m' },
        { target: 20, duration: '3m30s' },
        { target: 0, duration: '1m' },
      ],
      gracefulRampDown: '30s',
      exec: 'getPersonByID',
    },
    getPeople: {
      executor: 'ramping-vus',
      gracefulStop: '30s',
      stages: [
        { target: 20, duration: '1m' },
        { target: 20, duration: '3m30s' },
        { target: 0, duration: '1m' },
      ],
      gracefulRampDown: '30s',
      exec: 'getPeople',
    },
  },
}

// Scenario: getPersonByID (executor: ramping-vus)

export function getPersonByID() {
  // Get Person By ID
  getPersonByID(randomIntBetween(1, 4))

  // Add random delay
  sleep(randomIntBetween(pauseMin, pauseMax))
}

export async function getPersonByID(id) {
  const query = gql`
    query GetPersonByID($id: ID!) {
      person(id: $id) {
        firstName
        lastName
        username
        email
        friends {
          firstName
          lastName
          username
          email
        }
      }
    }
  `;

  http.addHeader('Content-Type', 'application/json')

  const response = await http.asyncPost(
    'http://localhost:4000/graphql',
    JSON.stringify({
      query: query,
      variables: {
        id: id
      }
    },
    {
      tags: {
        name: 'getPersonByID'
      }
    })
  )

  check(response, {
    "status was 200": (r) => r.status === 200
  })
}

// Scenario: getPeople (executor: ramping-vus)

export function getPeople() {
  // Get People
  getPeople()

  // Add random delay
  sleep(randomIntBetween(pauseMin, pauseMax))
}

export async function getPeople() {
  const query = gql`
    query GetPeople {
      people {
        id
        firstName
        lastName
        username
        email
        friends {
          id
          firstName
          lastName
          username
          email
        }
      }
    }
  `;

  http.addHeader('Content-Type', 'application/json')

  const response = await http.asyncPost(
    'http://localhost:4000/graphql',
    JSON.stringify({
      query: query
    },
    {
      tags: {
        name: 'getPeople'
      }
    })
  )

  check(response, {
    "status was 200": (r) => r.status === 200
  })
}

export async function getRandomInt(min, max) {
  min = Math.ceil(min);
  max = Math.floor(max);
  return Math.floor(Math.random() * (max - min + 1)) + min;
}
