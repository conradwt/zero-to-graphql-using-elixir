import { check, sleep } from 'k6';
import { randomIntBetween } from 'https://jslib.k6.io/k6-utils/1.4.0/index.js';
import { Httpx } from 'https://jslib.k6.io/httpx/0.1.0/index.js';
import { SharedArray } from 'k6/data';

var hostname = __ENV.hostname;
if (hostname == null) hostname = 'localhost:4000';

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
    http_req_duration: ['p(95)<=100'], // 95% of the requests must complete
    http_req_duration: ['p(99)<=100'], // 99% of the requests must complete
  },
  scenarios: {
    getPersonByID: {
      executor: 'shared-iterations',
      gracefulStop: '30s',
      stages: [
        { duration: '1m', target: 200 }, // ramp up
        { duration: '5m', target: 200 }, // stable
        { duration: '1m', target: 800 }, // ramp up
        { duration: '5m', target: 800 }, // stable
        { duration: '1m', target: 1000 }, // ramp up
        { duration: '5m', target: 1000 }, // stable
        { duration: '5m', target: 0 }, // ramp down to 0 users
      ],
      gracefulRampDown: '30s',
      exec: 'getPersonByID',
    },
    getPeople: {
      executor: 'shared-iterations',
      gracefulStop: '30s',
      stages: [
        { duration: '1m', target: 200 }, // ramp up
        { duration: '5m', target: 200 }, // stable
        { duration: '1m', target: 800 }, // ramp up
        { duration: '5m', target: 800 }, // stable
        { duration: '1m', target: 1000 }, // ramp up
        { duration: '5m', target: 1000 }, // stable
        { duration: '5m', target: 0 }, // ramp down to 0 users
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
