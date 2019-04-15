#!/bin/bash
#


for i in `seq 1 100`;do

echo "apiVersion: v1
kind: PersistentVolume
metadata:
  name: local-pv$i
spec:
  capacity:
    storage: 100Gi
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: local-storage
  local:
    path: /mnt/local-pv$i
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - k8sck   
    "  | kubectl apply -f -

done
