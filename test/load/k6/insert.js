// import necessary module
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
                { duration: '10s', target: 20 },
                { duration: '3m', target: 40 },
                { duration: '2m', target: 60 },
                { duration: '2m', target: 80 },
                { duration: '2m', target: 100 },
                { duration: '2m', target: 120 },
                { duration: '2m', target: 140 },
                { duration: '2m', target: 180 },
                { duration: '2m', target: 200 },
                { duration: '10m', target: 300 },
                // // ramp down to zero
                { duration: '2m', target: 0 },
            ],
        },
    },
};

export default function () {
    const url = 'http://db-api.172.17.90.93.nip.io:31694/measurement';
    const deviceId = "128497"
    let time = new Date();
    const payload = JSON.stringify({
        "measurements": [
            {
                "time": time.toISOString(),
                "device_identity": deviceId,
                "measurement_type": "pedestrian",
                "series": [
                    {
                        "series_type": "pedestrian-out",
                        "unit": "count",
                        "value": 100
                    },
                    {
                        "series_type": "pedestrian-in",
                        "unit": "count",
                        "value": 77
                    }
                ]
            },
            {
                "time": time.toISOString(),
                "device_identity": deviceId,
                "measurement_type": "pedestrian",
                "series": [
                    {
                        "series_type": "pedestrian-out",
                        "unit": "count",
                        "value": 55
                    },
                    {
                        "series_type": "pedestrian-in",
                        "unit": "count",
                        "value": 44
                    }
                ]
            }
        ]
    });

    const params = {
        headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Basic YWRtaW5fa2V5OkFETUlOX1RPS0VO',
            'api_key': 'ADMIN_TOKEN',
        },
    };

    const res = http.post(url, payload, params);
    check(res, {
        'response code was 201': (res) => res.status == 201,
    });
}