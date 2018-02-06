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

## Deploy

```sh
$ make delete install status-deployment

deployment "grafana-core" deleted
service "grafana" deleted
configmap "grafana-import-dashboards" deleted
job "grafana-import-dashboards" deleted

deployment "grafana-core" created
service "grafana" created
configmap "grafana-import-dashboards" created
job "grafana-import-dashboards" created

Waiting for rollout to finish: 0 of 1 updated replicas are available...
deployment "grafana-core" successfully rolled out
```

## Dump final specs that get applied:

```sh
a$ make dump
envsubst < manifests/deployment.yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: grafana-core
  namespace: infra-monitoring
  labels:
    app: grafana
    component: core
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: grafana
        component: core
    spec:
      containers:
      - image: grafana/grafana:5.0.0-beta1
        name: grafana-core
        imagePullPolicy: IfNotPresent
        # env:
        resources:
          # keep request = limit to keep this container in guaranteed class
          limits:
            cpu: 100m
            memory: 100Mi
          requests:
            cpu: 100m
            memory: 100Mi
        env:
          # The following env variables set up basic auth twith the default admin user and admin password.
          - name: GF_AUTH_BASIC_ENABLED
            value: "true"
          - name: GF_AUTH_ANONYMOUS_ENABLED
            value: "false"
          - name: GF_SECURITY_ADMIN_PASSWORD
            value: "P@55w0rd!!"
          - name: GF_INSTALL_PLUGINS
            value: "grafana-clock-panel,grafana-simple-json-datasource,camptocamp-prometheus-alertmanager-datasource,ntop-ntopng-datasource,novalabs-annotations-panel,alexanderzobnin-zabbix-app"
          - name: GF_AWS_PROFILES
            value: "default"
          - name: GF_AWS_default_ACCESS_KEY_ID
            value: "YOUR_ACCESS_KEY"
          - name: GF_AWS_default_SECRET_ACCESS_KEY
            value: "YOUR_SECRET_KEY"
          - name: GF_AWS_default_REGION
            value: "us-west-1"
          # - name: GF_AUTH_ANONYMOUS_ORG_ROLE
          #   value: Admin
          # does not really work, because of template variables in exported dashboards:
          # - name: GF_DASHBOARDS_JSON_ENABLED
          #   value: "true"
        readinessProbe:
          httpGet:
            path: /login
            port: 3000
          # initialDelaySeconds: 30
          # timeoutSeconds: 1
    #     volumeMounts:
    #     - name: grafana-persistent-storage
    #       mountPath: /var
    #   volumes:
    #   - name: grafana-persistent-storage
    #     emptyDir: {}
        volumeMounts:
          - name: grafana-persistent-storage
            mountPath: /var/lib/grafana
      volumes:
        - name: grafana-persistent-storage
          gcePersistentDisk:
            pdName: grafana-persistent-storage
            fsType: "ext4"
envsubst < manifests/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: grafana
  namespace: infra-monitoring
  labels:
    app: grafana
    component: core
spec:
  type: NodePort
  ports:
    - port: 80
      targetPort: 3000
  selector:
    app: grafana
    component: core
```

## See also

* http://docs.grafana.org/installation/docker/
