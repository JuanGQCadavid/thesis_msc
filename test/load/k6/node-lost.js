import http from 'k6/http';
import { check } from 'k6';

export const options = {
    scenarios: {
        average_load: {
            executor: 'ramping-vus',
            stages: [
                { duration: '2m', target: 15 },
                { duration: '30m', target: 15 },
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