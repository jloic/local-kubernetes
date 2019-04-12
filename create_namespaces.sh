#!/bin/bash
#
# Script based on https://jeremievallee.com/2018/05/28/kubernetes-rbac-namespace-user.html
#
# In honor of the remarkable Windson

BASEDIR="$(dirname "$0")/.."
folder="$BASEDIR/generated"

namespace=$1
endpoint=$(echo "$2" | sed -e 's,https\?://,,g')

if [[ -z "$endpoint" || -z "$namespace" ]]; then
	echo "Use "$(basename "$0")" NAMESPACE ENDPOINT";
	exit 1;
fi


kubectl create namespace $namespace

echo "---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: $namespace-user
  namespace: $namespace
---
kind: Role
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: $namespace-user-full-access
  namespace: $namespace
rules:
- apiGroups: ['', 'extensions', 'apps']
  resources: ['*']
  verbs: ['*']
- apiGroups: ['batch']
  resources:
  - jobs
  - cronjobs
  verbs: ['*']
---
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: $namespace-user-view
  namespace: $namespace
subjects:
- kind: ServiceAccount
  name: $namespace-user
  namespace: $namespace
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: $namespace-user-full-access" | kubectl apply -f -

mkdir -p $folder
tokenName=$(kubectl get sa $namespace-user -n $namespace -o "jsonpath={.secrets[0].name}")
token=$(kubectl get secret $tokenName -n $namespace -o "jsonpath={.data.token}" | base64 --decode)
certificate=$(kubectl get secret $tokenName -n $namespace -o "jsonpath={.data['ca\.crt']}")

echo "apiVersion: v1
kind: Config
preferences: {}
clusters:
- cluster:
    certificate-authority-data: $certificate
    server: https://$endpoint
  name: $namespace-cluster

users:
- name: $namespace-user
  user:
    as-user-extra: {}
    client-key-data: $certificate
    token: $token

contexts:
- context:
    cluster: $namespace-cluster
    namespace: $namespace
    user: $namespace-user
  name: $namespace

current-context: $namespace" > $folder/$namespace.kube.conf
