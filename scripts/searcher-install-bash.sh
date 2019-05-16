#!/bin/bash
# Install searcher application to Kubernetes Cluster
sudo su ec2-user -l
cd ~ && mkdir solumina-searcher && cd solumina-searcher
cat >solumina-searcher-deployment.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: solumina-searcher-deployment
  labels:
    app: solumina-searcher
spec:
  replicas: 3
  selector:
    matchLabels:
      app: solumina-searcher
  template:
    metadata:
      labels:
        app: solumina-searcher
    spec:
      containers:
      - name: solumina-searcher
        image: "977306392285.dkr.ecr.us-west-2.amazonaws.com/ibasetelksearch"
        ports:
        - containerPort: 9090
EOF

cat >solumina-searcher-service.yaml <<EOF
apiVersion: v1
kind: Service
metadata:
  name: solumina-searcher-service
spec:
  selector:
    app: solumina-searcher
  ports:
  - name: http
    protocol: TCP
    port: 80
    targetPort: 9090
  type: LoadBalancer
EOF

kubectl create -f solumina-searcher-deployment.yaml
kubectl create -f solumina-searcher-service.yaml