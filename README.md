<!--
#                                 __                 __
#    __  ______  ____ ___  ____ _/ /____  ____  ____/ /
#   / / / / __ \/ __ `__ \/ __ `/ __/ _ \/ __ \/ __  /
#  / /_/ / /_/ / / / / / / /_/ / /_/  __/ /_/ / /_/ /
#  \__, /\____/_/ /_/ /_/\__,_/\__/\___/\____/\__,_/
# /____                     matthewdavis.io, holla!
#
#-->

[![Clickity click](https://img.shields.io/badge/k8s%20by%20example%20yo-limit%20time-ff69b4.svg?style=flat-square)](https://k8.matthewdavis.io)
[![Twitter Follow](https://img.shields.io/twitter/follow/yomateod.svg?label=Follow&style=flat-square)](https://twitter.com/yomateod) [![Skype Contact](https://img.shields.io/badge/skype%20id-appsoa-blue.svg?style=flat-square)](skype:appsoa?chat)

# monitoring ain't easy.

> k8 by example -- straight to the point, simple execution.

Deploy and grafana will be up and running at http://grafana.infra-monitoring.svc.cluster.local.

Still proxy'ing to get access to your cluster?!
Take a poke at https://github.com/mateothegreat/k8-byexamples-openvpn, secure? dns? lan access? wat?

## Usage

```sh
$ make help

Usage:

  make <target>

Targets:

  install              Install all resources
  delete               Delete all resources
  dump                 Dump the final spec (make dump <spec name> from the manifests dir for more)
  disks-create         Create GCE Persistent Disk
  disks-get            Get GCE Persistent Disk Configuration Status
```

## Install

```sh
$ make install ADMIN_PASSWORD=changeme

[ INSTALLING MANIFESTS/DASHBOARDS-CONFIGMAP.YAML ]: configmap "grafana-import-dashboards" created
[ INSTALLING MANIFESTS/DASHBOARDS-JOB.YAML ]: job "grafana-import-dashboards" created
[ INSTALLING MANIFESTS/DEPLOYMENT.YAML ]: deployment "grafana-core" created
[ INSTALLING MANIFESTS/INGRESS.YAML ]: error: no objects passed to apply
[ INSTALLING MANIFESTS/PERSISTENTVOLUMECLAIM.YAML ]: persistentvolumeclaim "grafana-persistent-storage" created
[ INSTALLING MANIFESTS/SERVICE.YAML ]: service "grafana" created
```

```sh

```

## Delete

```sh
$ make delete

[ DELETING MANIFESTS/DASHBOARDS-CONFIGMAP.YAML ]: configmap "grafana-import-dashboards" deleted
[ DELETING MANIFESTS/DASHBOARDS-JOB.YAML ]: job "grafana-import-dashboards" deleted
[ DELETING MANIFESTS/DEPLOYMENT.YAML ]: deployment "grafana-core" deleted
[ DELETING MANIFESTS/INGRESS.YAML ]: No resources found
[ DELETING MANIFESTS/PERSISTENTVOLUMECLAIM.YAML ]: persistentvolumeclaim "grafana-persistent-storage" deleted
[ DELETING MANIFESTS/SERVICE.YAML ]: service "grafana" deleted
```

## See also

* http://docs.grafana.org/installation/docker/
