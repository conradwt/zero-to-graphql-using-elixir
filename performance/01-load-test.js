import { check, sleep } from 'k6';
import { randomIntBetween } from 'https://jslib.k6.io/k6-utils/1.2.0/index.js';
import { Httpx } from 'https://jslib.k6.io/httpx/0.1.0/index.js';

const http = new Httpx({
  baseURL: 'http://localhost:4000',
  headers: {
    'Content-Type': 'application/json',
  },
});

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
    http_req_failed: [{ threshold: 'rate<0.01', abortOnFail: true }], // http errors should be less than 1%, otherwise abort the test
    http_req_duration: ['p(95) <= 100'], // 95% of the requests must complete in 100ms.
    http_req_duration: ['p(99) <= 100'], // 99% of the requests must complete in 100ms.
  },
  scenarios: {
    getPersonByID: {
      executor: 'ramping-vus',
      // gracefulStop: '30s',
      startVUs: 0,
      stages: [
        { duration: '1m',    target: 20 }, // ramp up
        { duration: '1m30s', target: 20 }, // stable
        { duration: '1m',    target: 0  }, // ramp down to 0 users
      ],
      // gracefulRampDown: '30s',
      gracefulRampDown: '0s',
      exec: 'getPersonByID',
    },
    getPeople: {
      executor: 'ramping-vus',
      // gracefulStop: '30s',
      startVUs: 0,
      stages: [
        { duration: '1m',    target: 20 }, // ramp up
        { duration: '1m30s', target: 20 }, // stable
        { duration: '1m',    target: 0  }, // ramp down to 0 users
      ],
      // gracefulRampDown: '30s',
      gracefulRampDown: '0s',
      exec: 'getPeople',
    },
  },
}

// Scenario: getPersonByID (executor: ramping-vus)

export function getPersonByID() {
  // Get Person By ID
  _getPersonByID(randomIntBetween(1, 4))

  // Add random delay
  sleep(randomIntBetween(pauseMin, pauseMax))
}

export async function _getPersonByID(id) {
  const query = `
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

  const response = await http.asyncPost(
    '/graphql',
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

  // check that response is 200
  check(response, {
    "status was 200": (r) => r.status === 200
  })
}

// Scenario: getPeople (executor: ramping-vus)

export function getPeople() {
  // Get People
  _getPeople()

  // Add random delay
  sleep(randomIntBetween(pauseMin, pauseMax))
}

export async function _getPeople() {
  const query = `
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

  const response = await http.asyncPost(
    '/graphql',
    JSON.stringify({
      query: query
    },
    {
      tags: {
        name: 'getPeople'
      }
    })
  )

  // check that response is 200
  check(response, {
    "status was 200": (r) => r.status === 200
  })
}

export async function getRandomInt(min, max) {
  min = Math.ceil(min);
  max = Math.floor(max);
  return Math.floor(Math.random() * (max - min + 1)) + min;
}
