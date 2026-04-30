up:
	docker compose up -d prometheus grafana

down:
	docker compose down

test:
	k6 run insert.js

t-publish:
	K6_PROMETHEUS_RW_SERVER_URL="http://localhost:9090/api/v1/write" \
    && K6_PROMETHEUS_RW_TREND_STATS="p(95),p(99),min,max" \
    && k6 run --out experimental-prometheus-rw --out csv=test_results.csv insert.js

t-publish-cluster:
	K6_PROMETHEUS_RW_SERVER_URL="http://prometheus.172.17.90.93.nip.io:31694/api/v1/write" \
	&& K6_PROMETHEUS_RW_TREND_STATS="p(95),p(99),min,max" \
	&& k6 run --out experimental-prometheus-rw --out csv=test_results.csv insert.js
