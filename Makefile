#                                 __                 __
#    __  ______  ____ ___  ____ _/ /____  ____  ____/ /
#   / / / / __ \/ __ `__ \/ __ `/ __/ _ \/ __ \/ __  /
#  / /_/ / /_/ / / / / / / /_/ / /_/  __/ /_/ / /_/ /
#  \__, /\____/_/ /_/ /_/\__,_/\__/\___/\____/\__,_/
# /____                     matthewdavis.io, holla!
#
include .make/Makefile.inc

NS                      ?= default
APP                     ?= grafana
IMAGE                   ?= grafana/grafana:latest
INSTALL_PLUGINS         ?= grafana-clock-panel,grafana-simple-json-datasource,camptocamp-prometheus-alertmanager-datasource,ntop-ntopng-datasource,novalabs-annotations-panel,alexanderzobnin-zabbix-app
ADMIN_PASSWORD          ?= P@55w0rd!!
AWS_PROFILE             ?= default
AWS_ACCESS_KEY_ID       ?= YOUR_ACCESS_KEY
AWS_SECRET_ACCESS_KEY   ?= YOUR_SECRET_KEY
AWS_REGION              ?= us-west-1
GCE_ZONE				?= asia-southeast1-a
GCE_DISK                ?= grafana-persistent-storage

## Create disk
create-disk:

	gcloud compute disks create $(GCE_DISK) --zone $(GCE_ZONE)

## Test installation
test:

	@echo "$(GREEN)"

	nslookup grafana

	@echo "$(RESET)"
