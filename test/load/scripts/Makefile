install:
	kubectl apply -f cron.yaml

stop:
	kubectl delete cronjob reset-db-api -n rollout-restarter

clean:
	kubectl delete -f cron.yaml