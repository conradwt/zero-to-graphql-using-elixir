import { sleep, check } from 'k6';
import { SharedArray } from 'k6/data';

var hostname = __ENV.hostname;
if (hostname == null) hostname = 'localhost:5157';

export const options = {
  stages: [
    { duration: '30s', target: 2000 }, // ramp up
    { duration: '2m',  target: 2000 }, // stable
    { duration: '30s', target: 0    }, // ramp-down to 0 users
  ]
}
