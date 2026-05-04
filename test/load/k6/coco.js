import http from 'k6/http';
import { check } from 'k6';

export const options = {
    thresholds: {
        http_req_failed: [{ threshold: 'rate<0.01', abortOnFail: true }], // http errors should be less than 1%
        http_req_duration: ['p(99)<1000'], // 99% of requests should be below 1s
    },
    scenarios: {
        average_load: {
            executor: 'ramping-vus',
            stages: [
                // ramp up to average load of 20 virtual users
                { duration: '10s', target: 20 },
                { duration: '15m', target: 200 },
                { duration: '10m', target: 300 },
                // // ramp down to zero
                { duration: '2m', target: 0 },
            ],
        },
    },
};

export default function () {
    const url = 'http://reverse-proxy.172.17.90.93.nip.io:31694/write?precision=n';
    const currentMillis = Date.now();
    const nanoTimestamp = (BigInt(currentMillis) * 1000000n).toString();
    let deviceId = crypto.randomUUID()
    const rawPayload = `
measurement,measurement_type=pedestrian,series_type=pedestrian-out,device_identity=${deviceId},api_key=admin_key unit="count",value=56i ${nanoTimestamp}
measurement,measurement_type=pedestrian,series_type=pedestrian-in,device_identity=${deviceId},api_key=admin_key unit="count",value=56i ${nanoTimestamp}`
    const params = {
        headers: {
            'Content-Type': 'text/plain',
            'Authorization': 'Basic YWRtaW46cGFzc3dvcmQ=',
        },
    };

    const res = http.post(url, rawPayload, params);
    check(res, {
        'response code was 201': (res) => res.status == 204,
    });
}