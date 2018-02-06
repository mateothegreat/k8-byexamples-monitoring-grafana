#                                 __                 __
#    __  ______  ____ ___  ____ _/ /____  ____  ____/ /
#   / / / / __ \/ __ `__ \/ __ `/ __/ _ \/ __ \/ __  /
#  / /_/ / /_/ / / / / / / /_/ / /_/  __/ /_/ / /_/ /
#  \__, /\____/_/ /_/ /_/\__,_/\__/\___/\____/\__,_/
# /____                     matthewdavis.io, holla!
#

NS                      ?= infra-monitoring
APP                     ?= grafana
IMAGE                   ?= grafana/grafana:5.0.0-beta1
INSTALL_PLUGINS         ?= grafana-clock-panel,grafana-simple-json-datasource,camptocamp-prometheus-alertmanager-datasource,ntop-ntopng-datasource,novalabs-annotations-panel,alexanderzobnin-zabbix-app
ADMIN_PASSWORD          ?= P@55w0rd!!
AWS_PROFILE             ?= default
AWS_ACCESS_KEY_ID       ?= YOUR_ACCESS_KEY
AWS_SECRET_ACCESS_KEY   ?= YOUR_SECRET_KEY
AWS_REGION              ?= us-west-1
GCE_ZONE				?= us-central1-a
GCE_DISK                ?= grafana-persistent-storage
export

## Install all resources
install:    install-deployment install-service install-dashboards-configmap install-dashboards-job
## Delete all resources
delete:     delete-deployment delete-service delete-dashboards-configmap delete-dashboards-job
## Dump the final spec (make dump <spec name> from the manifests dir for more)
dump:       dump-deployment dump-service

## Create GCE Persistent Disk
disks-create:

	gcloud compute disks create --zone=$(GCE_ZONE) --labels="purpose=k8" --size 10GB $(GCE_DISK)

## Get GCE Persistent Disk Configuration Status
disks-get:

	gcloud compute disks describe --zone=$(GCE_ZONE) $(GCE_DISK)

#
# Find first pod and follow log output
#
logs:

	kubectl --namespace $(NS) logs -f $(kubectl get pods --all-namespaces -lapp=$(APP) -o jsonpath='{.items[0].metadata.name}'))

# LIB
install-%:
	@envsubst < manifests/$*.yaml | kubectl --namespace $(NS) apply -f -

delete-%:
	@envsubst < manifests/$*.yaml | kubectl --namespace $(NS) delete --ignore-not-found -f -

status-%:
	@envsubst < manifests/$*.yaml | kubectl --namespace $(NS) rollout status -w -f -

dump-%:
	envsubst < manifests/$*.yaml

# Help Outputs
all:        help
GREEN  		:= $(shell tput -Txterm setaf 2)
YELLOW 		:= $(shell tput -Txterm setaf 3)
WHITE  		:= $(shell tput -Txterm setaf 7)
RESET  		:= $(shell tput -Txterm sgr0)
help:

	@echo "\nUsage:\n\n  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}\n\nTargets:\n"
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  ${YELLOW}%-20s${RESET} ${GREEN}%s${RESET}\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
	@echo
# EOLIB
