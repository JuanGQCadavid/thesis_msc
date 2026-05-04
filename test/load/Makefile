
TAG_ID ?= general
up:
	docker compose up -d prometheus grafana

down:
	docker compose down

test:
	k6 run insert.js

# Test insert
ti:
	export K6_PROMETHEUS_RW_SERVER_URL="http://18.117.179.49:9090/api/v1/write" \
    && export K6_PROMETHEUS_RW_TREND_STATS="p(95),p(99),min,max" \
    && k6 run --out experimental-prometheus-rw --out csv=test_results.csv k6/insert.js --tag testid=${TAG_ID}

# Test Coco
tc:
	export K6_PROMETHEUS_RW_SERVER_URL="http://18.117.179.49:9090/api/v1/write" \
	&& export K6_PROMETHEUS_RW_TREND_STATS="p(95),p(99),min,max" \
	&& k6 run --out experimental-prometheus-rw --out csv=test_results.csv k6/coco.js --tag testid=${TAG_ID}

# Test Upgrade
tu:
	export K6_PROMETHEUS_RW_SERVER_URL="http://18.117.179.49:9090/api/v1/write" \
	&& export K6_PROMETHEUS_RW_TREND_STATS="p(95),p(99),min,max" \
	&& k6 run --out experimental-prometheus-rw --out csv=test_results.csv k6/upgrade.js --tag testid=${TAG_ID}

# Test Node lost
tn:
	export K6_PROMETHEUS_RW_SERVER_URL="http://18.117.179.49:9090/api/v1/write" \
	&& export K6_PROMETHEUS_RW_TREND_STATS="p(95),p(99),min,max" \
	&& k6 run --out experimental-prometheus-rw --out csv=test_results.csv k6/node-lost.js --tag testid=${TAG_ID}
